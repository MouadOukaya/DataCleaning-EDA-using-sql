-- create table similar to tech_layoffs to modify
create table tech_layoffs2 LIKE tech_layoffs ;
Insert  into tech_layoffs2 select * from tech_layoffs;
select * from tech_layoffs2;
-- rename # to ID  
alter table tech_layoffs2 change `#` `ID` int; 
-- remove duplicate rows 
    -- check if duplicate rows exist 

(SELECT * FROM (
        SELECT Company, ROW_NUMBER() OVER (
            PARTITION BY 
            Company, Location_HQ, Country, Continent, Date_layoffs, Percentage,Company_Size_before_Layoffs,Company_Size_after_layoffs,Industry,Stage, Money_Raised_in_$_mil,`Year`,lat,lng
            ORDER BY Company
        ) AS row_num
        FROM tech_layoffs2
    ) subquery
    WHERE row_num > 1)   ;
-- delete the duplicates now
delete  from tech_layoffs2 Where Company IN (
SELECT Company FROM (
        SELECT Company, ROW_NUMBER() OVER (
            PARTITION BY 
            Company, Location_HQ, Country, Continent, Date_layoffs, Percentage,Company_Size_before_Layoffs,Company_Size_after_layoffs,Industry,Stage, Money_Raised_in_$_mil,`Year`,lat,lng
            ORDER BY Company
        ) AS row_num
        FROM tech_layoffs2
    ) subquery
    WHERE row_num > 1
); 
-- convert Date_layoffs data type to DATE 
ALTER TABLE tech_layoffs2 
MODIFY COLUMN Date_layoffs DATE;
-- Convert Money_Raised_in_$_mil to Numeric Format
UPDATE tech_layoffs 
SET Money_Raised_in_$_mil = REPLACE(Money_Raised_in_$_mil, '$', '');

-- Ensure Company_Size_after_layoffs is Correct 
UPDATE tech_layoffs 
SET Company_Size_after_layoffs = Company_Size_before_Layoffs - Laid_Off
WHERE Company_Size_after_layoffs IS NULL;
-- handle missing values 
update tech_layoffs2 
set Money_Raised_in_$_mil = 'Unknown' 
where Money_Raised_in_$_mil=''; 
select Money_Raised_in_$_mil from tech_layoffs2  ;






