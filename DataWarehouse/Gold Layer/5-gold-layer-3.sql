
IF OBJECT_ID('gold.FactRecruitment','U')            IS NOT NULL DROP TABLE gold.FactRecruitment;
IF OBJECT_ID('gold.FactLifecycleRetention','U')     IS NOT NULL DROP TABLE gold.FactLifecycleRetention;
IF OBJECT_ID('gold.FactMonthlyPulseTimeseries','U') IS NOT NULL DROP TABLE gold.FactMonthlyPulseTimeseries;
IF OBJECT_ID('gold.FactPerformanceTimeseries','U')  IS NOT NULL DROP TABLE gold.FactPerformanceTimeseries;
GO
IF OBJECT_ID('gold.DimEmployee','U')       IS NOT NULL DROP TABLE gold.DimEmployee;
IF OBJECT_ID('gold.DimManager','U')        IS NOT NULL DROP TABLE gold.DimManager;
IF OBJECT_ID('gold.DimSource','U')         IS NOT NULL DROP TABLE gold.DimSource;
IF OBJECT_ID('gold.DimExitReason','U')     IS NOT NULL DROP TABLE gold.DimExitReason;
IF OBJECT_ID('gold.DimPipelineStatus','U') IS NOT NULL DROP TABLE gold.DimPipelineStatus;
IF OBJECT_ID('gold.DimDate','U')           IS NOT NULL DROP TABLE gold.DimDate;
GO


CREATE TABLE gold.DimDate
(
    Date_Key       INT PRIMARY KEY,
    Full_Date      DATE,
    Day_Number     INT,
    Month_Number   INT,
    Month_Name     NVARCHAR(20),
    Quarter_Number INT,
    Year_Number    INT
);
GO


CREATE TABLE gold.DimEmployee
(
    Employee_Key    INT IDENTITY(1,1) PRIMARY KEY,
    Employee_ID     NVARCHAR(50),
    Candidate_ID    NVARCHAR(50),
    Department      NVARCHAR(100),
    Role            NVARCHAR(100),
    Gender          NVARCHAR(20),
    Ethnicity       NVARCHAR(50),
    Age_Band        NVARCHAR(50),
    Education_Level NVARCHAR(100),
);
GO


CREATE TABLE gold.DimSource
(
    Source_Key       INT IDENTITY(1,1) PRIMARY KEY,
    Sourcing_Channel NVARCHAR(100)
);
GO

CREATE TABLE gold.DimExitReason
(
    Exit_Reason_Key INT IDENTITY(1,1) PRIMARY KEY,
    Exit_Reason     NVARCHAR(255)
);
GO

CREATE TABLE gold.DimPipelineStatus
(
    Status_Key  INT IDENTITY(1,1) PRIMARY KEY,
    Status_Name NVARCHAR(100),
    Status_Type NVARCHAR(50)
);
GO


CREATE TABLE gold.FactRecruitment
(
    Recruitment_Key        INT IDENTITY(1,1) PRIMARY KEY,
    Req_ID                 NVARCHAR(50),
    Employee_Key           INT,
    Source_Key             INT,
    Date_Key               INT,
    Status_Key             INT,
    Days_to_Fill           INT,
    Sourcing_Cost          DECIMAL(18,2),
    Cost_of_Vacancy        DECIMAL(18,2),
    Total_Acquisition_Cost DECIMAL(18,2),
    Skill_Score            DECIMAL(5,2),
    Culture_Score          DECIMAL(5,2),
    Potential_Score        DECIMAL(5,2),
    LQI                    DECIMAL(5,2),
    True_LQI               DECIMAL(5,2),
    FOREIGN KEY (Employee_Key) REFERENCES gold.DimEmployee(Employee_Key),
    FOREIGN KEY (Source_Key)   REFERENCES gold.DimSource(Source_Key),
    FOREIGN KEY (Date_Key)     REFERENCES gold.DimDate(Date_Key),
    FOREIGN KEY (Status_Key)   REFERENCES gold.DimPipelineStatus(Status_Key)
);
GO

