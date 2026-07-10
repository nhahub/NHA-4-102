IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Recruitment' AND schema_id = SCHEMA_ID('stg'))
BEGIN
    CREATE TABLE stg.Recruitment (
        Req_ID NVARCHAR(255),
        Candidate_ID NVARCHAR(255),
        Employee_ID NVARCHAR(255),
        Pipeline_Status NVARCHAR(255),
        Vacancy_Start_Date NVARCHAR(255),
        Hire_Date NVARCHAR(255),
        Days_to_Fill NVARCHAR(255),
        Sourcing_Channel NVARCHAR(255),
        Sourcing_Cost NVARCHAR(255),
        Cost_of_Vacancy NVARCHAR(255),
        Total_Acquisition_Cost NVARCHAR(255),
        Skill_Score NVARCHAR(255),
        Culture_Score NVARCHAR(255),
        Potential_Score NVARCHAR(255),
        LQI NVARCHAR(255),
        True_LQI NVARCHAR(255),
        Bias_Flag NVARCHAR(255),
        Gender NVARCHAR(255),
        Ethnicity NVARCHAR(255),
        Age_Band NVARCHAR(255),
        Education_Level NVARCHAR(255)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeeMaster' AND schema_id = SCHEMA_ID('stg'))
BEGIN
    CREATE TABLE stg.EmployeeMaster (
        Employee_ID NVARCHAR(255),
        Candidate_ID NVARCHAR(255),
        Hire_Date NVARCHAR(255),
        Department NVARCHAR(255),
        Role NVARCHAR(255),
        Base_Salary NVARCHAR(255),
        Manager_ID NVARCHAR(255),
        Manager_Effect NVARCHAR(255),
        Is_Bad_Manager NVARCHAR(255),
        Is_Biased_Manager NVARCHAR(255),
        Gender NVARCHAR(255),
        Ethnicity NVARCHAR(255),
        Age_Band NVARCHAR(255),
        Education_Level NVARCHAR(255),
        Skill_Score NVARCHAR(255),
        Culture_Score NVARCHAR(255),
        Potential_Score NVARCHAR(255),
        LQI NVARCHAR(255)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LifecycleRetention' AND schema_id = SCHEMA_ID('stg'))
BEGIN
    CREATE TABLE stg.LifecycleRetention (
        Employee_ID NVARCHAR(255),
        Employment_Status NVARCHAR(255),
        Hire_Date NVARCHAR(255),
        Termination_Date NVARCHAR(255),
        Total_Tenure_Months NVARCHAR(255),
        Comp_vs_Market NVARCHAR(255),
        Final_Salary NVARCHAR(255),
        Avg_KPI_Career NVARCHAR(255),
        Promotion_Count NVARCHAR(255),
        Last_Promotion_Date NVARCHAR(255),
        Exit_Reason NVARCHAR(255),
        Attrition_Risk_Score NVARCHAR(255)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'MonthlyPulseTimeseries' AND schema_id = SCHEMA_ID('stg'))
BEGIN
    CREATE TABLE stg.MonthlyPulseTimeseries (
        Employee_ID NVARCHAR(255),
        Year_Month NVARCHAR(255),
        Pulse_Date NVARCHAR(255),
        Month_Number NVARCHAR(255),
        Monthly_Pulse_Score NVARCHAR(255),
        Culture_Band NVARCHAR(255)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PerformanceTimeseries' AND schema_id = SCHEMA_ID('stg'))
BEGIN
    CREATE TABLE stg.PerformanceTimeseries (
        Employee_ID NVARCHAR(255),
        Quarter_Label NVARCHAR(255),
        Quarter_Number NVARCHAR(255),
        Quarter_Date NVARCHAR(255),
        Tenure_Quarters NVARCHAR(255),
        KPI_Achievement NVARCHAR(255),
        Quality_of_Work NVARCHAR(255),
        Skill_Acquisition_Score NVARCHAR(255)
    );
END

