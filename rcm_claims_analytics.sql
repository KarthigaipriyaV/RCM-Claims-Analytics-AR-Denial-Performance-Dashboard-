-- =====================================================================
-- RCM Claims Analytics & AR / Denial Performance Dashboard
-- Tools: SQL (works on SQL Server and Snowflake)
-- Author: Karthigaipriya
--
-- Sections
--   1. Create claims table
--   2. Load sample data (anonymized, no patient information)
--   3. Denial analysis (denial rate, reasons, preventable denials)
--   4. Payment lag and AR aging
--   5. Payer performance
--   6. Data quality checks
-- =====================================================================


-- =====================================================================
-- 1. CREATE TABLE
-- =====================================================================

CREATE TABLE claims (
    claim_id        INT,
    payer           VARCHAR(50),
    billing_date    DATE,
    payment_date    DATE,            -- NULL if not yet paid
    charge_amount   DECIMAL(12, 2),
    paid_amount     DECIMAL(12, 2),
    claim_status    VARCHAR(20),     -- Paid, Denied, Pending
    denial_reason   VARCHAR(50)      -- NULL if not denied
);


-- =====================================================================
-- 2. SAMPLE DATA (anonymized)
-- =====================================================================

INSERT INTO claims VALUES
    (1,  'Medicare',   '2026-06-01', '2026-06-20', 1000.00,  800.00, 'Paid',    NULL),
    (2,  'Medicare',   '2026-06-05', '2026-06-30', 1500.00, 1200.00, 'Paid',    NULL),
    (3,  'Aetna',      '2026-06-10', NULL,          900.00,    0.00, 'Denied',  'Missing Information'),
    (4,  'Aetna',      '2026-07-02', '2026-07-25', 1200.00,  950.00, 'Paid',    NULL),
    (5,  'Cigna',      '2026-07-10', NULL,         2000.00,    0.00, 'Denied',  'Medical Necessity'),
    (6,  'Cigna',      '2026-07-15', '2026-08-12', 1100.00,  900.00, 'Paid',    NULL),
    (7,  'UnitedHC',   '2026-08-01', NULL,         1800.00,    0.00, 'Denied',  'Duplicate Claim'),
    (8,  'UnitedHC',   '2026-08-12', '2026-09-05', 1300.00, 1050.00, 'Paid',    NULL),
    (9,  'Medicaid',   '2026-09-01', NULL,          700.00,    0.00, 'Pending', NULL),
    (10, 'Medicaid',   '2026-09-10', NULL,          850.00,    0.00, 'Denied',  'Eligibility'),
    (11, 'Aetna',      '2026-09-20', NULL,         1600.00,    0.00, 'Pending', NULL),
    (12, 'Medicare',   '2026-10-05', NULL,         1400.00,    0.00, 'Pending', NULL);


-- =====================================================================
-- 3. DENIAL ANALYSIS
-- =====================================================================

