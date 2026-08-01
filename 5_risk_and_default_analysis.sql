-- ============================================
-- 5_risk_and_default_analysis.sql
-- Risk Analysis: where defaults concentrate across state, term, and grade
-- ============================================

USE company_loan;

-- 1. DEFAULT RATE BY STATE
SELECT
    address_state,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) AS defaults,
    ROUND(SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percentage
FROM loan_data
GROUP BY address_state
ORDER BY default_rate_percentage DESC;

-- 2. TERM-WISE DEFAULT RATE
SELECT
    term,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) AS defaults,
    ROUND(SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percentage
FROM loan_data
GROUP BY term;

-- 3. GRADE-WISE DEFAULT RATE
SELECT
    grade,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) AS defaults,
    ROUND(SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percentage
FROM loan_data
GROUP BY grade
ORDER BY grade;

-- 4. SUB-GRADE-WISE DEFAULT RATE
SELECT
    sub_grade,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) AS defaults,
    ROUND(SUM(CASE WHEN loan_type = 'Bad' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_percentage
FROM loan_data
GROUP BY sub_grade
ORDER BY sub_grade;

-- 5. AVERAGE DTI BY LOAN_TYPE (does DTI actually predict default in this data?)
SELECT
    loan_type,
    ROUND(AVG(dti), 4) AS avg_dti,
    COUNT(*) AS total_loans
FROM loan_data
GROUP BY loan_type
ORDER BY avg_dti DESC;
