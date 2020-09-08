-- create lookup table for multi hazard thresholds value to be used
DROP TABLE IF EXISTS mh.mh_thresholds;

SELECT
0.028 AS "MHInt_t",
0.115 AS "PGAt",
0.05 AS "MMI7t",
20 AS "Tsun_t",
90 AS "Fl500t",
3.1 AS "LndSust",
2000 AS "Firet",
177 AS "Cy500t"

INTO mh.mh_thresholds;