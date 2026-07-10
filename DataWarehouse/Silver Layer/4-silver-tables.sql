
GO
IF OBJECT_ID ('silver.Recruitment', 'U') IS NOT NULL 
    DROP TABLE silver.Recruitment;
GO

CREATE TABLE silver.Recruitment (
    Req_ID NVARCHAR(50),
    Candidate_ID NVARCHAR(50),
    Employee_ID NVARCHAR(50),
    Pipeline_Status NVARCHAR(100),
    Vacancy_Start_Date DATE,                     
    Hire_Date DATE,                             
    Days_to_Fill INT,                           
    Sourcing_Channel NVARCHAR(100),
    Sourcing_Cost DECIMAL(18, 2),                
    Cost_of_Vacancy DECIMAL(18, 2),              
    Total_Acquisition_Cost DECIMAL(18, 2),       
    Skill_Score DECIMAL(5, 2),                   
    Culture_Score DECIMAL(5, 2),                 
    Potential_Score DECIMAL(5, 2),               
    LQI DECIMAL(5, 2),                           
    True_LQI DECIMAL(5, 2),                      
    Bias_Flag INT,                               
    Gender NVARCHAR(20),
    Ethnicity NVARCHAR(50),
    Age_Band NVARCHAR(50),
    Education_Level NVARCHAR(100),
    silver_loaded_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Recruitment PRIMARY KEY (Req_ID) 
);
GO

IF OBJECT_ID ('silver.EmployeeMaster', 'U') IS NOT NULL 
    DROP TABLE silver.EmployeeMaster;
GO

CREATE TABLE silver.EmployeeMaster (
    Employee_ID NVARCHAR(50),
    Candidate_ID NVARCHAR(50),
    Hire_Date DATE,                             
    Department NVARCHAR(100),
    Role NVARCHAR(100),
    Base_Salary DECIMAL(18, 2),                 
    Manager_ID NVARCHAR(50),
    Manager_Effect DECIMAL(5, 2),                
    Is_Bad_Manager INT,                         
    Is_Biased_Manager INT,                       
    Gender NVARCHAR(20),
    Ethnicity NVARCHAR(50),
    Age_Band NVARCHAR(50),
    Education_Level NVARCHAR(100),
    Skill_Score DECIMAL(5, 2),                   
    Culture_Score DECIMAL(5, 2),                 
    Potential_Score DECIMAL(5, 2),               
    LQI DECIMAL(5, 2),                           
    silver_loaded_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_EmployeeMaster PRIMARY KEY (Employee_ID) 
);
GO

IF OBJECT_ID ('silver.LifecycleRetention', 'U') IS NOT NULL 
    DROP TABLE silver.LifecycleRetention;
GO

CREATE TABLE silver.LifecycleRetention (
    Employee_ID NVARCHAR(50),
    Employment_Status NVARCHAR(50),
    Hire_Date DATE,                               
    Termination_Date DATE,                        
    Total_Tenure_Months INT,                      
    Comp_vs_Market DECIMAL(5, 2),              
    Final_Salary DECIMAL(18, 2),               
    Avg_KPI_Career DECIMAL(5, 2),                
    Promotion_Count INT,                          
    Last_Promotion_Date DATE,                    
    Exit_Reason NVARCHAR(255),
    Attrition_Risk_Score DECIMAL(5, 2),          
    silver_loaded_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_LifecycleRetention PRIMARY KEY (Employee_ID) 
);
GO

IF OBJECT_ID ('silver.MonthlyPulseTimeseries', 'U') IS NOT NULL 
    DROP TABLE silver.MonthlyPulseTimeseries;
GO

CREATE TABLE silver.MonthlyPulseTimeseries (
    Employee_ID NVARCHAR(50),
    Year_Month NVARCHAR(10),
    Pulse_Date DATE,                            
    Month_Number INT,                           
    Monthly_Pulse_Score DECIMAL(5, 2),          
    Culture_Band NVARCHAR(50),
    silver_loaded_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_MonthlyPulse PRIMARY KEY (Employee_ID, Pulse_Date) 
);
GO

IF OBJECT_ID ('silver.PerformanceTimeseries', 'U') IS NOT NULL 
    DROP TABLE silver.PerformanceTimeseries;
GO

CREATE TABLE silver.PerformanceTimeseries (
    Employee_ID NVARCHAR(50),
    Quarter_Label NVARCHAR(20),
    Quarter_Number INT,                          
    Quarter_Date DATE,                           
    Tenure_Quarters INT,                         
    KPI_Achievement DECIMAL(5, 2),               
    Quality_of_Work DECIMAL(5, 2),               
    Skill_Acquisition_Score DECIMAL(5, 2),       
    silver_loaded_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Performance PRIMARY KEY (Employee_ID, Quarter_Date) 
);
GO


