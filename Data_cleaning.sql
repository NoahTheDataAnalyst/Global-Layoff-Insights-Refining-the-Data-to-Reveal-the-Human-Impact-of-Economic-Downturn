select * 
from layoffs_staging;

-- Create a staging table to hold the data
CREATE TABLE layoffs_staging 
like layoffs;

insert layoffs_staging
select *
from layoffs;



-- Remove duplicate rows (0 duplicates)
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2;

insert into layoffs_staging2
select *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) as row_num
 from layoffs_staging;
 
 Select *
 from layoffs_staging2
 where row_num > 1;
 
  delete
 from layoffs_staging2
 where row_num > 1;

-- Standardize the data
-- Remove leading and trailing spaces from all text columns
UPDATE layoffs_staging
SET company = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    stage = TRIM(stage),
    country = TRIM(country);
select * 
from layoffs_staging;

-- Handle null and blank values
-- Replace null and blank values in percentage_laid_off with 0
UPDATE layoffs_staging
SET percentage_laid_off = 0
WHERE percentage_laid_off IS NULL OR percentage_laid_off = '';

UPDATE layoffs_staging
SET total_laid_off = 0
WHERE total_laid_off IS NULL OR total_laid_off = '';

UPDATE layoffs_staging
SET funds_raised_millions = 0
WHERE funds_raised_millions IS NULL OR funds_raised_millions = '';


-- Create a final cleaned table
CREATE TABLE layoffs_cleaned AS
SELECT *
FROM layoffs_staging;
Select *
from layoffs_staging;

-- Drop the staging table
DROP TABLE layoffs_staging;
