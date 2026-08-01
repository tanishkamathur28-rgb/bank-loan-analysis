-- ============================================
-- 2_data_cleaning.sql
-- Cleaning raw loan_data before analysis
-- ============================================

USE company_loan;

-- Disable safe update mode for this session (needed for the UPDATE
-- statements below, which intentionally affect every row)
SET SQL_SAFE_UPDATES = 0;

-- 1. Sanity check: structure and row count
DESCRIBE loan_data;
SELECT COUNT(*) AS total_rows FROM loan_data;

-- 2. Check for duplicate loan IDs / member IDs
SELECT id, COUNT(*)
FROM loan_data
GROUP BY id
HAVING COUNT(*) > 1;

SELECT member_id, COUNT(*)
FROM loan_data
GROUP BY member_id
HAVING COUNT(*) > 1;
-- No duplicates found — documented here as a check, not a fix

-- 3. Check for missing values in key columns
-- (blank text fields load as '' rather than NULL, so both are checked)
SELECT
    SUM(emp_title IS NULL OR emp_title = '') AS missing_emp_title,
    SUM(emp_length IS NULL OR emp_length = '') AS missing_emp_length,
    SUM(annual_income IS NULL) AS missing_income,
    SUM(loan_status IS NULL OR loan_status = '') AS missing_status
FROM loan_data;
-- emp_title has 1,433 missing values out of 38,576 rows
-- Left as NULL rather than dropped, since income/loan_amount are intact

-- 4. Fix date columns: convert varchar -> proper DATE type
-- Source format confirmed as DD-MM-YYYY (e.g. 11-02-2021)
ALTER TABLE loan_data ADD COLUMN issue_date_clean DATE;
UPDATE loan_data SET issue_date_clean = STR_TO_DATE(issue_date, '%d-%m-%Y');
ALTER TABLE loan_data DROP COLUMN issue_date;
ALTER TABLE loan_data CHANGE issue_date_clean issue_date DATE;

ALTER TABLE loan_data ADD COLUMN last_payment_date_clean DATE;
UPDATE loan_data SET last_payment_date_clean = STR_TO_DATE(last_payment_date, '%d-%m-%Y');
ALTER TABLE loan_data DROP COLUMN last_payment_date;
ALTER TABLE loan_data CHANGE last_payment_date_clean last_payment_date DATE;

ALTER TABLE loan_data ADD COLUMN last_credit_pull_date_clean DATE;
UPDATE loan_data SET last_credit_pull_date_clean = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y');
ALTER TABLE loan_data DROP COLUMN last_credit_pull_date;
ALTER TABLE loan_data CHANGE last_credit_pull_date_clean last_credit_pull_date DATE;

ALTER TABLE loan_data ADD COLUMN next_payment_date_clean DATE;
UPDATE loan_data SET next_payment_date_clean = STR_TO_DATE(next_payment_date, '%d-%m-%Y');
ALTER TABLE loan_data DROP COLUMN next_payment_date;
ALTER TABLE loan_data CHANGE next_payment_date_clean next_payment_date DATE;

-- 5. Trim whitespace from text fields (term has a leading space: ' 36 months')
UPDATE loan_data SET term = TRIM(term);
UPDATE loan_data SET emp_title = TRIM(emp_title);
UPDATE loan_data SET purpose = TRIM(purpose);
UPDATE loan_data SET home_ownership = TRIM(home_ownership);
UPDATE loan_data SET verification_status = TRIM(verification_status);

-- 6. Convert emp_length text -> numeric emp_years
-- (fixes incorrect alphabetical sorting on the raw text column)
ALTER TABLE loan_data ADD COLUMN emp_years INT;

UPDATE loan_data
SET emp_years =
    CASE
        WHEN emp_length = '< 1 year' THEN 0
        WHEN emp_length = '10+ years' THEN 10
        ELSE CAST(SUBSTRING_INDEX(emp_length, ' ', 1) AS UNSIGNED)
    END;

-- 7. Create a loan_type flag (Good / Bad / Current) for easier downstream analysis
ALTER TABLE loan_data ADD COLUMN loan_type VARCHAR(10);

UPDATE loan_data
SET loan_type =
    CASE
        WHEN loan_status = 'Fully Paid' THEN 'Good'
        WHEN loan_status = 'Charged Off' THEN 'Bad'
        WHEN loan_status = 'Current' THEN 'Current'
    END;

-- 8. Create issue_month (YYYY-MM) for trend analysis
ALTER TABLE loan_data ADD COLUMN issue_month VARCHAR(7);
UPDATE loan_data SET issue_month = DATE_FORMAT(issue_date, '%Y-%m');

-- 9. Final check
SELECT * FROM loan_data LIMIT 10;
