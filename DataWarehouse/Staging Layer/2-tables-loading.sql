BULK INSERT stg.Recruitment
FROM 'C:\Users\Lenovo\Desktop\Project\CleanedCSVs\df_Recruitment_new.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

TRUNCATE TABLE stg.EmployeeMaster;

BULK INSERT stg.EmployeeMaster
FROM 'C:\Users\Lenovo\Desktop\Project\CleanedCSVs\Employee_Master_new.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

TRUNCATE TABLE stg.LifecycleRetention;

BULK INSERT stg.LifecycleRetention
FROM 'C:\Users\Lenovo\Desktop\Project\CleanedCSVs\Lifecycle_Retention_new.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


TRUNCATE TABLE stg.MonthlyPulseTimeseries;

BULK INSERT stg.MonthlyPulseTimeseries
FROM 'C:\Users\Lenovo\Desktop\Project\CleanedCSVs\Monthly_Pulse_Timeseries_new.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

TRUNCATE TABLE stg.PerformanceTimeseries;

BULK INSERT stg.PerformanceTimeseries
FROM 'C:\Users\Lenovo\Desktop\Project\CleanedCSVs\Performance_Timeseries_new.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

--View top 5 rows to make sure that tables loaded successfully
SELECT TOP 5 * FROM stg.Recruitment;
SELECT TOP 5 * FROM stg.EmployeeMaster;
SELECT TOP 5 * FROM stg.LifecycleRetention;
SELECT TOP 5 * FROM stg.MonthlyPulseTimeseries;
SELECT TOP 5 * FROM stg.PerformanceTimeseries;