-- ============================================
-- 4_loan_status_breakdown.sql
-- Breaking down the loan book across key categorical dimensions
-- ============================================

USE company_loan;

-- 1. STATE-WISE LOAN APPLICATIONS AND FUNDED AMOUNT
SELECT
    address_state,
    COUNT(*) AS total_applications,
    SUM(loan_amount) AS total_funded_amount
FROM loan_data
GROUP BY address_state
ORDER BY total_applications DESC;

-- 2. GRADE-WISE LOAN APPLICATIONS
SELECT
    grade,
    COUNT(*) AS total_applications
FROM loan_data
GROUP BY grade
ORDER BY grade;

-- 3. LOAN STATUS BREAKDOWN (raw status)
SELECT
    loan_status,
    COUNT(*) AS total_applications
FROM loan_data
GROUP BY loan_status
ORDER BY total_applications DESC;

-- 4. GOOD vs BAD vs CURRENT (using cleaned loan_type column)
SELECT
    loan_type,
    COUNT(*) AS total_applications,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM loan_data), 2) AS percentage_of_total
FROM loan_data
GROUP BY loan_type
ORDER BY total_applications DESC;

-- 5. PURPOSE-WISE LOAN APPLICATIONS
SELECT
    purpose,
    COUNT(*) AS total_applications
FROM loan_data
GROUP BY purpose
ORDER BY total_applications DESC;

-- 6. VERIFICATION STATUS BREAKDOWN
SELECT
    verification_status,
    COUNT(*) AS total_applications
FROM loan_data
GROUP BY verification_status
ORDER BY total_applications DESC;

-- 7. HOME OWNERSHIP BREAKDOWN
SELECT
    home_ownership,
    COUNT(*) AS total_applications
FROM loan_data
GROUP BY home_ownership
ORDER BY total_applications DESC;

-- 8. EMP_LENGTH BREAKDOWN (now sorts correctly using emp_years)
SELECT
    emp_years,
    emp_length,
    COUNT(*) AS total_applications
FROM loan_data
GROUP BY emp_years, emp_length
ORDER BY emp_years;
