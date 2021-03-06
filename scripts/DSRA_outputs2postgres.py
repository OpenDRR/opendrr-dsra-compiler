#!/usr/bin/env python
import sqlalchemy as db
import sqlalchemy.orm as orm
import pandas as pd
import numpy as np
from io import StringIO
from functools import reduce
import csv
import glob 
import os
import sys
import argparse
import configparser
import requests
import json
import logging

'''
Script to ingest OpenQuake outputs in csv format from GtHub to single PostGreSQL database. The Script can be run in the following form by 
changing the filepaths as appropriate
python DSRA_outputs2postgres.py --dsraModelDir="https://github.com/OpenDRR/opendrr-data-store/tree/master/sample-datasets/model-outputs/scenario-risk" --columnsINI="C:\github\OpenDRR\model-factory\scripts\DSRA_outputs2postgres.ini"
'''

def main():
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s', 
                        handlers=[logging.FileHandler('{}.log'.format(os.path.splitext(sys.argv[0])[0])),
                                  logging.StreamHandler()])
    logging.getLogger('sqlalchemy').setLevel(logging.ERROR)
    args = parse_args()
    columnConfigParser = get_config_params(args.columnsINI)

    os.chdir(sys.path[0])
    auth = get_config_params('config.ini')
    listRetrofit = list(filter(None, (x.strip() for x in columnConfigParser.get('Retrofit', 'listRetrofit').splitlines())))
    listRetrofitPrefix = list(filter(None, (x.strip() for x in columnConfigParser.get('Retrofit', 'listRetrofitPrefix').splitlines())))
    listeqScenario = list(filter(None, (x.strip() for x in columnConfigParser.get('Scenario','listScenario').splitlines())))
    listRealizationFieldnames = list(filter(None, (x.strip() for x in columnConfigParser.get('Realizations','listRealizationFieldnames').splitlines()))) 
    engine = db.create_engine('postgresql://{}:{}@{}'.format(auth.get('rds', 'postgres_un'), auth.get('rds', 'postgres_pw'), auth.get('rds', 'postgres_address')), echo=False)

    url = args.dsraModelDir.replace('https://github.com', 'https://api.github.com/repos').replace('tree/master', 'contents')
    try:
        response = requests.get(url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        response.raise_for_status()
        repo_dict = json.loads(response.content)
        repo_list = []

        for item in repo_dict:
            if item['type'] == 'file':
                repo_list.append(item['name'])
    
    except requests.exceptions.RequestException as e:
        logging.error(e)
        sys.exit()

    
    for eqscenario in listeqScenario:
        listRealization = [s for s in repo_list if "realizations_{}".format(eqscenario) in s]
        item_url="{}/{}".format(url, listRealization[0])
        try:
            response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
            item_dict = json.loads(response.content)
            response = requests.get(item_dict['download_url'], headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
        except requests.exceptions.RequestException as e:
            logging.error(e)
            sys.exit()
        else:
            dfRealizations = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                            sep=',',
                            index_col=False,
                            usecols=listRealizationFieldnames,
                            low_memory=False,
                            thousands=',')
            
        dfsr ={}
        for realization in dfRealizations.iterrows():
            for retrofit, retrofitPrefix in zip(listRetrofit, listRetrofitPrefix):
                # retrofit Realization dataframe 
                dfsr[retrofit] = GetDataframeForRealizationForScenario(url, repo_list, retrofitPrefix, realization, eqscenario, columnConfigParser, auth)
                # Process conditional fields for retrofit realization dataframe
                #retrofitExtras(dfsr, retrofit, index)
            
            # Merge retrofit dataframes for a realization
            dfs = []
            for i in listRetrofit:
                dfs.append(dfsr[i])
            dffinal = reduce(pd.merge, dfs)
            
            # Add calculated fields applicable to the realization
            realizationExtras(eqscenario, dfRealizations, str(realization[0]), dffinal)
            
            # add in ordered output code
            #listFieldnamesOrdered = CreateOrderedFieldList(len(listScenario))
            dffinalout = dffinal
            #dffinalout = dffinal[listFieldnamesOrdered]
            
            
            # Output assembled dataframe to CSV file
            dffinalout.to_sql("dsra_{}_rlz_{}".format(eqscenario.lower(), str(realization[0])),
                                engine,
                                if_exists='replace',
                                method=psql_insert_copy,
                                schema='dsra')   

    return


def GetDataframeForRealizationForScenario(url, repo_list, retrofitPrefix, realization, eqscenario, columnConfigParser, auth):
    # Get file names. If there is more than one match this should grab the one with the higher increment value
    consequenceFile = [s for s in repo_list if "s_consequences_{}_{}_00{}".format(eqscenario, retrofitPrefix, realization[0]) in s][-1]
    damageFile = [s for s in repo_list if "s_dmgbyasset_{}_{}_00{}".format(eqscenario, retrofitPrefix, realization[0]) in s][-1]
    lossesFile = [s for s in repo_list if "s_lossesbyasset_{}_{}_00{}".format(eqscenario, retrofitPrefix, realization[0]) in s][-1]
    
    # Create dataframes
    #Consequence DataFrame
    item_url="{}/{}".format(url, consequenceFile)
    item_url = item_url.replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
    response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    # item_dict = json.loads(response.content)
    # response = requests.get(item_dict['download_url'], headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    consequenceFieldNames = list(filter(None, [x.strip().split(",") for x in columnConfigParser.get('Consequences', 'consequenceFieldNames').splitlines()]))
    consequenceInputFieldNames, consequenceOutputFieldNames = zip(*consequenceFieldNames)
    dfConsequence = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                    sep=',',
                    index_col=False,
                    usecols=consequenceInputFieldNames,
                    low_memory=False,
                    thousands=',')
    [dfConsequence.rename(columns={oldcol:newcol}, inplace=True) for oldcol, newcol in zip(consequenceInputFieldNames, consequenceOutputFieldNames)]
    #dfConsequence.insert(loc=2, column='BldgCostT', value=dfConsequence['value_structural'] + dfConsequence['value_nonstructural'] + dfConsequence['value_contents'])
    #dfConsequence.drop(columns=['value_structural','value_nonstructural','value_contents'], inplace=True)
    dfConsequence = dfConsequence.add_suffix("_{}".format(retrofitPrefix))
    dfConsequence.rename(columns={"AssetID_{}".format(retrofitPrefix):"AssetID"}, inplace=True)

    #Damage dataframe,
    item_url="{}/{}".format(url, damageFile)
    item_url = item_url.replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
    response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    # item_dict = json.loads(response.content)
    # response = requests.get(item_dict['download_url'], headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    damageFieldNames = list(filter(None, [x.strip().split(",") for x in columnConfigParser.get('Damage', 'damageFieldNames').splitlines()]))
    damageInputFieldNames, damageOutputFieldNames = zip(*damageFieldNames)
    dfDamage = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                    sep=',',
                    index_col=False,
                    usecols=damageInputFieldNames,
                    low_memory=False,
                    thousands=',')
    [dfDamage.rename(columns={oldcol:newcol}, inplace=True) for oldcol, newcol in zip(damageInputFieldNames, damageOutputFieldNames)]
    #dfDamage.insert(loc=4, column='sauid_t', value=dfDamage['sauid_i'])
    dfDamage = dfDamage.add_suffix("_{}".format(retrofitPrefix))
    dfDamage.rename(columns={"AssetID_{}".format(retrofitPrefix):"AssetID"}, inplace=True)

    #Losses Dataframe
    item_url="{}/{}".format(url, lossesFile)
    item_url = item_url.replace('api.github.com/repos', 'raw.githubusercontent.com').replace('/contents/','/master/')
    response = requests.get(item_url, headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    # item_dict = json.loads(response.content)
    # response = requests.get(item_dict['download_url'], headers={'Authorization': 'token {}'.format(auth.get('auth', 'github_token'))})
    lossesFieldNames = list(filter(None, [x.strip().split(",") for x in columnConfigParser.get('Losses', 'lossesFieldNames').splitlines()]))
    lossesInputFieldNames, lossesOutputFieldNames = zip(*lossesFieldNames)
    dfLosses = pd.read_csv(StringIO(response.content.decode(response.encoding)),
                    sep=',',
                    index_col=False,
                    usecols=lossesInputFieldNames,
                    low_memory=False,
                    thousands=',')
    [dfLosses.rename(columns={oldcol:newcol}, inplace=True) for oldcol, newcol in zip(lossesInputFieldNames, lossesOutputFieldNames)]
    # dfLosses['sl_BldgT'] = dfLosses['sl_Str'] + dfLosses['sl_NStr'] + dfLosses['sl_Cont']  
    dfLosses = dfLosses.add_suffix("_{}".format(retrofitPrefix))
    dfLosses.rename(columns={"AssetID_{}".format(retrofitPrefix):"AssetID"}, inplace=True)
    
    # Merge dataframes
    dfMerge = reduce(lambda left,right: pd.merge(left,right,on='AssetID'), [dfDamage, dfConsequence, dfLosses])
    return dfMerge

def realizationExtras(eqscenario, dfRealizations, realization_no, final_df):
    # rupture value
    idx = 0
    col = 'Rupture_Abbr'
    val = eqscenario
    final_df.insert(loc=idx, column=col, value=val)
    # Branch Number
    idx = 1
    col = 'Realization'
    val = realization_no
    final_df.insert(loc=idx, column=col, value=val)
    # Ground Motion Model
    idx = 2
    col = 'gmpe_Model'
    val = dfRealizations.loc[dfRealizations['ordinal'] == int(realization_no), 'branch_path'].item()
    final_df.insert(loc=idx, column=col, value=val)
    # Branch Weighting
    idx = 3
    col = 'Weight'
    val = dfRealizations.loc[dfRealizations['ordinal'] == int(realization_no), 'weight'].item()
    final_df.insert(loc=idx, column=col, value=val)
    
    return    
    
   
def psql_insert_copy(table, conn, keys, data_iter):
    # This fuction was copied from the Pandas documentation
    # gets a DBAPI connection that can provide a cursor
    dbapi_conn = conn.connection
    with dbapi_conn.cursor() as cur:
        s_buf = StringIO()
        writer = csv.writer(s_buf)
        writer.writerows(data_iter)
        s_buf.seek(0)
        columns = ', '.join('"{}"'.format(k) for k in keys)
        if table.schema:
            table_name = '{}.{}'.format(table.schema, table.name)
        else:
            table_name = table.name
        sql = 'COPY {} ({}) FROM STDIN WITH CSV'.format(
            table_name, columns)
        cur.copy_expert(sql=sql, file=s_buf)


def get_config_params(args):
    """
    Parse Input/Output columns from supplied *.ini file
    """
    configParseObj = configparser.ConfigParser()
    configParseObj.read(args)
    return configParseObj

def parse_args():
    parser = argparse.ArgumentParser(description='Pull DSRA Output data from Github repository and copy into PostGreSQL on AWS RDS')
    parser.add_argument('--dsraModelDir', type=str, help='Path to DSRA Model repo', required=True)
    parser.add_argument('--columnsINI', type=str, help='DSRA_outputs2postgres.ini', required=True, default='DSRA_outputs2postgres.ini')
    args = parser.parse_args()
    
    return args

if __name__ == '__main__':
    main() 