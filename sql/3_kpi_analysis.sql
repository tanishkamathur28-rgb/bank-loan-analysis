-- ============================================
-- 3_kpi_analysis.sql
-- KPI Analysis: core metrics summarizing loan book size, pricing, and health
-- ============================================

USE company_loan;

-- 1. TOTAL LOAN APPLICATIONS
SELECT COUNT(*) AS total_applications
FROM loan_data;

-- 2. TOTAL UNIQUE BORROWERS
SELECT COUNT(DISTINCT member_id) AS total_unique_borrowers
FROM loan_data;

-- 3. TOTAL FUNDED AMOUNT
SELECT SUM(loan_amount) AS total_funded_amount
FROM loan_data;

-- 4. TOTAL AMOUNT RECEIVED
SELECT SUM(total_payment) AS total_amount_received
FROM loan_data;

-- 5. AVERAGE LOAN AMOUNT PER APPLICATION
SELECT ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loan_data;

-- 6. AVERAGE INSTALLMENT AMOUNT
SELECT ROUND(AVG(installment), 2) AS avg_installment
FROM loan_data;

-- 7. AVERAGE INTEREST RATE
SELECT ROUND(AVG(int_rate) * 100, 2) AS avg_interest_rate_percentage
FROM loan_data;

-- 8. AVERAGE DTI
SELECT ROUND(AVG(dti) * 100, 2) AS avg_dti_percentage
FROM loan_data;

-- 9. GOOD LOAN % vs BAD LOAN % vs CURRENT
SELECT
    loan_type,
    COUNT(*) AS total_loans,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loan_data), 2) AS percentage_of_applications,
    SUM(loan_amount) AS total_funded_amount,
    ROUND(SUM(loan_amount) * 100.0 / (SELECT SUM(loan_amount) FROM loan_data), 2) AS percentage_of_funded_amount
FROM loan_data
GROUP BY loan_type
ORDER BY total_loans DESC;

-- 10. MONTH-OVER-MONTH TREND: applications & funded amount by issue_month
SELECT
    issue_month,
    COUNT(*) AS total_applications,
    SUM(loan_amount) AS total_funded_amount
FROM loan_data
GROUP BY issue_month
ORDER BY issue_month;
