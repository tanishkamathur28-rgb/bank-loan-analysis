-- ============================================
-- 8_repayment_and_profitability.sql
-- Repayment & Profitability Analysis: are loans collecting more than they cost?
-- ============================================

USE company_loan;

-- 1. TOP 10 MOST PROFITABLE LOANS (total_payment vs loan_amount)
SELECT
    id,
    loan_amount,
    total_payment,
    ROUND(total_payment - loan_amount, 2) AS profit_or_loss
FROM loan_data
ORDER BY profit_or_loss DESC
LIMIT 10;

-- 2. TOP 10 BIGGEST LOSSES (charged-off loans where payment fell short)
SELECT
    id,
    loan_amount,
    total_payment,
    loan_type,
    ROUND(total_payment - loan_amount, 2) AS profit_or_loss
FROM loan_data
WHERE loan_type = 'Bad'
ORDER BY profit_or_loss ASC
LIMIT 10;

-- 3. TOP 10 MOST INCOME-BURDENED BORROWERS (installment as % of annual income)
SELECT
    id,
    annual_income,
    installment,
    ROUND((installment * 12) / annual_income * 100, 2) AS yearly_installment_ratio
FROM loan_data
ORDER BY yearly_installment_ratio DESC
LIMIT 10;

-- 4. OVERALL PORTFOLIO PROFITABILITY (closing summary metric)
SELECT
    SUM(loan_amount) AS total_funded,
    SUM(total_payment) AS total_received,
    ROUND(SUM(total_payment) - SUM(loan_amount), 2) AS net_profit_or_loss,
    ROUND((SUM(total_payment) - SUM(loan_amount)) * 100.0 / SUM(loan_amount), 2) AS overall_return_percentage
FROM loan_data;
