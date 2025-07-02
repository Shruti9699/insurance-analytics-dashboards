-- 1. Cross Sell Target Achieve 
CREATE VIEW cross_sell_target_achieve_new AS
SELECT 
    `individual budgets`.`Account Exe ID` AS exec_id,
    `individual budgets`.`Cross sell bugdet` AS Target,
    (
        IFNULL((
            SELECT SUM(`brokerage`.`Amount`)
            FROM `brokerage`
            WHERE 
                `brokerage`.`income_class` = 'Cross Sell'
                AND `brokerage`.`Account Exe ID` = `individual budgets`.`Account Exe ID`
        ), 0)
        +
        IFNULL((
            SELECT SUM(`fees`.`Amount`)
            FROM `fees`
            WHERE 
                `fees`.`income_class` = 'Cross Sell'
                AND `fees`.`Account Exe ID` = `individual budgets`.`Account Exe ID`
        ), 0)
    ) AS Achieve
FROM 
    `individual budgets`;
    
-- 2. Kpi Invoice Count
CREATE VIEW kpi_invoice_count AS
SELECT 
    `invoice`.`Account Executive` AS Account_Executive,
    COUNT(0) AS invoice_count
FROM 
    `invoice`
GROUP BY 
    `invoice`.`Account Executive`;

-- 3. New Target Achieve New 
CREATE VIEW new_target_achieve_new AS
SELECT 
    `individual budgets`.`Account Exe ID` AS exec_id,
    `individual budgets`.`New Budget` AS Target,
    (
        IFNULL((
            SELECT SUM(`brokerage`.`Amount`)
            FROM `brokerage`
            WHERE 
                `brokerage`.`income_class` = 'New'
                AND `brokerage`.`Account Exe ID` = `individual budgets`.`Account Exe ID`
        ), 0)
        +
        IFNULL((
            SELECT SUM(`fees`.`Amount`)
            FROM `fees`
            WHERE 
                `fees`.`income_class` = 'New'
                AND `fees`.`Account Exe ID` = `individual budgets`.`Account Exe ID`
        ), 0)
    ) AS Achieve,
    `individual budgets`.`New Role2` AS New
FROM 
    `individual budgets`;

-- 4. No of Meetings By Exec
CREATE VIEW no_of_meetings_by_exec AS
SELECT 
    `meeting`.`Account Exe ID` AS exec_id,
    COUNT(0) AS total_meetings
FROM 
    `meeting`
GROUP BY 
    `meeting`.`Account Exe ID`;
    
-- 5. Percentage of Achievement 
CREATE VIEW percentage_of_achievement AS
SELECT 
    `ib`.`Account Exe ID` AS exec_id,
    `ib`.`New Budget` AS new_budget,
    
    (
        IFNULL((
            SELECT SUM(`brokerage`.`Amount`)
            FROM `brokerage`
            WHERE 
                `brokerage`.`income_class` = 'New'
                AND `brokerage`.`Account Exe ID` = `ib`.`Account Exe ID`
        ), 0)
        +
        IFNULL((
            SELECT SUM(`fees`.`Amount`)
            FROM `fees`
            WHERE 
                `fees`.`income_class` = 'New'
                AND `fees`.`Account Exe ID` = `ib`.`Account Exe ID`
        ), 0)
    ) AS achieved,

    ROUND(
        (
            (
                IFNULL((
                    SELECT SUM(`brokerage`.`Amount`)
                    FROM `brokerage`
                    WHERE 
                        `brokerage`.`income_class` = 'New'
                        AND `brokerage`.`Account Exe ID` = `ib`.`Account Exe ID`
                ), 0)
                +
                IFNULL((
                    SELECT SUM(`fees`.`Amount`)
                    FROM `fees`
                    WHERE 
                        `fees`.`income_class` = 'New'
                        AND `fees`.`Account Exe ID` = `ib`.`Account Exe ID`
                ), 0)
            ) / `ib`.`New Budget`
        ) * 100, 2
    ) AS `% Achievement`

FROM 
    `individual budgets` AS ib;

-- 6. Renewal Target Achieve New
CREATE VIEW renewal_target_achieve_new AS
SELECT 
    `individual budgets`.`Account Exe ID` AS exec_id,
    `individual budgets`.`Renewal Budget` AS Target,
    (
        IFNULL((
            SELECT SUM(`brokerage`.`Amount`)
            FROM `brokerage`
            WHERE 
                `brokerage`.`income_class` = 'Renewal'
                AND `brokerage`.`Account Exe ID` = `individual budgets`.`Account Exe ID`
        ), 0)
        +
        IFNULL((
            SELECT SUM(`fees`.`Amount`)
            FROM `fees`
            WHERE 
                `fees`.`income_class` = 'Renewal'
                AND `fees`.`Account Exe ID` = `individual budgets`.`Account Exe ID`
        ), 0)
    ) AS Achieve
FROM 
    `individual budgets`;
    
-- 7. Stage Funnel By Revenue  
CREATE VIEW stage_funnel_by_revenue AS
SELECT 
    `opportunity`.`stage` AS stage,
    SUM(`opportunity`.`revenue_amount`) AS total_revenue
FROM 
    `opportunity`
GROUP BY 
    `opportunity`.`stage`;
    
-- 8. Top 10 Open Opportunity
CREATE VIEW top_10_open_opportunities AS
SELECT 
    `opportunity`.`Account Exe Id` AS exec_id,
    `opportunity`.`revenue_amount` AS revenue_amount,
    `opportunity`.`specialty` AS specialty
FROM 
    `opportunity`
WHERE 
    `opportunity`.`stage` = 'Qualify Opportunity'
ORDER BY 
    `opportunity`.`revenue_amount` DESC
LIMIT 10;

-- 9. Yearly Meeting Count
CREATE VIEW yearly_meeting_count AS
SELECT 
    YEAR(STR_TO_DATE(meeting_date, '%m/%d/%Y')) AS Year,
    COUNT(*) AS global_attendees
FROM 
    meeting
WHERE 
    YEAR(STR_TO_DATE(meeting_date, '%m/%d/%Y')) IN (2019, 2020)
GROUP BY 
    YEAR(STR_TO_DATE(meeting_date, '%m/%d/%Y'));





