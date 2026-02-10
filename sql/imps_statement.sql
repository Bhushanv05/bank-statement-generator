ACCEPT from_date CHAR PROMPT 'Enter From Date (DD-MM-YY): ' 
ACCEPT to_date CHAR PROMPT 'Enter To Date (DD-MM-YY): ' 

SET MARKUP CSV ON QUOTE ON 
SET PAGESIZE 0 
SET LINESIZE 32767 
SET FEEDBACK OFF 
SET HEADING ON 
SET TRIMSPOOL ON 
SET ECHO OFF 
SET TERMOUT OFF 

SPOOL imps_statement_&from_date._to_&to_date..csv 

SELECT tran_date, value_date , tran_id, part_tran_type, tran_amt, tran_particular FROM tbaadm.htd
WHERE acid='AA45559' 
AND del_flg='N'
AND trunc(tran_date)BETWEEN TO_DATE('&from_date','DD-MM-YY') AND TO_DATE('&to_date','DD-MM-YY')
UNION ALL
SELECT tran_date, value_date , tran_id, part_tran_type, tran_amt, tran_particular FROM tbaadm.dtd
WHERE acid='AA45559' 
AND del_flg='N'
AND trunc(tran_date) = TO_DATE('&to_date','DD-MM-YY')
order by value_date;

 SPOOL OFF 
 SET TERMOUT ON 
 EXIT;