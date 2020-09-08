-- script to generate GHSL table

DROP TABLE IF EXISTS ghsl.ghsl_mh_intensity_ghsl;

-- create table
CREATE TABLE ghsl.mh_intensity_ghsl(
ghslID varchar,
lon float, 
lat float, 
ghsl_km2 float,
ghsl_ha float,
Pop_2015 float,
Pop_2000 float, 
Pop_1990 float, 
Pop_1975 float, 
SMOD_2015 float, 
SMOD_2000 float, 
SMOD_1990 float, 
SMOD_1975 float, 
PGV float, 
PGA float, 
MMI7 float, 
Tsunami float, 
Fld500 float, 
Wildfire float, 
LndSus float, 
Cy500 float,
CSDUID varchar,
CSDNAME varchar,
CSDTYPE varchar,
PRUID varchar,
PRNAME varchar,
CDUID varchar,
CDNAME varchar,
CDTYPE varchar,
CCSUID varchar,
CCSNAME varchar,
ERUID varchar,
ERNAME varchar,
SACCODE varchar,
SACTYPE varchar,
NEAR_FID varchar
);

-- import exposure from csv
COPY ghsl.ghsl_mh_intensity_ghsl (ghslID,lon,lat,ghsl_km2,ghsl_ha,Pop_2015,Pop_2000,Pop_1990,Pop_1975,SMOD_2015,SMOD_2000,SMOD_1990,SMOD_1975,PGV,PGA,MMI7,Tsunami,Fld500,Wildfire,LndSus,Cy500,CSDUID,CSDNAME,CSDTYPE,PRUID,PRNAME,CDUID,CDNAME,CDTYPE,CCSUID,CCSNAME,ERUID,ERNAME,SACCODE,SACTYPE,NEAR_FID)
    FROM '/usr/src/app/mh-intensity-ghsl.csv'
        WITH 
          DELIMITER AS ','
          CSV HEADER ;

-- add geometries field to enable PostGIS (WGS1984 SRID = 4326)
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl ADD COLUMN geom geometry(Point,4326);
UPDATE ghsl.ghsl_mh_intensity_ghsl SET geom = st_setsrid(st_makepoint(lon,lat),4326);

-- create spatial index
CREATE INDEX ghsl_mh_intensity_ghsl_idx
ON ghsl.ghsl_mh_intensity_ghsl using GIST (geom);

-- some issue with the original source dataset, nulll values are present in ghslid. erase all null ghslid. 
DELETE FROM ghsl.ghsl_mh_intensity_ghsl WHERE ghslid IS NULL;

-- add pkey
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl DROP CONSTRAINT IF EXISTS ghsl_mh_intensity_ghsl_pkey;
ALTER TABLE ghsl.ghsl_mh_intensity_ghsl ADD PRIMARY KEY(ghslID);