-- ============================================
-- 6_borrower_profile_analysis.sql
-- Borrower Profile Analysis: income, tenure, employer, and purpose patterns
-- ============================================

USE company_loan;

-- 1. AVERAGE DTI BY EMPLOYMENT TENURE
SELECT
    emp_years,
    emp_length,
    ROUND(AVG(dti), 4) AS avg_dti
FROM loan_data
GROUP BY emp_years, emp_length
ORDER BY emp_years DESC;

-- 2. TOP 5 EMPLOYERS BY LOAN COUNT
SELECT
    emp_title,
    COUNT(*) AS total_loans
FROM loan_data
WHERE emp_title IS NOT NULL AND emp_title != ''
GROUP BY emp_title
ORDER BY total_loans DESC
LIMIT 5;

-- 3. AVERAGE INCOME BY LOAN PURPOSE
SELECT
    purpose,
    ROUND(AVG(annual_income), 2) AS avg_income
FROM loan_data
GROUP BY purpose
ORDER BY avg_income DESC;

-- 4. AVERAGE INCOME AND DTI BY HOME OWNERSHIP
SELECT
    home_ownership,
    ROUND(AVG(annual_income), 2) AS avg_income,
    ROUND(AVG(dti), 4) AS avg_dti,
    COUNT(*) AS total_applications
FROM loan_data
GROUP BY home_ownership
ORDER BY avg_income DESC;

-- 5. DEFAULT RATE BY VERIFICATION STATUS
SELECT
    verification_status,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) AS defaults,
    ROUND(SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percentage
FROM loan_data
GROUP BY verification_status
ORDER BY default_rate_percentage DESC;
