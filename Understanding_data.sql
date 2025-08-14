-- Kaggle → SQL (Understanding & cleaning) → Python (EDA + ML) → SHAP (Interpretation) → Tableau (Dashboard) → Resume

create database HR_ANALYTICS_PROJECT;
use HR_ANALYTICS_PROJECT;

CREATE TABLE hr_data (
    Age INT,
    Attrition VARCHAR(5),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 CHAR(1),
    OverTime VARCHAR(5),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

DESCRIBE hr_data;
SELECT COUNT(*) AS total_rows FROM hr_data;

SELECT DISTINCT Attrition FROM hr_data;

SELECT Attrition,Count(Attrition) AS total_attrition FROM hr_data group by Attrition;
SELECT 
  MIN(Age), MAX(Age), AVG(Age) AS AvgAge,
  MIN(MonthlyIncome), MAX(MonthlyIncome), AVG(MonthlyIncome) AS AvgIncome,
  MIN(YearsAtCompany), MAX(YearsAtCompany)
FROM hr_data;


-- Attrition by JobRole
SELECT JobRole, Attrition, COUNT(*) AS total
FROM hr_data
GROUP BY JobRole, Attrition
ORDER BY JobRole;

-- Overtime vs Attrition
SELECT OverTime, Attrition, COUNT(*) AS count
FROM hr_data
GROUP BY OverTime, Attrition;

SELECT ROUND(127 / 237.0 * 100, 2) AS percentage;  -- ≈ 53.59%
-- 53.59% of all employees who left the company were working overtime.

SELECT ROUND(127 / 416.0 * 100, 2) AS percentage;  -- ≈ 30.53%
-- 30.5% of all employees who did overtime eventually left.


-- checking for duplicates
SELECT EmployeeNumber, COUNT(*) AS count
FROM hr_data
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;
 
-- checking for missing vsalue
SELECT
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS missing_Age,
  SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS missing_Attrition,
  SUM(CASE WHEN BusinessTravel IS NULL THEN 1 ELSE 0 END) AS missing_BusinessTravel,
  SUM(CASE WHEN DailyRate IS NULL THEN 1 ELSE 0 END) AS missing_DailyRate,
  SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS missing_Department,
  SUM(CASE WHEN DistanceFromHome IS NULL THEN 1 ELSE 0 END) AS missing_DistanceFromHome,
  SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS missing_Education,
  SUM(CASE WHEN EducationField IS NULL THEN 1 ELSE 0 END) AS missing_EducationField,
  SUM(CASE WHEN EmployeeCount IS NULL THEN 1 ELSE 0 END) AS missing_EmployeeCount,
  SUM(CASE WHEN EnvironmentSatisfaction IS NULL THEN 1 ELSE 0 END) AS missing_EnvironmentSatisfaction,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS missing_Gender,
  SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS missing_JobRole,
  SUM(CASE WHEN MaritalStatus IS NULL THEN 1 ELSE 0 END) AS missing_MaritalStatus,
  SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS missing_MonthlyIncome,
  SUM(CASE WHEN OverTime IS NULL THEN 1 ELSE 0 END) AS missing_OverTime
FROM hr_data;

ALTER TABLE hr_data
ADD COLUMN AttritionFlag INT,
ADD COLUMN OverTimeFlag INT,
ADD COLUMN GenderFlag INT;

SET SQL_SAFE_UPDATES = 0;

-- Now run your updates
UPDATE hr_data
SET AttritionFlag = CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END;

UPDATE hr_data
SET OverTimeFlag = CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END;

UPDATE hr_data
SET GenderFlag = CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END;

-- Then turn safe mode back ON
SET SQL_SAFE_UPDATES = 1;

select * from hr_data;

ALTER TABLE hr_data
DROP COLUMN Attrition,
DROP COLUMN OverTime,
DROP COLUMN Gender;

SELECT AttritionFlag, OverTimeFlag, GenderFlag, COUNT(*) 
FROM hr_data
GROUP BY AttritionFlag, OverTimeFlag, GenderFlag;

SELECT Department,
       COUNT(*) AS TotalEmployees,
       SUM(AttritionFlag) AS EmployeesLeft,
       ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS AttritionRate
FROM hr_data
GROUP BY Department
ORDER BY AttritionRate DESC;

ALTER TABLE hr_data
DROP COLUMN EmployeeNumber,
DROP COLUMN Over18,
DROP COLUMN StandardHours,
DROP COLUMN EmployeeCount;

SELECT COUNT(*) AS ColumnCount
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'HR_ANALYTICS_PROJECT'
  AND TABLE_NAME = 'hr_data';

ALTER TABLE hr_data
ADD COLUMN SeniorityLevel VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE hr_data
SET SeniorityLevel = CASE
    WHEN JobLevel = 1 THEN 'Intern'
    WHEN JobLevel = 2 THEN 'Junior'
    WHEN JobLevel = 3 THEN 'Mid'
    WHEN JobLevel = 4 THEN 'Senior'
    WHEN JobLevel >= 5 THEN 'Executive'
    ELSE 'Unknown'
END;

SET SQL_SAFE_UPDATES = 1;

SELECT 
  SeniorityLevel,
  COUNT(*) AS EmployeesLeft
FROM 
  hr_data
WHERE 
  AttritionFlag = 1
GROUP BY 
  SeniorityLevel
ORDER BY 
  EmployeesLeft DESC;
  
ALTER TABLE hr_data
ADD COLUMN ExperienceBand VARCHAR(20);

UPDATE hr_data
SET ExperienceBand = CASE
    WHEN TotalWorkingYears <= 2 THEN 'Fresher'
    WHEN TotalWorkingYears <= 5 THEN 'Junior'
    WHEN TotalWorkingYears <= 10 THEN 'Mid'
    ELSE 'Senior'
END;

SELECT 
  ExperienceBand,
  COUNT(*) AS EmployeesLeft
FROM 
  hr_data
WHERE 
  AttritionFlag = 1
GROUP BY 
  ExperienceBand
ORDER BY 
  EmployeesLeft DESC;
  
SELECT 
  SUM(CASE WHEN AttritionFlag = 1 THEN 1 ELSE 0 END) AS TotalLeft,
  JobLevel,
  COUNT(*) AS TotalEmployees,
  MIN(TotalWorkingYears) AS MinExperience,
  ROUND(AVG(TotalWorkingYears), 2) AS AvgExperience,
  MAX(TotalWorkingYears) AS MaxExperience
FROM 
  hr_data
GROUP BY 
  JobLevel
ORDER BY 
  JobLevel;
  
SELECT 
  JobLevel,
  COUNT(*) AS TotalEmployees,
  SUM(CASE WHEN AttritionFlag = 1 THEN 1 ELSE 0 END) AS TotalLeft,
  ROUND(SUM(CASE WHEN AttritionFlag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate,
  MIN(TotalWorkingYears) AS MinExperience,
  ROUND(AVG(TotalWorkingYears), 2) AS AvgExperience,
  MAX(TotalWorkingYears) AS MaxExperience
FROM 
  hr_data
GROUP BY 
  JobLevel
ORDER BY 
  JobLevel;

alter table hr_data
drop column SeniorityLevel,
drop column ExperienceBand;

ALTER TABLE hr_data ADD COLUMN SeniorityBand VARCHAR(20);
ALTER TABLE hr_data ADD COLUMN ExperienceBand VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;
-- based on the totalworkingband
UPDATE hr_data
SET ExperienceBand = CASE 
    WHEN TotalWorkingYears BETWEEN 0 AND 2 THEN 'Entry Level'
    WHEN TotalWorkingYears BETWEEN 3 AND 7 THEN 'Junior'
    WHEN TotalWorkingYears BETWEEN 8 AND 15 THEN 'Mid'
    WHEN TotalWorkingYears BETWEEN 16 AND 25 THEN 'Senior'
    ELSE 'Executive'
END;

SET SQL_SAFE_UPDATES = 1;
-- based on the JobLevel

UPDATE hr_data
SET SeniorityBand = CASE 
    WHEN JobLevel = 1 THEN 'Entry Level'
    WHEN JobLevel = 2 THEN 'Junior'
    WHEN JobLevel = 3 THEN 'Mid'
    WHEN JobLevel = 4 THEN 'Senior'
    WHEN JobLevel = 5 THEN 'Executive'
END;
select * from hr_data;


