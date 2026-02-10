# Bank Statement Generator

I built this project to automate the generation of daily bank statement reports for ATM, UPI, and IMPS transactions. It runs on AIX server and generates CSV reports automatically every day.

## What This Project Does

Every day at 6 AM, this system automatically connects to Oracle database and generates three CSV reports:
- ATM transaction statement
- UPI transaction statement
- IMPS transaction statement

## What You'll Need

- AIX 7.3 operating system
- Korn Shell (ksh)
- Oracle 19c database (SATPROD)
- SQL*Plus installed

## How It's Organized
```
bank-statement-generator/
+-- sql/                    # SQL scripts for each report
¦   +-- atm_statement.sql   # ATM transactions query
¦   +-- upi_statement.sql   # UPI transactions query
¦   +-- imps_statement.sql  # IMPS transactions query
+-- scripts/                # Shell scripts
¦   +-- daily_reports.sh    # Automated daily report script
+-- logs/                   # Log files (not pushed to GitHub)
```

## How to Use

### Manual Report Generation

For ATM statement:
```bash
cd /home/finadm/ATM_STMT
sqlplus <username>/<password>@<database> @atm_statement.sql
```

For UPI statement:
```bash
sqlplus <username>/<password>@<database> @upi_statement.sql
```

For IMPS statement:
```bash
sqlplus <username>/<password>@<database> @imps_statement.sql
```

### Using Aliases (Shortcut)

Add these to your ~/.profile:
```bash
alias atmstmt='cd /home/finadm/ATM_STMT && sqlplus <username>/<password>@<database> @atm_statement.sql'
alias upistmt='cd /home/finadm/ATM_STMT && sqlplus <username>/<password>@<database> @upi_statement.sql'
alias impsstmt='cd /home/finadm/ATM_STMT && sqlplus <username>/<password>@<database> @imps_statement.sql'
```

Then just type `atmstmt`, `upistmt`, or `impsstmt` to generate reports!

### Automated Daily Reports

The script runs automatically at 6 AM every day via cron:
```bash
0 6 * * * /home/finadm/ATM_STMT/scripts/daily_reports.sh
```

## What I Learned

This project taught me a lot about:
- Writing SQL queries for financial data
- Automating tasks with shell scripts
- Scheduling jobs with cron
- Working with Oracle database on AIX

## Technologies Used

- Korn Shell (ksh) for automation scripts
- Oracle SQL and SQL*Plus for database queries
- AIX 7.3 as the operating system
- Cron for job scheduling
- Git and GitHub for version control

## About Me

I'm Bhushan, and I created this project while working with banking systems. It helped automate daily manual tasks and save time every morning!