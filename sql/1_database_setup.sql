-- ============================================
-- 1_database_setup.sql
-- Creates the database and loads the raw dataset
-- ============================================

CREATE DATABASE IF NOT EXISTS company_loan;
USE company_loan;

DROP TABLE IF EXISTS loan_data;

CREATE TABLE loan_data (
    id                       INT,
    address_state            VARCHAR(2),
    application_type         VARCHAR(20),
    emp_length               VARCHAR(20),
    emp_title                VARCHAR(100),
    grade                    CHAR(1),
    home_ownership           VARCHAR(20),
    issue_date               VARCHAR(20),
    last_credit_pull_date    VARCHAR(20),
    last_payment_date        VARCHAR(20),
    loan_status              VARCHAR(20),
    next_payment_date        VARCHAR(20),
    member_id                BIGINT,
    purpose                  VARCHAR(20),
    sub_grade                VARCHAR(5),
    term                     VARCHAR(20),
    verification_status      VARCHAR(50),
    annual_income            INT,
    dti                      DECIMAL(6,4),
    installment              DECIMAL(10,2),
    int_rate                 DECIMAL(6,4),
    loan_amount              INT,
    total_acc                INT,
    total_payment            DECIMAL(10,2)
);

-- NOTE: Update the file path below to match your local machine
-- (check your MySQL secure_file_priv folder with:
--  SHOW VARIABLES LIKE 'secure_file_priv';)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/financial_loan.csv'
INTO TABLE loan_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Quick sanity check after import
SELECT COUNT(*) AS total_rows_loaded FROM loan_data;
SELECT * FROM loan_data LIMIT 5;
