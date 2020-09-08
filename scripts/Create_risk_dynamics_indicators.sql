-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_risk_dynamics;



-- create risk dynamic indicators
DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_population_growth_s CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_population_growth_s AS 

-- 1.2 Risk Dynamics
-- 1.2.1 Population Growth
SELECT
ghslid AS "ghslID",
lon AS "ghs_lon",
lat AS "ghs_lat",
ghsl_km2,
ghsl_ha,
pop_2015 AS "ghs_Pop2015",
pop_2000 AS "ghs_Pop2000",
pop_1990 AS "ghs_Pop1990",
pop_1975 AS "ghs_Pop1975",
geom AS "geom_point"

FROM ghsl.ghsl_mh_intensity_ghsl;



-- create risk dynamic indicators
DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_land_use_change_s CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_land_use_change_s AS 

-- 1.2 Risk Dynamics
-- 1.2.2 Land Use Change
SELECT
ghslid AS "ghslID",
SMOD_2015,
SMOD_2000,
SMOD_1990,
SMOD_1975,
geom AS "geom_point"

FROM ghsl.ghsl_mh_intensity_ghsl;



-- create risk dynamic indicators
DROP VIEW IF EXISTS results_nhsl_risk_dynamics.nhsl_risk_dynamics_hazard_susceptibility_s CASCADE;
CREATE VIEW results_nhsl_risk_dynamics.nhsl_risk_dynamics_hazard_susceptibility_s AS 

-- 1.2 Risk Dynamics
-- 1.2.2 Land Use Change
-- 1.2.3 Hazard Susceptibility

SELECT
ghslid AS "ghslID",
pgv AS "ghs_PGV",
pga AS "ghs_PGA",
mmi7 AS "ghs_MMI7",
tsunami AS "ghs_Tsunami",
fld500 AS "ghs_Fld500",
wildfire AS "ghs_Wildfire",
lndsus AS "ghs_LndSus",
cy500 AS "ghs_Cy500",
csduid AS "CSDUID",
csdname AS "CSDNAME",
csdtype AS "CSDTYPE",
pruid AS "PRUID",
prname AS "PRNAME",
cduid AS "CDUID",
cdname AS "CDNAME",
cdtype AS "CDTYPE",
ccsuid AS "CCSUID",
ccsname AS "CCSNAME",
eruid AS "ERUID",
ername AS "ERNAME",
saccode AS "SACCODE",
sactype AS "SACTYPE",
geom AS "geom_point"

FROM ghsl.ghsl_mh_intensity_ghsl;