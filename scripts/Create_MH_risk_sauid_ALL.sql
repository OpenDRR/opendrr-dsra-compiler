-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_hazard_threat;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_mh_mh_intensity_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_mh_mh_intensity_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.1 Multi-Hazard Threat
-- 4.1.1 Multi-Hazard Intensity
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "MHn_Intensity",
(SELECT "MHInt_t" FROM mh.mh_thresholds) AS "MHt_Intensity", -- Multi-Hazard Intensity threshold

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN mh.mh_intensity_canada_mhsum b ON a.sauid = b.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
GROUP BY a.sauid,b.mh_sum,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_mh_threat_to_buildings_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_mh_threat_to_buildings_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.1 Multi-Hazard Threat
-- 4.1.1 Threat to Buildings
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.number) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "MHt_Bldgs",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_ResLD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_ResMD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_ResHD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Commercial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_Comm",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Industrial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_Ind",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Civic' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_Civic",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Agricultural' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_Agr",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Wood' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_Wood",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Concrete' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_Concrete",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Precast' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_PreCast",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='RMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_RMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='URMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_URMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Steel' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_Steel",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Manufactured' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "MHt_Manufactured",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN mh.mh_intensity_canada_mhsum b ON a.sauid = b.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
GROUP BY a.sauid,b.mh_sum,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_mh_threat_to_people_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_mh_threat_to_people_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.1 Multi-Hazard Threat
-- 4.1.3 Threat to People
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN c.censuspop ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_CensusPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.day) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_DayPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.night) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_NightPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.transit) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_TransitPopT",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) / c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_SFHshlds",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN (SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) + 
SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END)) / c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_MFHshlds",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN mh.mh_intensity_canada_mhsum b ON a.sauid = b.sauidt
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
GROUP BY a.sauid,b.mh_sum,c.censuspop,c.people_du,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_mh_threat_to_assets_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_mh_threat_to_assets_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.1 Multi-Hazard Threat
-- 4.1.4 Threat to Assets
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural + a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_AssetCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_BldgCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.structural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_StrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_NStrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN ((b.mh_sum - (SELECT mhsum_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT mhsum_max FROM mh.mh_intensity_canada_minmax) - 
(SELECT mhsum_min FROM mh.mh_intensity_canada_minmax),0)) >= (SELECT "MHInt_t" FROM mh.mh_thresholds) THEN SUM(a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) 
AS "Mht_ContCost",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN mh.mh_intensity_canada_mhsum b ON a.sauid = b.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
GROUP BY a.sauid,b.mh_sum,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_eq_seismic_hazard_intensity_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_eq_seismic_hazard_intensity_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.2 Earthquake Threat
-- 4.2.1 Seismic Hazard Intensity
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST((e.pgv - (SELECT pgv_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT pgv_max FROM mh.mh_intensity_canada_minmax) - (SELECT pgv_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQn_PGVn",
COALESCE(CAST(CAST(ROUND(CAST((e.pga - (SELECT pga_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT pga_max FROM mh.mh_intensity_canada_minmax) - (SELECT pga_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQn_PGAn",
(SELECT "PGAt" FROM mh.mh_thresholds) AS "Eqt_PGAt", -- Peak Ground Acceleration threshold

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.pgv,e.pga,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_eq_threat_to_buildings_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_eq_threat_to_buildings_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.2 Earthquake Threat
-- 4.2.2 Threat to Buildings
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.number) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Bldgs",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_ResLD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_ResMD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_ResHD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Commercial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Comm",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Industrial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Ind",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Civic' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Civic",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Agricultural' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Agr",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Wood' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Wood",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Concrete' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Concrete",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Precast' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_PreCast",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='RMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_RMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='URMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_URMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Steel' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Steel",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Manufactured' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Manufactured",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.pga,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_eq_threat_to_people_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_eq_threat_to_people_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.2 Earthquake Threat
-- 4.2.3 Threat to People
SELECT 
a.sauid AS "Sauid",
COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN c.censuspop ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_Pop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.day) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_DayPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.night) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_NightPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.transit) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_TransitPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) / c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_SFHshlds",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN (SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) + SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END)) / 
c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_MFHshlds",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,c.censuspop,c.people_du,e.pga,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_eq_threat_to_assets_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_eq_threat_to_assets_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.2 Earthquake Threat
-- 4.2.4 Threat to Assets
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural + a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_AssetCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_BldgCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.structural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_StrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_NStrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.pga >= (SELECT "PGAt" FROM mh.mh_thresholds) THEN SUM(a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "EQt_ContCost",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.pga,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_ts_threat_ts_inundation_hazard_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_ts_threat_ts_inundation_hazard_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.3 Tsunami Threat
-- 4.3.1 Tsunami Inundation Hazard
SELECT 
a.sauid AS "Sauid",

CAST(CAST(ROUND(CAST(e.tsun_ha AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "TSn_PGV",
COALESCE(CAST(CAST(ROUND(CAST((e.tsun_ha - (SELECT tsun_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT tsun_max FROM mh.mh_intensity_canada_minmax) - (SELECT tsun_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "TSn_PGA",
(SELECT "Tsun_t" FROM mh.mh_thresholds) AS "TSt_PGA", -- Tsunami Hazard threshold

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.tsun_ha,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_ts_threat_to_buildings_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_ts_threat_to_buildings_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.3 Tsunami Threat
-- 4.3.2 Threat to Buildings
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.number) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Bldgs",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_ResLD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_ResMD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_ResHD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Commercial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Comm",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Industrial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Ind",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Civic' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Civic",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Agricultural' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Agr",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Wood' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Wood",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Concrete' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Concrete",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Precast' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_PreCast",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='RMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_RMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='URMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_URMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Steel' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Steel",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Manufactured' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Manufactured",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.tsun_ha,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_ts_threat_to_people_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_ts_threat_to_people_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.3 Tsunami Threat
-- 4.3.3 Threat to People
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN c.censuspop ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_Pop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.day) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_DayPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.night) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_NightPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.transit) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_TransitPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) / c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_SFHshlds",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN (SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) + SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END)) / 
c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_MFHshlds",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
--LEFT JOIN mh.mh_intensity_canada_mhsum b ON a.sauid = b.sauidt
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,c.censuspop,c.people_du,e.tsun_ha,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_ts_threat_to_assets_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_ts_threat_to_assets_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.3 Tsunami Threat
-- 4.3.4 Threat to Assets
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural + a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_AssetCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_BldgCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.structural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_StrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_NStrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.tsun_ha >= (SELECT "Tsun_t" FROM mh.mh_thresholds) THEN SUM(a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Tst_ContCost",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.tsun_ha,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_fl_threat_fl_inundation_hazard_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_fl_threat_fl_inundation_hazard_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.4 Flood Threat
-- 4.4.1 Flood Inundation Hazard
SELECT 
a.sauid AS "Sauid",

CAST(CAST(ROUND(CAST(e.fl200 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "FL_200",
COALESCE(CAST(CAST(ROUND(CAST((e.fl200 - (SELECT fl200_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT fl200_max FROM mh.mh_intensity_canada_minmax) - (SELECT fl200_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLn_200",
CAST(CAST(ROUND(CAST(e.fl500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "FL_500",
COALESCE(CAST(CAST(ROUND(CAST((e.fl500 - (SELECT fl500_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT fl500_max FROM mh.mh_intensity_canada_minmax) - (SELECT fl500_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLn_500",
(SELECT "Fl500t" FROM mh.mh_thresholds) AS "FLt_500", -- 500yr Flood Hazard threshold
CAST(CAST(ROUND(CAST(e.fl1000 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "FL_1000",
COALESCE(CAST(CAST(ROUND(CAST((e.fl1000 - (SELECT fl1000_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT fl1000_max FROM mh.mh_intensity_canada_minmax) - (SELECT fl1000_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLn_1000",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.fl200,e.fl500,e.fl1000,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_fl_threat_to_buildings_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_fl_threat_to_buildings_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.4 Flood Threat
-- 4.4.2 Threat to Buildings
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.number) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Bldgs",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_ResLD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_ResMD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_ResHD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Commercial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Comm",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Industrial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Ind",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Civic' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Civic",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Agricultural' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Agr",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Wood' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Wood",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Concrete' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Concrete",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Precast' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_PreCast",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='RMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_RMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='URMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_URMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Steel' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Steel",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Manufactured' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Manufactured",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.fl500,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_fl_threat_to_people_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_fl_threat_to_people_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.4 Flood Threat
-- 4.4.3 Threat to People
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN c.censuspop ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_Pop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.day) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_DayPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.night) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_NightPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.transit) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_TransitPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) / c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_SFHshlds",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN (SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) + SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END)) / 
c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_MFHshlds",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,c.censuspop,c.people_du,e.fl500,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_fl_threat_to_assets_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_fl_threat_to_assets_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.4 Flood Threat
-- 4.4.4 Threat to Assets
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural + a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_AssetCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_BldgCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.structural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_StrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_NStrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fl500 >= (SELECT "Fl500t" FROM mh.mh_thresholds) THEN SUM(a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "FLt_ContCost",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.fl500,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_wf_threat_wf_hazard_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_wf_threat_wf_hazard_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.5 Wildfire Threat
-- 4.5.1 Wildfire Hazard
SELECT 
a.sauid AS "Sauid",

CAST(CAST(ROUND(CAST(e.fire AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "WFi",
COALESCE(CAST(CAST(ROUND(CAST((e.fire - (SELECT fire_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT fire_max FROM mh.mh_intensity_canada_minmax) - (SELECT fire_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFn",
(SELECT "Firet" FROM mh.mh_thresholds) AS "WFt", -- Wildfire Intensity Threshold


d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.fire,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_wf_threat_to_buildings_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_wf_threat_to_buildings_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.5 Wildfire Threat
-- 4.5.2 Threat to Buildings
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.number) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "BldgNumT",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_ResLD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_RESMD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_ResHD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Commercial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Comm",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Industrial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Ind",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Civic' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Civic",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Agricultural' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Agr",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Wood' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Wood",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Concrete' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Concrete",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Precast' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_PreCast",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='RMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_RMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='URMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_URMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Steel' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Steel",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Manufactured' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Manufactured",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.fire,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_wf_threat_to_people_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_wf_threat_to_people_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.5 Wildfire Threat
-- 4.5.3 Threat to People
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN c.censuspop ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_Pop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.day) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_DayPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.night) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_NightPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.transit) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_TransitPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) / c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_SFHshlds",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN (SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) + SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END)) / 
c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_MFHshlds",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,c.censuspop,c.people_du,e.fire,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_wf_threat_to_assets_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_wf_threat_to_assets_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.5 Wildfire Threat
-- 4.5.4 Threat to Assets
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural + a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_AssetCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_BldgCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.structural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_StrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_NStrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.fire >= (SELECT "Firet" FROM mh.mh_thresholds) THEN SUM(a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "WFt_ContCost",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.fire,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_ls_threat_debris_flow_hazard_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_ls_threat_debris_flow_hazard_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.6 Landslide Threat
-- 4.6.1 Debris Flow Hazard
SELECT 
a.sauid AS "Sauid",

CAST(CAST(ROUND(CAST(e.lndsus AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "LSi",
COALESCE(CAST(CAST(ROUND(CAST((e.lndsus - (SELECT lndsus_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT lndsus_max FROM mh.mh_intensity_canada_minmax) - (SELECT lndsus_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSn",
(SELECT "LndSust" FROM mh.mh_thresholds) AS "LSt", -- Landslide Susceptibility Threshold

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.lndsus,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_ls_threat_to_buildings_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_ls_threat_to_buildings_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.6 Landslide Threat
-- 4.6.2 Threat to Buildings
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.number) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Bldgs",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_ResLD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_ResMD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_ResHD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Commercial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Comm",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Industrial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Ind",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Civic' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Civic",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Agricultural' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Agr",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Wood' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Wood",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Concrete' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Concrete",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Precast' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_PreCast",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='RMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_RMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='URMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_URMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Steel' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Steel",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Manufactured' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Manufactured",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.lndsus,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_ls_threat_to_people_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_ls_threat_to_people_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.6 Landslide Threat
-- 4.6.3 Threat to People
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN c.censuspop ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_Pop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.day) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_DayPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.night) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_NightPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.transit) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_TransitPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) / c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_SFHshlds",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN (SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) + SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END)) / 
c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_MFHshlds",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,c.censuspop,c.people_du,e.lndsus,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_ls_threat_to_assets_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_ls_threat_to_assets_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.6 Landslide Threat
-- 4.6.4 Threat to Assets
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural + a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_AssetCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_BldgCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.structural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_StrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_NStrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.lndsus >= (SELECT "LndSust" FROM mh.mh_thresholds) THEN SUM(a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "LSt_ContCost",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.lndsus,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_cy_threat_cy_wind_hazard_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_cy_threat_cy_wind_hazard_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.7 Cyclone Threat
-- 4.7.1 Cyclone Wind Hazard
SELECT 
a.sauid AS "Sauid",

CAST(CAST(ROUND(CAST(e.cy100 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "CYi_100",
COALESCE(CAST(CAST(ROUND(CAST((e.cy100 - (SELECT cy100_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT cy100_max FROM mh.mh_intensity_canada_minmax) - (SELECT cy100_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYn_100",
CAST(CAST(ROUND(CAST(e.cy250 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "CYi_250",
COALESCE(CAST(CAST(ROUND(CAST((e.cy250 - (SELECT cy250_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT cy250_max FROM mh.mh_intensity_canada_minmax) - (SELECT cy250_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Cyn_250",
CAST(CAST(ROUND(CAST(e.cy500 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "CYi_500",
COALESCE(CAST(CAST(ROUND(CAST((e.cy500 - (SELECT cy500_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT cy500_max FROM mh.mh_intensity_canada_minmax) - (SELECT cy500_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "Cyn_500",
(SELECT "Cy500t" FROM mh.mh_thresholds) AS "CYt_500", -- 500yr Cyclone Hazard Threat
CAST(CAST(ROUND(CAST(e.cy1000 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "CYi_1000",
COALESCE(CAST(CAST(ROUND(CAST((e.cy1000 - (SELECT cy1000_min FROM mh.mh_intensity_canada_minmax))/NULLIF((SELECT cy1000_max FROM mh.mh_intensity_canada_minmax) - (SELECT cy1000_min FROM mh.mh_intensity_canada_minmax),0) AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYn_1000",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.cy100,e.cy250,e.cy500,e.cy1000,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_cy_threat_to_buildings_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_cy_threat_to_buildings_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.7 Cyclone Threat
-- 4.7.2 Threat to Buildings
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.number) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Bldgs",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_ResLD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_ResMD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_ResHD",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Commercial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Comm",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Industrial' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Ind",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Civic' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Civic",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Agricultural' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Agr",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Wood' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Wood",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Concrete' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Concrete",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Precast' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_PreCast",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='RMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_RMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='URMasonry' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_URMasonry",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Steel' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Steel",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.bldggen ='Manufactured' THEN a.number ELSE 0 END) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_Manufactured",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.cy500,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_cy_threat_to_people_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_cy_threat_to_people_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.7 Cyclone Threat
-- 4.7.3 Threat to People
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN c.censuspop ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYtPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.day) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_DayPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.night) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_NightPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.transit) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_TransitPop",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) / c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_SFHshlds",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN (SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) + SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END)) / 
c.people_du ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_MFHshlds",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,c.censuspop,c.people_du,e.cy500,d.geom,d.geompoint;



-- create multi hazard indicators
DROP VIEW IF EXISTS results_nhsl_hazard_threat.nhsl_hazard_threat_cy_threat_to_assets_s CASCADE;
CREATE VIEW results_nhsl_hazard_threat.nhsl_hazard_threat_cy_threat_to_assets_s AS 

-- 4.0 Multi-Hazard Risk
-- 4.7 Cyclone Threat
-- 4.7.4 Threat to Assets
SELECT 
a.sauid AS "Sauid",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural + a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_AssetCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.structural + a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_BldgCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.structural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_StrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.nonstructural) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_NStrCost",

COALESCE(CAST(CAST(ROUND(CAST(CASE WHEN e.cy500 >= (SELECT "Cy500t" FROM mh.mh_thresholds) THEN SUM(a.contents) ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC),0) AS "CYt_ContCost",

d.geom AS "geom_poly",
d.geompoint AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d ON a.sauid = d."SAUIDt"
LEFT JOIN mh.mh_intensity_canada e ON a.sauid = e.sauidt
GROUP BY a.sauid,e.cy500,d.geom,d.geompoint;