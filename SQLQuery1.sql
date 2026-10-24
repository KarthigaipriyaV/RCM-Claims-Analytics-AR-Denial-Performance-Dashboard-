USE Healthcare_denial_rate
SELECT TOP 10 *
FROM claims_cleaned;

 1. What is the total number of denied claims?
select count(outcome) from claims_cleaned
where outcome ='denied';

 2.Which denial category occurs most frequently ?
  select denial_category,
   count(*) AS total_denials
from claims_cleaned
where outcome = 'denied'
group by denial_category
order by total_denials desc;


3. Which denial reason code occurs most frequently?
select denial_reason_code,
count(*) as total_denials
from claims_cleaned
where outcome = 'denied'
group by denial_reason_code
order BY total_denials DESC;

4.Which place of service has the highest number of denied claims?
select place_of_service_desc ,count(*) from claims_cleaned
where outcome = 'denied'
group by place_of_service_desc
order by place_of_service_desc desc;

5.Which provider specialty has the most denied claims?
select provider_specialty ,count(*) from claims_cleaned
where outcome = 'denied'
group by provider_specialty
order by provider_specialty desc;

6.Which payer type has the most denied claims?
select payer_type , count(*) from claims_cleaned
where outcome = 'denied'
group by payer_type
order by payer_type desc;


7.How many claims were denied in each year and quarter?
select claim_year,claim_quarter ,count(*) from claims_cleaned
where outcome = 'denied'
group by claim_year , claim_quarter
order by claim_year, claim_quarter;

8.What is the total denied claim amount by year and quarter?
select claim_year,claim_quarter ,sum(claim_amount_usd) from claims_cleaned
where outcome = 'denied'
group by claim_year ,claim_quarter
order by claim_year , claim_quarter ;

9.Among denied claims, how many had prior authorization obtained versus not obtained?
select
    prior_auth_obtained,
     count(*) AS denied_claims
from claims_cleaned
where outcome = 'Denied'
group by prior_auth_obtained;