INSERT INTO silver.Recruitment 
SELECT 
    Req_ID, Candidate_ID, Employee_ID, Pipeline_Status,
    TRY_CAST(Vacancy_Start_Date AS DATE),
    TRY_CAST(Hire_Date AS DATE),
    TRY_CAST(Days_to_Fill AS INT),
    Sourcing_Channel,
    TRY_CAST(Sourcing_Cost AS DECIMAL(18,2)),
    TRY_CAST(Cost_of_Vacancy AS DECIMAL(18,2)),
    TRY_CAST(Total_Acquisition_Cost AS DECIMAL(18,2)),
    TRY_CAST(Skill_Score AS DECIMAL(5,2)),
    TRY_CAST(Culture_Score AS DECIMAL(5,2)),
    TRY_CAST(Potential_Score AS DECIMAL(5,2)),
    TRY_CAST(LQI AS DECIMAL(5,2)),
    TRY_CAST(True_LQI AS DECIMAL(5,2)),
    TRY_CAST(Bias_Flag AS INT),
    Gender, Ethnicity, Age_Band, Education_Level,
    GETDATE()
FROM bronze.Recruitment;


INSERT INTO silver.EmployeeMaster
SELECT 
    Employee_ID, Candidate_ID, 
    TRY_CAST(Hire_Date AS DATE),
    Department, Role, 
    TRY_CAST(Base_Salary AS DECIMAL(18,2)),
    Manager_ID, 
    TRY_CAST(Manager_Effect AS DECIMAL(5,2)),
    TRY_CAST(Is_Bad_Manager AS INT),
    TRY_CAST(Is_Biased_Manager AS INT),
    Gender, Ethnicity, Age_Band, Education_Level,
    TRY_CAST(Skill_Score AS DECIMAL(5,2)),
    TRY_CAST(Culture_Score AS DECIMAL(5,2)),
    TRY_CAST(Potential_Score AS DECIMAL(5,2)),
    TRY_CAST(LQI AS DECIMAL(5,2)),
    GETDATE()
FROM bronze.EmployeeMaster;


INSERT INTO silver.LifecycleRetention
SELECT 
    Employee_ID, Employment_Status, 
    TRY_CAST(Hire_Date AS DATE),
    TRY_CAST(Termination_Date AS DATE),
    TRY_CAST(Total_Tenure_Months AS INT),
    TRY_CAST(Comp_vs_Market AS DECIMAL(5,2)),
    TRY_CAST(Final_Salary AS DECIMAL(18,2)),
    TRY_CAST(Avg_KPI_Career AS DECIMAL(5,2)),
    TRY_CAST(Promotion_Count AS INT),
    TRY_CAST(Last_Promotion_Date AS DATE),
    Exit_Reason, 
    TRY_CAST(Attrition_Risk_Score AS DECIMAL(5,2)),
    GETDATE()
FROM bronze.LifecycleRetention;


INSERT INTO silver.MonthlyPulseTimeseries
SELECT 
    Employee_ID, Year_Month, 
    TRY_CAST(Pulse_Date AS DATE),
    TRY_CAST(Month_Number AS INT),
    TRY_CAST(Monthly_Pulse_Score AS DECIMAL(5,2)),
    Culture_Band,
    GETDATE()
FROM bronze.MonthlyPulseTimeseries;


INSERT INTO silver.PerformanceTimeseries
SELECT 
    Employee_ID, Quarter_Label, 
    TRY_CAST(Quarter_Number AS INT),
    TRY_CAST(Quarter_Date AS DATE),
    TRY_CAST(Tenure_Quarters AS INT),
    TRY_CAST(KPI_Achievement AS DECIMAL(5,2)),
    TRY_CAST(Quality_of_Work AS DECIMAL(5,2)),
    TRY_CAST(Skill_Acquisition_Score AS DECIMAL(5,2)),
    GETDATE()
FROM bronze.PerformanceTimeseries;
GO

SELECT 'Recruitment' AS TableName, 
       (SELECT COUNT(*) FROM bronze.Recruitment) AS Bronze_Count, 
       (SELECT COUNT(*) FROM silver.Recruitment) AS Silver_Count
UNION ALL
SELECT 'EmployeeMaster', 
       (SELECT COUNT(*) FROM bronze.EmployeeMaster), 
       (SELECT COUNT(*) FROM silver.EmployeeMaster)
UNION ALL
SELECT 'LifecycleRetention', 
       (SELECT COUNT(*) FROM bronze.LifecycleRetention), 
       (SELECT COUNT(*) FROM silver.LifecycleRetention)
UNION ALL
SELECT 'MonthlyPulseTimeseries', 
       (SELECT COUNT(*) FROM bronze.MonthlyPulseTimeseries), 
       (SELECT COUNT(*) FROM silver.MonthlyPulseTimeseries)
UNION ALL
SELECT 'PerformanceTimeseries', 
       (SELECT COUNT(*) FROM bronze.PerformanceTimeseries), 
       (SELECT COUNT(*) FROM silver.PerformanceTimeseries);
GO