-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_physical_exposure;



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_buildings_b CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_buildings_b AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Buildings
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
CAST(CAST(ROUND(CAST(a.lon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLon",
CAST(CAST(ROUND(CAST(a.lat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "BldgLat",
CAST(CAST(ROUND(CAST(a.number AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgNum",
CAST(CAST(ROUND(CAST(b."BldgArea_ft2" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "EBldgArea",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN b."BldgArea_ft2" * a.number ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaRes",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Commercial' THEN b."BldgArea_ft2" * a.number ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaComm",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Industrial' THEN b."BldgArea_ft2" * a.number ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaInd",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Civic' THEN b."BldgArea_ft2" * a.number ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaCivic",
CAST(CAST(ROUND(CAST(CASE WHEN a.genocc = 'Agricultural' THEN b."BldgArea_ft2" * a.number ELSE 0 END AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgAreaAgr",

a.landusetyp AS "E_LandUse",
a.genocc AS "E_BldgOccG",
a.eqocctype AS "E_BldgOccS",
a.bldggen AS "E_BldgTypeG",
a.eqbldgtype AS "E_BldgTypeS",
a.eqdeslev AS "E_BldgDesLev",

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN lut.retrofit_costs b ON a.eqbldgtype = b."Eq_BldgType";



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_people_b CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_people_b AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.2 People
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
CAST(CAST(ROUND(CAST(a.day AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopDay",
CAST(CAST(ROUND(CAST(a.night AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopNight",
CAST(CAST(ROUND(CAST(a.transit AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_PopTransit",

a.geom AS "geom_point"

FROM exposure.canada_exposure a;



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_physical_exposure.nhsl_physical_exposure_assets_b CASCADE;
CREATE VIEW results_nhsl_physical_exposure.nhsl_physical_exposure_assets_b  AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.2 Assets
SELECT 
a.id AS "BldgID",
a.sauid AS "Sauid",
CAST(CAST(ROUND(CAST(a.structural + a.nonstructural + a.contents AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_AssetValue",
CAST(CAST(ROUND(CAST(a.structural + a.nonstructural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_BldgValue",
CAST(CAST(ROUND(CAST(a.structural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_StrValue",
CAST(CAST(ROUND(CAST(a.nonstructural AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_NStrValue",
CAST(CAST(ROUND(CAST(a.contents AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_ContValue",
CAST(CAST(ROUND(CAST(b."CAD_RetrofitCost_Bldg" AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_RetrofitCost",

a.geom AS "geom_point"

FROM exposure.canada_exposure a
LEFT JOIN lut.retrofit_costs b ON a.eqbldgtype = b."Eq_BldgType";