-- 3.1 Overall denial rate (by count and by amount)
SELECT
    COUNT(*)                                                        AS total_claims,
    SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END)        AS denied_claims,
    ROUND(100.0 * SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                            AS denial_rate_pct,
    SUM(charge_amount)                                              AS total_charges,
    SUM(CASE WHEN claim_status = 'Denied' THEN charge_amount ELSE 0 END) AS denied_amount
FROM claims;

-- 3.2 Denials by reason
SELECT
    denial_reason,
    COUNT(*)                                                        AS denied_claims,
    SUM(charge_amount)                                              AS denied_amount,
    ROUND(100.0 * SUM(charge_amount) / SUM(SUM(charge_amount)) OVER (), 2) AS pct_of_denied_amount
FROM claims
WHERE claim_status = 'Denied'
GROUP BY denial_reason
ORDER BY denied_amount DESC;

-- 3.3 Preventable vs non-preventable denials
-- Preventable = front-end / process errors that could have been avoided.
SELECT
    CASE
        WHEN denial_reason IN ('Missing Information', 'Duplicate Claim', 'Eligibility')
            THEN 'Preventable'
        ELSE 'Non-preventable'
    END                                                             AS denial_type,
    COUNT(*)                                                        AS denied_claims,
    SUM(charge_amount)                                              AS denied_amount
FROM claims
WHERE claim_status = 'Denied'
GROUP BY
    CASE
        WHEN denial_reason IN ('Missing Information', 'Duplicate Claim', 'Eligibility')
            THEN 'Preventable'
        ELSE 'Non-preventable'
    END;


-- =====================================================================
-- 4. PAYMENT LAG AND AR AGING
-- =====================================================================

-- 4.1 Payment lag (days from billing to payment) for paid claims
SELECT
    payer,
    COUNT(*)                                                        AS paid_claims,
    AVG(DATEDIFF(day, billing_date, payment_date))                  AS avg_payment_lag_days,
    MAX(DATEDIFF(day, billing_date, payment_date))                  AS max_payment_lag_days
FROM claims
WHERE claim_status = 'Paid'
GROUP BY payer
ORDER BY avg_payment_lag_days DESC;

-- 4.2 AR aging buckets for unpaid claims (as of 2026-10-23)
SELECT
    CASE
        WHEN DATEDIFF(day, billing_date, CAST('2026-10-23' AS DATE)) <= 30 THEN '0-30 days'
        WHEN DATEDIFF(day, billing_date, CAST('2026-10-23' AS DATE)) <= 60 THEN '31-60 days'
        WHEN DATEDIFF(day, billing_date, CAST('2026-10-23' AS DATE)) <= 90 THEN '61-90 days'
        ELSE '90+ days'
    END                                                             AS aging_bucket,
    COUNT(*)                                                        AS open_claims,
    SUM(charge_amount - paid_amount)                                AS outstanding_amount
FROM claims
WHERE payment_date IS NULL
GROUP BY
    CASE
        WHEN DATEDIFF(day, billing_date, CAST('2026-10-23' AS DATE)) <= 30 THEN '0-30 days'
        WHEN DATEDIFF(day, billing_date, CAST('2026-10-23' AS DATE)) <= 60 THEN '31-60 days'
        WHEN DATEDIFF(day, billing_date, CAST('2026-10-23' AS DATE)) <= 90 THEN '61-90 days'
        ELSE '90+ days'
    END
ORDER BY MIN(DATEDIFF(day, billing_date, CAST('2026-10-23' AS DATE)));

-- 4.3 Average AR days (days outstanding on unpaid claims)
SELECT
    AVG(DATEDIFF(day, billing_date, CAST('2026-10-23' AS DATE)))    AS avg_ar_days
FROM claims
WHERE payment_date IS NULL;


-- =====================================================================
-- 5. PAYER PERFORMANCE
-- =====================================================================

-- 5.1 Charges, collections, denial rate and collection rate by payer
SELECT
    payer,
    COUNT(*)                                                        AS total_claims,
    SUM(charge_amount)                                              AS total_charges,
    SUM(paid_amount)                                                AS total_paid,
    ROUND(100.0 * SUM(paid_amount) / SUM(charge_amount), 2)         AS collection_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END)
          / COUNT(*), 2)                                            AS denial_rate_pct
FROM claims
GROUP BY payer
ORDER BY denial_rate_pct DESC;

-- 5.2 Monthly billing and collection trend
SELECT
    YEAR(billing_date)                                              AS billing_year,
    MONTH(billing_date)                                             AS billing_month,
    SUM(charge_amount)                                              AS charges,
    SUM(paid_amount)                                                AS collections
FROM claims
GROUP BY YEAR(billing_date), MONTH(billing_date)
ORDER BY billing_year, billing_month;


-- =====================================================================
-- 6. DATA QUALITY CHECKS (each should return zero rows on clean data)
-- =====================================================================

-- 6.1 Duplicate claim IDs
SELECT claim_id, COUNT(*) AS duplicate_count
FROM claims
GROUP BY claim_id
HAVING COUNT(*) > 1;

-- 6.2 Missing key fields
SELECT *
FROM claims
WHERE payer IS NULL
   OR billing_date IS NULL
   OR charge_amount IS NULL
   OR claim_status IS NULL;

-- 6.3 Denied claims without a denial reason
SELECT *
FROM claims
WHERE claim_status = 'Denied'
  AND denial_reason IS NULL;

-- 6.4 Payment date earlier than billing date
SELECT *
FROM claims
WHERE payment_date < billing_date;

-- 6.5 Paid amount greater than charge amount
SELECT *
FROM claims
WHERE paid_amount > charge_amount;
