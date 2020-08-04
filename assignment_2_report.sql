set echo on;
set linesize 132;
set pagesize 66;
spool c:\cprg250\Assignment2\assignment_2_report.txt


--Question 6:
SET RECSEP WRAPPED
SET RECSEPCHAR "*"
ttitle center "Transaction Report" right 'Page:' sql.pno skip 2
column "Name" format a20
column "Cust #" format a15
column "Account Desc" format a25
column "Date" format a20
column "Trans #" format a8
column "Amount" format a15
break on "Name"
break on "Name" on "Cust #" skip 1 on "Account Desc" skip 1 on report
compute sum label 'Acct Ttl' of transaction_amount on "Cust #" 
compute sum label 'Cust Ttl' of transaction_amount on "Name";
select surname ||', '|| first_name as "Name", c.customer_number ||'-'||tr.account_type as "Cust #", account_description as "Account Desc", to_char(transaction_date, 'MON/dd, yyyy') as "Date", to_char(tr.transaction_number, '99') as "Trans #", 
(case
when transaction_type = 'D' then to_char(-1*transaction_amount, '$999,999.99')
else to_char(transaction_amount, '$999,999.99')
end) as "Amount"
from wgb_customer c, wgb_account_type ty, wgb_transaction tr
where ty.account_type=tr.account_type
and c.customer_number =tr.customer_number
order by tr.transaction_number, first_name, c.customer_number, tr.account_type, account_description, transaction_date ;

spool off
