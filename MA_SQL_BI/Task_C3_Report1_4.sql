-- Task C.3 Reports 1-4
-- REPORT 1
SELECT BF.FACULTYID AS "FacultyID", 
    BF.BOOKINGMONTH AS "Month", 
    TO_CHAR(SUM(NO_OF_BOOKING_RECORDS), '9,999') AS "Total bookings",
    TO_CHAR(SUM(SUM(NO_OF_BOOKING_RECORDS)) OVER 
    (ORDER BY TO_DATE(BF.BOOKINGMONTH, 'Month')
    ROWS UNBOUNDED PRECEDING),
    '9,999') AS "Cumulative number of booking records"
FROM BOOKING_FACT_V1 BF
WHERE BF.FACULTYID='FIT'
GROUP BY BF.FACULTYID, BF.BOOKINGMONTH
ORDER BY TO_DATE(BF.BOOKINGMONTH, 'Month');

-- REPORT 2
SELECT
DECODE(GROUPING(MF.TEAMID), 1, 'All Teams', MF.TEAMID) AS "Team ID",
DECODE(GROUPING(MF.CARBODYTYPE), 1, 'All Car Body Types', MF.CARBODYTYPE) AS "Car body type",
SUM(NO_OF_MAINTENANCE_RECORDS) AS "Total number of maintenance",
TO_CHAR(SUM(TOTAL_MAINTENANCE_COST),'9,999,999') AS "Total maintenance cost"
FROM MAINTENANCE_FACT_V1 MF
WHERE TEAMID='T002' OR TEAMID='T003'
GROUP BY CUBE(MF.TEAMID, MF.CARBODYTYPE);

-- REPORT 3
SELECT * FROM (
SELECT A.ERRORCODE AS "Error Code", A.REGISTRATIONNO AS "Registration No.", A.CARBODYTYPE AS "Car Body Type", SUM(A.NO_OF_ACCIDENT_RECORDS) AS "Total number of accidents",
DENSE_RANK() OVER (PARTITION BY A.ERRORCODE ORDER BY SUM(A.NO_OF_ACCIDENT_RECORDS) DESC) AS "Rank"
FROM ACCIDENT_FACT_V1 A, CAR_DIM_V1 C 
WHERE A.REGISTRATIONNO = C.REGISTRATIONNO
AND A.CARBODYTYPE = C.CARBODYTYPE
GROUP BY A.ERRORCODE, A.REGISTRATIONNO, A.CARBODYTYPE)
WHERE "Rank" <= 3;

-- REPORT 4
SELECT B.CARBODYTYPE AS "Car body type",
DECODE (grouping (B.passengeragegroupid), 1, 'All Age Groups', B.passengeragegroupid) AS "Age group",
DECODE (grouping (B.facultyid), 1, 'All Faculties', b.facultyid) AS "Faculty ID",
TO_CHAR(SUM(B.NO_OF_BOOKING_RECORDS),'9,999') AS "Total number of bookings"
FROM BOOKING_FACT_V1 B
WHERE B.CARBODYTYPE = 'People Mover'
GROUP BY B.CARBODYTYPE, CUBE(B.PASSENGERAGEGROUPID, B.FACULTYID);