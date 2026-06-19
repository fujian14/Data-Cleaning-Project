-- EDA (exploration data analyst project)

SELECT *
FROM layoffs_staging2;
-- explore the data and decide to work on total laid off colom and percetage laid off colom 
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off >= 12000;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC ;

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

-- checking the date range 
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- what industry is laid off the most 
SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 desc; 

-- or wich country efected the most 
SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; 

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 

-- substring 
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC ;

-- rolling total , cte on substring 
WITH rolling_total AS ( SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_laidoff
						FROM layoffs_staging2
						WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
						GROUP BY `MONTH`
						ORDER BY 1 ASC )
SELECT `MONTH`, total_laidoff,
SUM(total_laidoff) OVER(ORDER BY `MONTH` ) AS rollig_total
FROM rolling_total ; 



SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC  ;

-- RANK 
WITH company_total_laidoff AS ( SELECT company, YEAR(`date`) AS `year`, SUM(total_laid_off) AS total_laidoff
								FROM layoffs_staging2
								GROUP BY company, YEAR(`date`) ), 
		company_year_rank AS ( SELECT *,
								DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laidoff DESC) AS d_rank 
								FROM company_total_laidoff 
								WHERE `year` IS NOT NULL)
SELECT *
FROM company_year_rank 
WHERE d_rank <= 5;