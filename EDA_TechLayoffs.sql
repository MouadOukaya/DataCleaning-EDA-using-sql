-- Retrieve all data from the 'tech_layoffs2' table
SELECT * FROM tech_layoffs2;

-- Show the structure of the 'tech_layoffs2' table (column names, data types, constraints)
DESCRIBE tech_layoffs2;

-- Count the total number of rows (records) in the dataset
SELECT COUNT(*) AS total_rows FROM tech_layoffs2;

-- Check for missing (NULL) values in key columns
SELECT 
    SUM(CASE WHEN Laid_Off IS NULL THEN 1 ELSE 0 END) AS Missing_Laid_Off,
    SUM(CASE WHEN Percentage IS NULL THEN 1 ELSE 0 END) AS Missing_Percentage,
    SUM(CASE WHEN Company_Size_before_Layoffs IS NULL THEN 1 ELSE 0 END) AS Missing_Company_Size_Before,
    SUM(CASE WHEN Company_Size_after_layoffs IS NULL THEN 1 ELSE 0 END) AS Missing_Company_Size_After,
    SUM(CASE WHEN Money_Raised_in_$_mil IS NULL THEN 1 ELSE 0 END) AS Missing_Money_Raised
FROM tech_layoffs2;

-- Get minimum, maximum, and average values for layoffs and percentage of layoffs
SELECT 
    MIN(Laid_Off) AS Min_Laid_Off,
    MAX(Laid_Off) AS Max_Laid_Off,
    ROUND(AVG(Laid_Off),1) AS Avg_Laid_Off,
    MIN(Percentage) AS Min_Percentage,
    MAX(Percentage) AS Max_Percentage,
    ROUND(AVG(Percentage),1) AS Avg_Percentage
FROM tech_layoffs2;

-- Identify the top 10 companies with the most layoffs
SELECT Company, SUM(Laid_Off) AS Total_Laid_Off
FROM tech_layoffs2
GROUP BY Company
ORDER BY Total_Laid_Off DESC
LIMIT 10;

-- Count layoffs per year and order them by number of layoffs
SELECT `Year`, COUNT(`Year`) AS Laid_off_Per_Year 
FROM tech_layoffs2 
GROUP BY `Year` 
ORDER BY Laid_off_Per_Year;

-- Sum up total layoffs per year and order them chronologically
SELECT `Year`, SUM(Laid_Off) AS Total_Laid_Off_By_Year
FROM tech_layoffs2
GROUP BY `Year`
ORDER BY `Year` ASC;

-- Identify total layoffs by industry and order them in descending order
SELECT Industry, SUM(Laid_Off) AS Total_Laid_Off_By_Industry
FROM tech_layoffs2
GROUP BY Industry
ORDER BY Total_Laid_Off_By_Industry DESC;

-- Identify total layoffs by country and order them in descending order
SELECT Country, SUM(Laid_Off) AS Total_Laid_Off_By_Country
FROM tech_layoffs2
GROUP BY Country
ORDER BY Total_Laid_Off_By_Country DESC;

-- Categorize layoffs based on company size before layoffs
SELECT 
    CASE 
        WHEN Company_Size_before_Layoffs < 100 THEN 'Small (<100)'
        WHEN Company_Size_before_Layoffs BETWEEN 100 AND 1000 THEN 'Medium (100-1000)'
        ELSE 'Large (>1000)'
    END AS Company_Size_Category,
    COUNT(*) AS Total_Companies,
    SUM(Laid_Off) AS Total_Laid_Off
FROM tech_layoffs2
GROUP BY Company_Size_Category;

-- Analyze layoffs over time by month
SELECT 
    DATE_FORMAT(Date_layoffs, '%Y-%m') AS Month, 
    SUM(Laid_Off) AS Total_Laid_Off
FROM tech_layoffs2
GROUP BY Month
ORDER BY Month ASC;

-- Calculate the average layoff percentage per company
SELECT 
    Company, 
    ROUND(AVG(Percentage), 2) AS Avg_Layoff_Percentage
FROM tech_layoffs2
GROUP BY Company
ORDER BY Avg_Layoff_Percentage DESC;

-- Identify layoffs by startup funding stage
SELECT Stage, SUM(Laid_Off) AS Total_Laid_Off
FROM tech_layoffs2
GROUP BY Stage
ORDER BY Total_Laid_Off DESC;

-- Identify countries with the highest average layoff percentage
SELECT Country, ROUND(AVG(Percentage), 2) AS Avg_Layoff_Percentage
FROM tech_layoffs2
GROUP BY Country
ORDER BY Avg_Layoff_Percentage DESC
LIMIT 10;

-- Identify companies with the largest workforce before layoffs
SELECT Company, Company_Size_before_Layoffs
FROM tech_layoffs2
ORDER BY Company_Size_before_Layoffs DESC
LIMIT 10;

-- Analyze layoffs based on funding levels
SELECT 
    CASE 
        WHEN Money_Raised_in_$_mil < 50 THEN 'Low Funding (<50M)'
        WHEN Money_Raised_in_$_mil BETWEEN 50 AND 500 THEN 'Mid Funding (50M-500M)'
        ELSE 'High Funding (>500M)'
    END AS Funding_Level,
    COUNT(*) AS Total_Companies,
    SUM(Laid_Off) AS Total_Laid_Off
FROM tech_layoffs2
GROUP BY Funding_Level;

-- Identify peak layoff months with the highest layoff counts
SELECT 
    MONTH(Date_layoffs) AS Month, 
    COUNT(*) AS Layoff_Events, 
    SUM(Laid_Off) AS Total_Laid_Off
FROM tech_layoffs2
GROUP BY Month
ORDER BY Total_Laid_Off DESC
LIMIT 5;
