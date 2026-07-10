
GO
SELECT *
INTO bronze.Recruitment
FROM stg.Recruitment;

SELECT *
INTO bronze.EmployeeMaster
FROM stg.EmployeeMaster;

SELECT *
INTO bronze.LifecycleRetention
FROM stg.LifecycleRetention;

SELECT *
INTO bronze.MonthlyPulseTimeseries
FROM stg.MonthlyPulseTimeseries;

SELECT *
INTO bronze.PerformanceTimeseries
FROM stg.PerformanceTimeseries;

--new column added "the date when the bronze layer get the data"

ALTER TABLE bronze.Recruitment
ADD bronze_loaded_at DATETIME DEFAULT GETDATE();

ALTER TABLE bronze.EmployeeMaster
ADD bronze_loaded_at DATETIME DEFAULT GETDATE();

ALTER TABLE bronze.LifecycleRetention
ADD bronze_loaded_at DATETIME DEFAULT GETDATE();

ALTER TABLE bronze.MonthlyPulseTimeseries
ADD bronze_loaded_at DATETIME DEFAULT GETDATE();

ALTER TABLE bronze.PerformanceTimeseries
ADD bronze_loaded_at DATETIME DEFAULT GETDATE();

UPDATE bronze.Recruitment
SET bronze_loaded_at = GETDATE() 
WHERE bronze_loaded_at IS NULL;

UPDATE bronze.EmployeeMaster
SET bronze_loaded_at = GETDATE() 
WHERE bronze_loaded_at IS NULL;

UPDATE bronze.LifecycleRetention 
SET bronze_loaded_at = GETDATE() 
WHERE bronze_loaded_at IS NULL;

UPDATE bronze.MonthlyPulseTimeseries 
SET bronze_loaded_at = GETDATE() 
WHERE bronze_loaded_at IS NULL;

UPDATE bronze.PerformanceTimeseries 
SET bronze_loaded_at = GETDATE() 
WHERE bronze_loaded_at IS NULL;


SELECT 'Recruitment'        , COUNT(*) FROM bronze.Recruitment
UNION ALL
SELECT 'EmployeeMaster'     , COUNT(*) FROM bronze.EmployeeMaster
UNION ALL
SELECT 'LifecycleRetention' , COUNT(*) FROM bronze.LifecycleRetention
UNION ALL
SELECT 'MonthlyPulse'       , COUNT(*) FROM bronze.MonthlyPulseTimeseries
UNION ALL
SELECT 'Performance'        , COUNT(*) FROM bronze.PerformanceTimeseries;