CREATE TABLE gold.FactLifecycleRetention
(
    Lifecycle_Key           INT IDENTITY(1,1) PRIMARY KEY,
    Employee_Key            INT,
    Hire_Date_Key           INT,
    Termination_Date_Key    INT,
    Last_Promotion_Date_Key INT,
    Status_Key              INT,
    Exit_Reason_Key         INT,
    Total_Tenure_Months     INT,
    Comp_vs_Market          DECIMAL(5,2),
    Final_Salary            DECIMAL(18,2),
    Avg_KPI_Career          DECIMAL(5,2),
    Promotion_Count         INT,
    Attrition_Risk_Score    DECIMAL(5,2),
    FOREIGN KEY (Employee_Key)            REFERENCES gold.DimEmployee(Employee_Key),
    FOREIGN KEY (Hire_Date_Key)           REFERENCES gold.DimDate(Date_Key),
    FOREIGN KEY (Termination_Date_Key)    REFERENCES gold.DimDate(Date_Key),
    FOREIGN KEY (Last_Promotion_Date_Key) REFERENCES gold.DimDate(Date_Key),
    FOREIGN KEY (Status_Key)              REFERENCES gold.DimPipelineStatus(Status_Key),
    FOREIGN KEY (Exit_Reason_Key)         REFERENCES gold.DimExitReason(Exit_Reason_Key)
);
GO

CREATE TABLE gold.FactMonthlyPulseTimeseries
(
    Pulse_Key           INT IDENTITY(1,1) PRIMARY KEY,
    Employee_Key        INT,
    Pulse_Date_Key      INT,
    Year_Month          NVARCHAR(10),
    Month_Number        INT,
    Monthly_Pulse_Score DECIMAL(5,2),
    Culture_Band        NVARCHAR(50),
    FOREIGN KEY (Employee_Key)   REFERENCES gold.DimEmployee(Employee_Key),
    FOREIGN KEY (Pulse_Date_Key) REFERENCES gold.DimDate(Date_Key)
);
GO

CREATE TABLE gold.FactPerformanceTimeseries
(
    Performance_Key         INT IDENTITY(1,1) PRIMARY KEY,
    Employee_Key            INT,
    Quarter_Date_Key        INT,
    Quarter_Label           NVARCHAR(20),
    Quarter_Number          INT,
    Tenure_Quarters         INT,
    KPI_Achievement         DECIMAL(5,2),
    Quality_of_Work         DECIMAL(5,2),
    Skill_Acquisition_Score DECIMAL(5,2),
    FOREIGN KEY (Employee_Key)     REFERENCES gold.DimEmployee(Employee_Key),
    FOREIGN KEY (Quarter_Date_Key) REFERENCES gold.DimDate(Date_Key)
);
GO


INSERT INTO gold.DimDate
SELECT DISTINCT
    YEAR(AllDates.Dt)*10000 + MONTH(AllDates.Dt)*100 + DAY(AllDates.Dt),
    AllDates.Dt,
    DAY(AllDates.Dt),
    MONTH(AllDates.Dt),
    DATENAME(MONTH, AllDates.Dt),
    DATEPART(QUARTER, AllDates.Dt),
    YEAR(AllDates.Dt)
FROM (
    SELECT Hire_Date           AS Dt FROM silver.Recruitment            WHERE Hire_Date            IS NOT NULL UNION
    SELECT Vacancy_Start_Date         FROM silver.Recruitment            WHERE Vacancy_Start_Date   IS NOT NULL UNION
    SELECT Termination_Date           FROM silver.LifecycleRetention     WHERE Termination_Date     IS NOT NULL UNION
    SELECT Last_Promotion_Date        FROM silver.LifecycleRetention     WHERE Last_Promotion_Date  IS NOT NULL UNION
    SELECT Pulse_Date                 FROM silver.MonthlyPulseTimeseries WHERE Pulse_Date           IS NOT NULL UNION
    SELECT Quarter_Date               FROM silver.PerformanceTimeseries  WHERE Quarter_Date         IS NOT NULL
) AS AllDates;


INSERT INTO gold.DimEmployee
(
    Employee_ID, Candidate_ID,
    Department, Role,
    Gender, Ethnicity, Age_Band, Education_Level
)
SELECT DISTINCT
    E.Employee_ID,
    E.Candidate_ID,
    E.Department,
    E.Role,
    E.Gender,
    E.Ethnicity,
    E.Age_Band,
    E.Education_Level
FROM silver.EmployeeMaster E
LEFT JOIN gold.DimDate D ON E.Hire_Date = D.Full_Date;


INSERT INTO gold.DimExitReason (Exit_Reason)
SELECT DISTINCT Exit_Reason
FROM silver.LifecycleRetention
WHERE Exit_Reason IS NOT NULL;


INSERT INTO gold.DimPipelineStatus (Status_Name, Status_Type)
SELECT DISTINCT Pipeline_Status,   'Pipeline'
FROM silver.Recruitment WHERE Pipeline_Status IS NOT NULL
UNION
SELECT DISTINCT Employment_Status, 'Employment'
FROM silver.LifecycleRetention WHERE Employment_Status IS NOT NULL;


INSERT INTO gold.DimSource (Sourcing_Channel)
SELECT DISTINCT Sourcing_Channel
FROM silver.Recruitment;


