set echo on;
set linesize 132;
set pagesize 66;
spool c:\cprg250\Assignment1\ass1_result.txt

--Q1 
select distinct c.customer_number as "Cust#", account_type as "Account Type", 
date_created as "Date", (case 
when Address1 = 'Apt 201' then replace('Apt 201', 'Apt', 'Apartment')
else Address1
end) "Address"
from wgb_customer c, wgb_account a
where to_char(date_created, 'mm') = '07'
and c.customer_number=a.customer_number
order by "Cust#";

--Q2
select first_name as "First", surname as "Last", Phone, 
c.customer_number as "Cust#", account_type as "Type", balance as "$"
from wgb_customer c, wgb_account a
where c.customer_number=a.customer_number
and account_type = 1
order by 2, 1, 4, 5;

--Q3
select first_name as "First", surname as "Last", Phone, 
c.customer_number as "Cust#", account_type as "Type", balance as "$"
from wgb_customer c join wgb_account a ON(c.customer_number=a.customer_number)
where account_type = 2
order by 2, 1, 4, 5;

--Q4
column "Description" format A25
column "Amount" format A12
select distinct first_name as "Name", account_description as "Description",
balance, transaction_date as "Date", lpad(transaction_amount, 9, '*') as "Amount"
from wgb_customer c, wgb_account_type y, wgb_account a, wgb_transaction t
where account_description like '%Interest%'
and y.account_type=t.account_type and y.account_type=a.account_type
and c.customer_number=a.customer_number and c.customer_number=t.customer_number
order by 1 desc;
clear columns;
--Q5
column "Date" format A10
select distinct first_name as "First", surname as "Last", customer_number as "Cust#",
replace(date_created, '-', '/') as "Date", a.account_type as "Type"
from wgb_customer join wgb_account a using (customer_number)
order by 2, 1, 3, 5;
clear columns;

--Q6
select distinct first_name as "First", surname as "Last", customer_number as "Cust#", 
(case
when a.account_type = 1 then 'Chq'
when a.account_type = 2 then 'Daily Sav'
when a.account_type = 3 then 'Mthly Sav'
when a.account_type = 4 then 'RRSP'
when a.account_type = 5 then 'GIC'
end)  "Type", to_char(balance, '$99,999.00') as "Opening Balance"
from wgb_customer c join wgb_account a using (customer_number)
order by 1, 4 desc;

spool off