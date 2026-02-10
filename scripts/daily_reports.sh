#!/bin/ksh
#####################################
# Daily Report Generation Script
# Runs at 00:05 AM every day
#####################################

# Load Finacle/Oracle environment for cron
. /etc/b2k/SATPROD/FINCORE/com/commonenv.com 2>/dev/null
export ORACLE_HOME=/apporacle/app/oracle/product/19.0.0/client
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8

# Log file
LOGFILE="/home/finadm/ATM_STMT/logs/daily_reports_$(date +%Y%m%d).log"
echo "========================================" >> $LOGFILE
echo "Report Generation Started: $(date)" >> $LOGFILE
echo "========================================" >> $LOGFILE

# Output directory
OUTPUT_DIR="/home/finadm/ATM_STMT"
cd $OUTPUT_DIR

# Get yesterday's and today's date
YESTERDAY=$(TZ=GMT+24 date +%d-%m-%y)
TODAY=$(date +%d-%m-%y)

echo "TODAY: $TODAY" >> $LOGFILE
echo "YESTERDAY: $YESTERDAY" >> $LOGFILE
echo "Generating reports from: $YESTERDAY to $TODAY" >> $LOGFILE
echo "" >> $LOGFILE

#####################################
# Generate ATM Statement
#####################################
echo "Starting ATM Statement..." >> $LOGFILE
sqlplus -s system/SYSadm123@SATPROD >> $LOGFILE 2>&1 <<SQLEOF
@atm_statement.sql
$YESTERDAY
$TODAY
SQLEOF

if [ -f "atm_statement_${YESTERDAY}_to_${TODAY}.csv" ]; then
    echo "? ATM Statement generated successfully" >> $LOGFILE
else
    echo "? ATM Statement FAILED" >> $LOGFILE
fi
echo "" >> $LOGFILE

#####################################
# Generate UPI Statement
#####################################
echo "Starting UPI Statement..." >> $LOGFILE
sqlplus -s system/SYSadm123@SATPROD >> $LOGFILE 2>&1 <<SQLEOF
@upi_statement.sql
$YESTERDAY
$TODAY
SQLEOF

echo "? UPI Statement completed" >> $LOGFILE
echo "" >> $LOGFILE

#####################################
# Generate IMPS Statement
#####################################
echo "Starting IMPS Statement..." >> $LOGFILE
sqlplus -s system/SYSadm123@SATPROD >> $LOGFILE 2>&1 <<SQLEOF
@imps_statement.sql
$YESTERDAY
$TODAY
SQLEOF

echo "? IMPS Statement completed" >> $LOGFILE
echo "" >> $LOGFILE

#####################################
# Generate POS Statement
#####################################
echo "Starting POS Statement..." >> $LOGFILE
sqlplus -s system/SYSadm123@SATPROD >> $LOGFILE 2>&1 <<SQLEOF
@pos_statement.sql
$YESTERDAY
$TODAY
SQLEOF

echo "? POS Statement completed" >> $LOGFILE
echo "" >> $LOGFILE

#####################################
# Summary
#####################################
echo "========================================" >> $LOGFILE
echo "Report Generation Completed: $(date)" >> $LOGFILE
echo "========================================" >> $LOGFILE
echo "" >> $LOGFILE
echo "Generated Files:" >> $LOGFILE
ls -lh *${YESTERDAY}*${TODAY}*.csv 2>/dev/null >> $LOGFILE
ls -lh *${YESTERDAY}_to_${TODAY}*.csv 2>/dev/null >> $LOGFILE

echo "Daily report generation completed"
exit 0
