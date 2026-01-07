Core claims leakage validation logic
Conservative, rule-based indicators

CREATE OR REPLACE VIEW claim_policy_parsed AS
SELECT
    *,
    CAST(SPLIT_PART(policy_csl, '/', 2) AS INTEGER) * 1000
        AS policy_csl_limit
FROM insurance_claims;


CREATE OR REPLACE VIEW claim_validation_flags AS
SELECT
    *,
    CASE
        WHEN total_claim_amount > policy_csl_limit THEN 1
        ELSE 0
    END AS coverage_breach_flag,

    CASE
        WHEN total_claim_amount <>
             (injury_claim + property_claim + vehicle_claim)
        THEN 1 ELSE 0
    END AS component_mismatch_flag,

    CASE
        WHEN incident_severity = 'Minor'
             AND total_claim_amount >
                 (SELECT AVG(total_claim_amount)
                  FROM insurance_claims)
        THEN 1 ELSE 0
    END AS severity_cost_mismatch_flag
FROM claim_policy_parsed;


CREATE OR REPLACE VIEW claim_leakage AS
SELECT
    *,
    CASE
        WHEN severity_cost_mismatch_flag = 1
        THEN total_claim_amount -
             (SELECT AVG(total_claim_amount)
              FROM insurance_claims)
        ELSE 0
    END AS potential_leakage_amount
FROM claim_validation_flags;


SELECT
    COUNT(*) AS total_claims,
    SUM(total_claim_amount) AS total_claims_paid,
    SUM(potential_leakage_amount) AS total_potential_leakage,
    COUNT(*) FILTER (WHERE coverage_breach_flag = 1)
        AS coverage_indicator_count
FROM claim_leakage;
