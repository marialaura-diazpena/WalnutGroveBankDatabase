set echo on;
set linesize 132;
set pagesize 66;
spool c:\cprg250\Assignment2\assignment_2.txt

--Question 1:
column "Full Name" format A25
column "Balance Level" format A65
select first_name ||' '|| middle_name ||' '|| surname as "Full name", balance, 
(case 
when balance = 0 then 'Zero Balance'
when balance <=1000 then 'Low Balance in '||account_description
when balance <=5000 then 'Intermediate Balance in '||account_description
when balance >5000 then 'High Balance in '|| account_description
end) "Balance Level"
from wgb_customer c, wgb_account a, wgb_account_type t
where a.account_type = t.account_type and c.customer_number=a.customer_number
order by 1, 2 desc;

clear columns;

--Question 2:
select first_name as "First", surname as "Last", phone "Phone number", c.customer_number "Acct#", a.account_type as "Acct Type", to_char(balance, '$99,999.99') as "Largest Balance"
from wgb_customer c, wgb_account a, wgb_account_type t
where c.customer_number=a.customer_number 
and a.account_type = t.account_type
and balance in (select balance from wgb_account where balance >= 2000)
order by 5, 1;

--Question 3:
select first_name as "First", surname as "Last", phone "Phone number", c.customer_number "Acct#", a.account_type as "Acct Type", to_char(max(balance), '$99,999.99') as "Largest Balance"
from wgb_customer c, wgb_account a, wgb_account_type t
where c.customer_number=a.customer_number 
and balance >= 2000
and a.account_type in 
(select account_type 
from wgb_account 
where account_type = t.account_type)
group by first_name, surname, phone, c.customer_number, a.account_type
order by 5, 1;

clear columns;

--Question 4:
column "Full Name" format A25
column "Full Address" format a25
select upper(surname) ||', '|| first_name as "Full name", address1||', '||city||', '||province as "Full Address", to_char(date_entered, 'MON/YY') as "Date Entered", count(a.customer_number) as "# of Accounts", row_number () over (order by count(a.customer_number) desc) as "Position"
from wgb_customer c,wgb_account a
join wgb_account_type ty using (account_type)
join wgb_transaction tr using (account_type)
where a.customer_number=c.customer_number
and a.customer_number=tr.customer_number
group by first_name, surname, address1, city, province, date_entered
order by 4 desc
fetch next 2 rows only;
 
clear columns;

--Question 5:
select first_name as "First Name", surname as "Last Name", transaction_date as "Trans. Date", transaction_amount as "Transaction Amount", to_char(sum(transaction_amount), '$99,999.99') "Total"
from wgb_customer c, wgb_transaction tr, wgb_account_type ty, wgb_account a
where c.customer_number=tr.customer_number
and tr.account_type=ty.account_type
and tr.account_type=a.account_type
and c.customer_number=a.customer_number
and address2 is null
group by 
rollup ((first_name, surname), transaction_date, transaction_amount)
order by 1, 3;
 
spool off