INSERT INTO gold.FactRecruitment
(
    Req_ID, Employee_Key, Source_Key, Date_Key, Status_Key,
    Days_to_Fill, Sourcing_Cost, Cost_of_Vacancy, Total_Acquisition_Cost,
    Skill_Score, Culture_Score, Potential_Score, LQI, True_LQI
)
SELECT
    R.Req_ID,
    E.Employee_Key,
    S.Source_Key,
    D.Date_Key,
    ST.Status_Key,
    R.Days_to_Fill,
    R.Sourcing_Cost,
    R.Cost_of_Vacancy,
    R.Total_Acquisition_Cost,
    R.Skill_Score,
    R.Culture_Score,
    R.Potential_Score,
    R.LQI,
    R.True_LQI
FROM silver.Recruitment R
LEFT JOIN gold.DimEmployee       E  ON R.Employee_ID      = E.Employee_ID
LEFT JOIN gold.DimSource         S  ON R.Sourcing_Channel = S.Sourcing_Channel
LEFT JOIN gold.DimDate           D  ON R.Hire_Date        = D.Full_Date
LEFT JOIN gold.DimPipelineStatus ST ON R.Pipeline_Status  = ST.Status_Name AND ST.Status_Type = 'Pipeline';


INSERT INTO gold.FactLifecycleRetention
(
    Employee_Key, Hire_Date_Key, Termination_Date_Key, Last_Promotion_Date_Key,
    Status_Key, Exit_Reason_Key,
    Total_Tenure_Months, Comp_vs_Market, Final_Salary,
    Avg_KPI_Career, Promotion_Count, Attrition_Risk_Score
)
SELECT
    E.Employee_Key,
    D1.Date_Key,
    D2.Date_Key,
    D3.Date_Key,
    ST.Status_Key,
    EX.Exit_Reason_Key,
    L.Total_Tenure_Months,
    L.Comp_vs_Market,
    L.Final_Salary,
    L.Avg_KPI_Career,
    L.Promotion_Count,
    L.Attrition_Risk_Score
FROM silver.LifecycleRetention L
LEFT JOIN gold.DimEmployee       E  ON L.Employee_ID         = E.Employee_ID
LEFT JOIN gold.DimDate           D1 ON L.Hire_Date           = D1.Full_Date
LEFT JOIN gold.DimDate           D2 ON L.Termination_Date    = D2.Full_Date
LEFT JOIN gold.DimDate           D3 ON L.Last_Promotion_Date = D3.Full_Date
LEFT JOIN gold.DimPipelineStatus ST ON L.Employment_Status   = ST.Status_Name AND ST.Status_Type = 'Employment'
LEFT JOIN gold.DimExitReason     EX ON L.Exit_Reason         = EX.Exit_Reason;


INSERT INTO gold.FactMonthlyPulseTimeseries
(
    Employee_Key, Pulse_Date_Key, Year_Month, Month_Number,
    Monthly_Pulse_Score, Culture_Band
)
SELECT
    E.Employee_Key,
    D.Date_Key,
    M.Year_Month,
    M.Month_Number,
    M.Monthly_Pulse_Score,
    M.Culture_Band
FROM silver.MonthlyPulseTimeseries M
LEFT JOIN gold.DimEmployee E ON M.Employee_ID = E.Employee_ID
LEFT JOIN gold.DimDate     D ON M.Pulse_Date  = D.Full_Date;


INSERT INTO gold.FactPerformanceTimeseries
(
    Employee_Key, Quarter_Date_Key, Quarter_Label, Quarter_Number,
    Tenure_Quarters, KPI_Achievement, Quality_of_Work, Skill_Acquisition_Score
)
SELECT
    E.Employee_Key,
    D.Date_Key,
    P.Quarter_Label,
    P.Quarter_Number,
    P.Tenure_Quarters,
    P.KPI_Achievement,
    P.Quality_of_Work,
    P.Skill_Acquisition_Score
FROM silver.PerformanceTimeseries P
LEFT JOIN gold.DimEmployee E ON P.Employee_ID  = E.Employee_ID
LEFT JOIN gold.DimDate     D ON P.Quarter_Date = D.Full_Date;
GO


SELECT * FROM gold.DimDate;
SELECT * FROM gold.DimEmployee;
SELECT * FROM gold.DimSource;
SELECT * FROM gold.DimExitReason;
SELECT * FROM gold.DimPipelineStatus;
SELECT * FROM gold.FactRecruitment;
SELECT * FROM gold.FactLifecycleRetention;
SELECT * FROM gold.FactMonthlyPulseTimeseries;
SELECT * FROM gold.FactPerformanceTimeseries;
