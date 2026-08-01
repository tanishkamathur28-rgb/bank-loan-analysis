-- ============================================
-- 7_grade_and_pricing_analysis.sql
-- Grade & Pricing Analysis: how loan grade relates to amount, rate, and risk
-- ============================================

USE company_loan;

-- 1. AVERAGE LOAN AMOUNT BY GRADE
SELECT
    grade,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loan_data
GROUP BY grade
ORDER BY grade;

-- 2. AVERAGE INTEREST RATE BY SUB-GRADE
SELECT
    sub_grade,
    ROUND(AVG(int_rate) * 100, 2) AS avg_int_rate_percentage
FROM loan_data
GROUP BY sub_grade
ORDER BY sub_grade;

-- 3. AVERAGE INTEREST RATE BY LOAN_TYPE (checks if risk was priced correctly)
SELECT
    loan_type,
    ROUND(AVG(int_rate) * 100, 2) AS avg_int_rate_percentage,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
    COUNT(*) AS total_loans
FROM loan_data
GROUP BY loan_type
ORDER BY avg_int_rate_percentage DESC;

-- 4. AVERAGE INTEREST RATE BY GRADE (pairs with query 1 to show the pricing curve)
SELECT
    grade,
    ROUND(AVG(int_rate) * 100, 2) AS avg_int_rate_percentage
FROM loan_data
GROUP BY grade
ORDER BY grade;
