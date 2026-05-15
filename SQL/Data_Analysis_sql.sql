create database consumer_financial_complaints;
use consumer_financial_complaints;
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_financial_complaints.csv'
INTO TABLE financial_complaints
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Total Complaints
select count(*) from financial_complaints;

---------------------------------------------------------------------------------
-- Product Wise Complaints in Descending Order
---------------------------------------------------------------------------------
select 
	Product, 
    count(`Complaint ID`) as Total_Complaints
from financial_complaints 
group by Product 
order by Total_Complaints desc;

---------------------------------------------------------------------------------
--  Sub-Product Wise Complaints in Descending Order
---------------------------------------------------------------------------------
select 
	`Sub-product`, 
    count(`Complaint ID`) as Total_Complaints
from financial_complaints 
group by `Sub-product`
order by Total_Complaints desc;

---------------------------------------------------------------------------------
-- Submission Channel Wise Complaints
---------------------------------------------------------------------------------
select
	`Submitted via` as Submission_Channel,
    count(`Complaint ID`) as Total_Complaints
from financial_complaints 
group by  `Submitted via`
order by Total_Complaints desc;

---------------------------------------------------------------------------------
-- State Wise Complaints
---------------------------------------------------------------------------------
select
	State,
    count(`Complaint ID`) as Total_Complaints
from financial_complaints 
group by State
order by Total_Complaints desc;

---------------------------------------------------------------------------------
-- Region Wise Complaints
---------------------------------------------------------------------------------
select
	Census_Region,
    count(`Complaint ID`) as Total_Complaints
from financial_complaints 
group by Census_Region
order by Total_Complaints desc; 

---------------------------------------------------------------------------------
-- Year Wise Complaints
---------------------------------------------------------------------------------
Select 
	year(`Date submitted`) as Complaint_Year,
    count(`Complaint ID`) as Total_Complaints
from financial_complaints
group by year(`Date submitted`)
order by Complaint_Year;

---------------------------------------------------------------------------------
-- Month Wise Complaints
---------------------------------------------------------------------------------
select
	month(`Date submitted`) as Complaint_Month,
    count(`Complaint ID`) as Total_Complaints
from financial_complaints
group by month(`Date submitted`)
order by Complaint_Month;

---------------------------------------------------------------------------------
-- Month Wise Complaints Each Year
---------------------------------------------------------------------------------
select
	year(`Date submitted`) as Complaint_Year,
	month(`Date submitted`) as Complaint_Month,
    count(`Complaint ID`) as Total_Complaints
from financial_complaints
group by 
	year(`Date submitted`),
	month(`Date submitted`)
order by 
	Complaint_Year,
	Complaint_Month;
    
---------------------------------------------------------------------------------
-- Timely Responded or Not
---------------------------------------------------------------------------------
select 
	`Timely response?` ,
    count(`Timely response?`) as Total_Complaints
from financial_complaints
group by `Timely response?`
order by Total_Complaints desc;

---------------------------------------------------------------------------------
-- Top 10 Issues for Complaints
---------------------------------------------------------------------------------
select
	Issue,
    count(`Timely response?`) as Total_Complaints
from financial_complaints
group by Issue
order by Total_Complaints desc limit 10;

---------------------------------------------------------------------------------
-- Top 10 Sub-Issues for Complaints
---------------------------------------------------------------------------------
select
	`Sub-issue`,
    count(`Timely response?`) as Total_Complaints
from financial_complaints
group by `Sub-issue`
order by Total_Complaints desc limit 10;

---------------------------------------------------------------------------------
-- Products with their Top 3 Issues
---------------------------------------------------------------------------------
SELECT Product, Issue, Complaint_Count
FROM (
    SELECT 
        Product, 
        Issue, 
        COUNT(*) AS Complaint_Count,
        DENSE_RANK() OVER (PARTITION BY Product ORDER BY COUNT(*) DESC) as Issue_Rank
    FROM financial_complaints
    GROUP BY Product, Issue
) AS Ranked_Issues
WHERE Issue_Rank <= 3
ORDER BY Product, Issue_Rank;

---------------------------------------------------------------------------------
-- Top 10 Companies with the most Timely Responses
---------------------------------------------------------------------------------
select
	Company_ID_1081,
    count(`Timely response?`) as Timely_Responses
from financial_complaints
where `Timely response?` = 'Yes'
group by Company_ID_1081
order by Timely_Responses desc
limit 10;

---------------------------------------------------------------------------------
-- Top 10 Companies with the most Late Responses
---------------------------------------------------------------------------------
select
	`Company_ID_1081`,
    count(`Timely response?`) as late_Responses
from financial_complaints
where `Timely response?` = 'No'
group by Company_ID_1081
order by late_Responses
limit 10;

