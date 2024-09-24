CREATE DATABASE IF NOT EXISTS my_budget_buddy;

    USE my_budget_buddy;

    --- AUTH ---

    DROP SEQUENCE IF EXISTS user_credentials_id_seq CASCADE;

    DROP TABLE IF EXISTS user_credentials CASCADE;

    CREATE TABLE user_credentials (
      id SERIAL,
      username VARCHAR(100),
      user_password VARCHAR,
      oauth2_idp VARCHAR(50),
      user_role VARCHAR(20)
    );

    INSERT INTO user_credentials (username, user_password, user_role)
    VALUES ('joseph.sam@gmail.com', '$2y$10$R.AVbuzy7f7Vijnj94DF1.7aI8C7V4Zwbf2FWAWk2dCRC3n1iOkbG', 'USER');

    INSERT INTO user_credentials (username, user_password, user_role)
    VALUES ('david.melanson@gmail.com', '$2y$10$SfJCRbSkbM.ObOJHvVCRNuxdrY13loabTM8ROaGW1kBCWJHhI/iZ6', 'USER');

    INSERT INTO user_credentials (username, user_password, user_role)
    VALUES ('user03@domain.com', '$2y$10$Snb12fzwuYwQY/5zxZTFDer0UK1.RyAVnzCqVVzcF8sF6OF6pdCAm', 'USER');

    INSERT INTO user_credentials (username, oauth2_idp, user_role)
    VALUES ('user04@gmail.com', 'GOOGLE', 'USER');



    --- USERS ---

    DROP SEQUENCE IF EXISTS users_id_seq CASCADE;

    CREATE SEQUENCE users_id_seq;

    DROP TABLE IF EXISTS users;

    CREATE TABLE IF NOT EXISTS users
    (
        id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
        email character varying(255) COLLATE pg_catalog."default",
        first_name character varying(255) COLLATE pg_catalog."default",
        last_name character varying(255) COLLATE pg_catalog."default",
        CONSTRAINT users_pkey PRIMARY KEY (id)
    );

    INSERT INTO users (email, first_name, last_name)
    VALUES ('joseph.sam@gmail.com', 'Joseph', 'Sam');

    INSERT INTO users (email, first_name, last_name)
    VALUES ('david.melanson@gmail.com', 'David', 'Melanson');

    INSERT INTO users (email, first_name, last_name)
    VALUES ('user03@domain.com', 'User', 'Three');

    INSERT INTO users (email, first_name, last_name)
    VALUES ('user04@domain.com', 'User', 'Four');



    --- BUDGETS ---

    DROP TABLE IF EXISTS monthly_summary;
    DROP TABLE IF EXISTS buckets;
    DROP TABLE IF EXISTS budgets;

    CREATE TABLE budgets (
        budget_id SERIAL PRIMARY KEY,
        user_id INT NOT NULL,
        category VARCHAR(100) NOT NULL,
        total_amount INT,
      is_reserved BOOLEAN DEFAULT FALSE,
      month_year Date,
      notes VARCHAR(255),
        created_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE buckets (
        bucket_id SERIAL PRIMARY KEY,
        user_id INT NOT NULL,
        bucket_name VARCHAR(100) NOT NULL,
        amount_required NUMERIC(10, 2) NOT NULL,
        amount_reserved NUMERIC(10, 2) NOT NULL,
        month_year Date,
      is_reserved BOOLEAN DEFAULT FALSE,
      is_active BOOLEAN DEFAULT FALSE,
        date_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE monthly_summary (
        summary_id SERIAL PRIMARY KEY,
        user_id INT NOT NULL,
        month_year DATE,
        projected_income NUMERIC(10, 2) NOT NULL,
        total_budget_amount NUMERIC(10, 2) NOT NULL
    );

    INSERT INTO budgets (user_id, category, total_amount, is_reserved, month_year, notes) VALUES
    (1, 'Groceries', 150.00, FALSE, '2024-05-01', 'Weekly grocery shopping'),
    (1, 'Rent', 1200.00, TRUE, '2024-05-01', 'May rent payment'),
    (2, 'Utilities', 200.00, FALSE, '2024-05-01', 'Electricity and water bill'),
    (2, 'Internet', 50.00, TRUE, '2024-05-01', 'Monthly internet bill'),
    (3, 'Entertainment', 100.00, FALSE, '2024-05-01', 'Movies and dining out'),
    (3, 'Savings', 500.00, TRUE, '2024-05-01', 'Monthly savings deposit');

    INSERT INTO buckets (user_id, bucket_name, amount_required, amount_reserved, month_year, is_reserved, is_active) VALUES
    (1, 'Vacation Fund', 2000.00, 500.00, '2024-05-01', FALSE, TRUE),
    (1, 'Emergency Fund', 1000.00, 300.00, '2024-05-01', TRUE, TRUE),
    (2, 'Car Maintenance', 500.00, 100.00, '2024-05-01', FALSE, FALSE),
    (2, 'Home Improvement', 1500.00, 750.00, '2024-05-01', TRUE, TRUE),
    (3, 'New Laptop', 1200.00, 600.00, '2024-05-01', FALSE, TRUE),
    (3, 'Health Insurance', 800.00, 400.00, '2024-05-01', TRUE, FALSE);

    INSERT INTO monthly_summary (user_id, month_year, projected_income, total_budget_amount) VALUES
    (1, '2024-05-01', 7777.00, 1111.00),
    (2, '2024-05-01', 9999.00, 3333.00),
    (3, '2024-05-01', 9876.00, 999.00);



    --- TAX ---

    DROP TABLE IF EXISTS tax_brackets CASCADE;
    DROP TABLE IF EXISTS standard_deduction CASCADE;
    DROP TABLE IF EXISTS capital_gains_tax;
    DROP TABLE IF EXISTS filing_status CASCADE;
    DROP TABLE IF EXISTS child_tax_credit CASCADE;
    DROP TABLE IF EXISTS dependent_care_tax_credit CASCADE;
    DROP TABLE IF EXISTS dependent_care_tax_credit_limit CASCADE;
    DROP TABLE IF EXISTS earned_income_tax_credit CASCADE;
    DROP TABLE IF EXISTS education_tax_credit_aotc CASCADE;
    DROP TABLE IF EXISTS education_tax_credit_llc CASCADE;
    DROP TABLE IF EXISTS savers_tax_credit CASCADE;
    DROP TABLE IF EXISTS state_tax CASCADE;
    DROP TABLE IF EXISTS states CASCADE;
    DROP TABLE IF EXISTS deduction CASCADE;
    DROP TABLE IF EXISTS tax_return CASCADE;
    DROP TABLE IF EXISTS taxreturn_deduction CASCADE;
    DROP TABLE IF EXISTS w2 CASCADE;
    DROP TABLE IF EXISTS other_income CASCADE;
    DROP TABLE IF EXISTS taxreturn_credit CASCADE;


    CREATE TABLE IF NOT EXISTS child_tax_credit (
      id SERIAL PRIMARY KEY,
      per_qualifying_child INT NOT NULL,
      per_other_child INT NOT NULL,
      income_threshold INT NOT NULL,
      rate_factor DECIMAL(5, 2) NOT NULL DEFAULT 0.05,
      refundable BOOLEAN NOT NULL,
      refund_limit INT NOT NULL,
      refund_rate DECIMAL(5, 2) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS dependent_care_tax_credit (
      id SERIAL PRIMARY KEY,
      income_range INT NOT NULL,
      rate DECIMAL(5, 2) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS dependent_care_tax_credit_limit (
      id SERIAL PRIMARY KEY,
      num_dependents INT NOT NULL,
      credit_limit INT NOT NULL,
      refundable BOOLEAN NOT NULL
    );

    CREATE TABLE IF NOT EXISTS earned_income_tax_credit (
      id SERIAL PRIMARY KEY,
      agi_threshold_3children INT NOT NULL,
      agi_threshold_2Children INT NOT NULL,
      agi_threshold_1Children INT NOT NULL,
      agi_threshold_0Children INT NOT NULL,
      amount_3children INT NOT NULL,
      amount_2children INT NOT NULL,
      amount_1children INT NOT NULL,
      amount_0children INT NOT NULL,
      investment_income_limit INT NOT NULL,
      refundable BOOLEAN NOT NULL,
      refund_limit INT NOT NULL,
      refund_rate DECIMAL(5, 2)
    );

    CREATE TABLE IF NOT EXISTS education_tax_credit_aotc (
      id SERIAL PRIMARY KEY,
      full_credit_income_threshold INT NOT NULL,
      partial_credit_income_threshold INT NOT NULL,
      income_partial_credit_rate DECIMAL(5, 2) NOT NULL,
      max_credit_amount INT NOT NULL,
      full_credit_expenses_threshold INT NOT NULL,
      partial_credit_expenses_threshold INT NOT NULL,
      partial_credit_expenses_rate DECIMAL(5,2) NOT NULL,
      refundable BOOLEAN NOT NULL,
      refund_limit INT NOT NULL,
      refund_rate DECIMAL(5, 2)
    );

    CREATE TABLE IF NOT EXISTS education_tax_credit_llc (
      id SERIAL PRIMARY KEY,
      full_credit_income_threshold INT NOT NULL,
      partial_credit_income_threshold INT NOT NULL,
      income_partial_credit_rate DECIMAL(5, 2) NOT NULL,
      max_credit_amount INT NOT NULL,
      expenses_threshold INT NOT NULL,
      credit_rate DECIMAL(5, 2) NOT NULL,
      refundable BOOLEAN NOT NULL
    );

    CREATE TABLE IF NOT EXISTS savers_tax_credit (
      id SERIAL PRIMARY KEY,
      agi_threshold_first_contribution_limit INT NOT NULL,
      agi_threshold_second_contribution_limit INT NOT NULL,
      agi_threshold_third_contribution_limit INT NOT NULL,
      first_contribution_rate DECIMAL(5, 2) NOT NULL,
      second_contribution_rate DECIMAL(5, 2) NOT NULL,
      third_contribution_rate DECIMAL(5, 2) NOT NULL,
      max_contribution_amount INT NOT NULL,
      refundable BOOLEAN NOT NULL
    );

    CREATE TABLE IF NOT EXISTS filing_status (
      id SERIAL PRIMARY KEY,
      status VARCHAR(50) NOT NULL UNIQUE,
      child_tax_credit_id INT NOT NULL,
      earned_income_tax_credit_id INT NOT NULL,
      education_tax_credit_aotc_id INT NOT NULL,
      education_tax_credit_llc_id INT NOT NULL,
      savers_tax_credit_id INT NOT NULL,
      FOREIGN KEY (child_tax_credit_id) REFERENCES child_tax_credit(id),
      FOREIGN KEY (earned_income_tax_credit_id) REFERENCES earned_income_tax_credit(id),
      FOREIGN KEY (education_tax_credit_aotc_id) REFERENCES education_tax_credit_aotc(id),
      FOREIGN KEY (education_tax_credit_llc_id) REFERENCES education_tax_credit_llc(id),
      FOREIGN KEY (savers_tax_credit_id) REFERENCES savers_tax_credit(id)
    );

    CREATE TABLE IF NOT EXISTS standard_deduction (
      id SERIAL PRIMARY KEY,
      filing_status_id INT NOT NULL,
      deduction_amount INT NOT NULL,
      FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
    );

    CREATE TABLE IF NOT EXISTS capital_gains_tax (
      id SERIAL PRIMARY KEY,
      filing_status_id INT NOT NULL,
      rate DECIMAL(5, 2) NOT NULL,
      income_range INT NOT NULL,
      FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
    );

    CREATE TABLE IF NOT EXISTS tax_brackets (
      id SERIAL PRIMARY KEY,
      filing_status_id INT NOT NULL,
      rate DECIMAL(5, 2) NOT NULL,
      min_income INT NOT NULL,
      max_income INT NOT NULL,
      FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
    );

    CREATE TABLE IF NOT EXISTS states (
      id SERIAL PRIMARY KEY,
      state_name VARCHAR(50),
      state_code VARCHAR(2)
    );

    CREATE TABLE IF NOT EXISTS state_tax (
      id SERIAL PRIMARY KEY,
      state_id INT NOT NULL,
      income_range INT NOT NULL,
      rate DECIMAL(6, 5) NOT NULL,
      FOREIGN KEY (state_id) REFERENCES states(id)
    );

    CREATE TABLE IF NOT EXISTS deduction (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50),
        agi_limit DECIMAL(10, 3),
        itemized BOOLEAN
    );

    CREATE TABLE IF NOT EXISTS tax_return (
        id SERIAL PRIMARY KEY,
        years INT,
        filing_status INT,
        user_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        email VARCHAR(50),
        phone_number VARCHAR(20),
        address VARCHAR(50),
        city VARCHAR(50),
        state VARCHAR(2),
        zip VARCHAR(10),
        date_of_birth DATE,
        ssn VARCHAR(11),
        total_income NUMERIC,
        adjusted_gross_income NUMERIC,
        taxable_income NUMERIC,
        fed_tax_withheld NUMERIC,
        state_tax_withheld NUMERIC,
        social_security_tax_withheld NUMERIC,
        medicare_tax_withheld NUMERIC,
        total_credits NUMERIC,
        federal_refund NUMERIC,
        state_refund NUMERIC,
        CONSTRAINT unique_year_user_id UNIQUE (years, user_id)
    );

    CREATE TABLE IF NOT EXISTS taxreturn_deduction (
        id SERIAL PRIMARY KEY,
        taxreturn_id INT,
        deduction_id INT,
        amount_spent NUMERIC,
        CONSTRAINT fk_taxreturn FOREIGN KEY (taxreturn_id) REFERENCES tax_return(id),
        CONSTRAINT fk_deduction FOREIGN KEY (deduction_id) REFERENCES deduction(id),
        CONSTRAINT unique_taxreturn_deduction UNIQUE (taxreturn_id, deduction_id)
    );

    CREATE TABLE IF NOT EXISTS w2 (
        id SERIAL PRIMARY KEY,
        tax_return_id INT,
        years INT,
        user_id INT,
        employer VARCHAR(50),
        wages NUMERIC DEFAULT 0,
        state INT,
        federal_income_tax_withheld NUMERIC,
        state_income_tax_withheld NUMERIC,
        social_security_tax_withheld NUMERIC,
        medicare_tax_withheld NUMERIC,
        image_key VARCHAR(50),
        CONSTRAINT fk_tax_return FOREIGN KEY (tax_return_id) REFERENCES tax_return(id)
    );

    CREATE TABLE IF NOT EXISTS other_income (
      id SERIAL PRIMARY KEY,
      tax_return_id INT NOT NULL,
      long_term_capital_gains DECIMAL,
      short_term_capital_gains DECIMAL,
      other_investment_income DECIMAL,
      net_business_income DECIMAL,
      additional_income DECIMAL,
      FOREIGN KEY (tax_return_id) REFERENCES tax_return(id)
    );

    CREATE TABLE IF NOT EXISTS taxreturn_credit (
      id SERIAL PRIMARY KEY,
      tax_return_id INT NOT NULL,
      num_dependents INT,
      num_dependents_aotc INT,
      num_dependents_under_13 INT,
      child_care_expenses DECIMAL,
      education_expenses DECIMAL,
      llc_education_expenses DECIMAL,
      ira_contributions DECIMAL,
      claimed_as_dependent BOOLEAN,
      llc_credit BOOLEAN,
      FOREIGN KEY (tax_return_id) REFERENCES tax_return(id)
    );

    BEGIN;
    -- marries filing jointly
    INSERT INTO child_tax_credit (per_qualifying_child, per_other_child, income_threshold, rate_factor, refundable, refund_limit, refund_rate) VALUES (2000, 500, 400000, 0.05, TRUE, 1600, 1.00);
    -- other filing statuses
    INSERT INTO child_tax_credit (per_qualifying_child, per_other_child, income_threshold, rate_factor, refundable, refund_limit, refund_rate) VALUES (2000, 500, 200000, 0.05, TRUE, 1600, 1.00);

    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (15000, 0.35);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.34);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.33);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.32);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.31);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.30);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.29);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.28);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.27);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.26);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.25);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.24);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.23);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.22);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (2000, 0.21);
    INSERT INTO dependent_care_tax_credit (income_range, rate) VALUES (0, 0.20);

    INSERT INTO dependent_care_tax_credit_limit (num_dependents, credit_limit, refundable) VALUES (1, 3000, FALSE);
    INSERT INTO dependent_care_tax_credit_limit (num_dependents, credit_limit, refundable) VALUES (2, 6000, FALSE);

    -- married filing jointly
    INSERT INTO earned_income_tax_credit (agi_threshold_3children, 
                                          agi_threshold_2Children, 
                                          agi_threshold_1Children, 
                                          agi_threshold_0Children, 
                                          amount_3children, 
                                          amount_2children, 
                                          amount_1children, 
                                          amount_0children,
                                          investment_income_limit,
                                          refundable,
                                          refund_limit,
                                          refund_rate)
                                          VALUES (63398, 59478, 53120, 24210, 7430, 6604, 3995, 600, 11000, TRUE, 0, 1.00);
    -- other filing statuses
    INSERT INTO earned_income_tax_credit (agi_threshold_3children, 
                                          agi_threshold_2Children, 
                                          agi_threshold_1Children, 
                                          agi_threshold_0Children, 
                                          amount_3children, 
                                          amount_2children, 
                                          amount_1children, 
                                          amount_0children,
                                          investment_income_limit,
                                          refundable,
                                          refund_limit,
                                          refund_rate)
                                          VALUES (56838, 52918, 46560, 17640, 7430, 6604, 3995, 600, 11000, TRUE, 0, 1.00);

    -- married filing jointly
    INSERT INTO education_tax_credit_aotc (full_credit_income_threshold, 
                                          partial_credit_income_threshold,
                                          income_partial_credit_rate,
                                          max_credit_amount,
                                          full_credit_expenses_threshold,
                                          partial_credit_expenses_threshold,
                                          partial_credit_expenses_rate,
                                          refundable,
                                          refund_limit,
                                          refund_rate)
                                          VALUES (160000, 20000, 0.75, 2500, 2000, 2000, 0.40, TRUE, 1000, 0.4);
    -- other filing statuses
    INSERT INTO education_tax_credit_aotc (full_credit_income_threshold, 
                                          partial_credit_income_threshold,
                                          income_partial_credit_rate,
                                          max_credit_amount,
                                          full_credit_expenses_threshold,
                                          partial_credit_expenses_threshold,
                                          partial_credit_expenses_rate,
                                          refundable,
                                          refund_limit,
                                          refund_rate)
                                          VALUES (80000, 10000, 0.75, 2500, 2000, 2000, 0.40, TRUE, 1000, 0.4);

    -- married filing jointly
    INSERT INTO education_tax_credit_llc (full_credit_income_threshold, 
                                          partial_credit_income_threshold,
                                          income_partial_credit_rate,
                                          max_credit_amount,
                                          expenses_threshold,
                                          credit_rate,
                                          refundable)
                                          VALUES (160000,20000, 0.75, 2000, 10000, 0.20, FALSE);
    -- other filing statuses
    INSERT INTO education_tax_credit_llc (full_credit_income_threshold, 
                                          partial_credit_income_threshold,
                                          income_partial_credit_rate,
                                          max_credit_amount,
                                          expenses_threshold,
                                          credit_rate,
                                          refundable)
                                          VALUES (80000, 20000, 0.75, 2000, 10000, 0.20, FALSE);

    -- marries filing jointly
    INSERT INTO savers_tax_credit (agi_threshold_first_contribution_limit,
                                  agi_threshold_second_contribution_limit,
                                  agi_threshold_third_contribution_limit,
                                  first_contribution_rate,
                                  second_contribution_rate,
                                  third_contribution_rate,
                                  max_contribution_amount,
                                  refundable)
                                  VALUES (43500, 3999, 25499, 0.5, 0.2, 0.1, 2000, FALSE);
    -- head of household
    INSERT INTO savers_tax_credit (agi_threshold_first_contribution_limit,
                                  agi_threshold_second_contribution_limit,
                                  agi_threshold_third_contribution_limit,
                                  first_contribution_rate,
                                  second_contribution_rate,
                                  third_contribution_rate,
                                  max_contribution_amount,
                                  refundable)
                                  VALUES (32625, 2999, 19124, 0.5, 0.2, 0.1, 2000, FALSE);
    -- other filing statuses
    INSERT INTO savers_tax_credit (agi_threshold_first_contribution_limit,
                                  agi_threshold_second_contribution_limit,
                                  agi_threshold_third_contribution_limit,
                                  first_contribution_rate,
                                  second_contribution_rate,
                                  third_contribution_rate,
                                  max_contribution_amount,
                                  refundable)
                                  VALUES (21750, 1999, 12749, 0.5, 0.2, 0.1, 2000, FALSE);
    COMMIT;


    BEGIN;
    INSERT INTO filing_status (status, 
                              child_tax_credit_id, 
                              earned_income_tax_credit_id, 
                              education_tax_credit_aotc_id, 
                              education_tax_credit_llc_id, 
                              savers_tax_credit_id) 
                              VALUES ('Single', 2, 2, 2, 2, 3);
    INSERT INTO filing_status (status,
                              child_tax_credit_id,
                              earned_income_tax_credit_id,
                              education_tax_credit_aotc_id,
                              education_tax_credit_llc_id,
                              savers_tax_credit_id) 
                              VALUES ('Married filing jointly', 1, 1, 1, 1, 1);
    INSERT INTO filing_status (status,
                              child_tax_credit_id,
                              earned_income_tax_credit_id,
                              education_tax_credit_aotc_id,
                              education_tax_credit_llc_id,
                              savers_tax_credit_id) 
                              VALUES ('Married filing separately', 2, 2, 2, 2, 3);
    INSERT INTO filing_status (status,
                              child_tax_credit_id,
                              earned_income_tax_credit_id,
                              education_tax_credit_aotc_id,
                              education_tax_credit_llc_id,
                              savers_tax_credit_id) 
                              VALUES ('Head of Household', 2, 2, 2, 2, 2);
    INSERT INTO filing_status (status,
                              child_tax_credit_id,
                              earned_income_tax_credit_id,
                              education_tax_credit_aotc_id,
                              education_tax_credit_llc_id,
                              savers_tax_credit_id) 
                              VALUES ('Qualifying Surviving Spouse', 2, 2, 2, 2, 3);
    COMMIT;

    BEGIN;
    -- Single
    INSERT INTO standard_deduction (filing_status_id, deduction_amount) VALUES (1, 12950);
    -- Married filing jointly
    INSERT INTO standard_deduction (filing_status_id, deduction_amount) VALUES (2, 25900);
    -- Marries filing separately
    INSERT INTO standard_deduction (filing_status_id, deduction_amount) VALUES (3, 12950);
    -- Head of household
    INSERT INTO standard_deduction (filing_status_id, deduction_amount) VALUES (4, 19400);
    -- Qualifying surviving spouse
    INSERT INTO standard_deduction (filing_status_id, deduction_amount) VALUES (5, 25900);
    COMMIT;


    BEGIN;
    -- Single
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (1, 0.0, 47025);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (1, 0.15, 471874);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (1, 0.2, 0);
    -- Married filing jointly
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (2, 0.0, 94050);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (2, 0.15, 489699);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (2, 0.2, 0);
    -- Marries filing separately
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (3, 0.0, 47025);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (3, 0.15, 244824);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (3, 0.2, 0);
    -- Head of household
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (4, 0.0, 63000);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (4, 0.15, 488349);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (4, 0.2, 0);
    -- Qualifying surviving spouse
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (5, 0.0, 94050);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (5, 0.15, 489699);
    INSERT INTO capital_gains_tax (filing_status_id, rate, income_range) VALUES (5, 0.2, 0);
    COMMIT;


    BEGIN;
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.10, 0, 11000, 1);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.12, 11001, 44725, 1);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.22, 44726, 95375, 1);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.24, 95376, 182100, 1);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.32, 182101, 231250, 1);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.35, 231251, 578125, 1);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.37, 578126, 2147483647, 1);

    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.10, 0, 22000, 2);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.12, 22001, 89450, 2);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.22, 89451, 190750, 2);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.24, 190751, 364200, 2);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.32, 364201, 462500, 2);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.35, 462501, 693750, 2);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.37, 693751, 2147483647, 2);

    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.10, 0, 11000, 3);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.12, 11001, 44725, 3);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.22, 44726, 95375, 3);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.24, 95376, 182100, 3);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.32, 182101, 231250, 3);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.35, 231251, 346875, 3);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.37, 346876, 2147483647, 3);

    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.10, 0, 15700, 4);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.12, 15701, 59850, 4);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.22, 59851, 95350, 4);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.24, 95351, 182100, 4);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.32, 182101, 231250, 4);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.35, 231251, 578100, 4);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.37, 578101, 2147483647, 4);

    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.10, 0, 22000, 5);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.12, 22001, 89450, 5);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.22, 89451, 190750, 5);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.24, 190751, 364200, 5);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.32, 364201, 462500, 5);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.35, 462501, 693750, 5);
    INSERT INTO tax_brackets (rate, min_income, max_income, filing_status_id) VALUES (0.37, 693751, 2147483647, 5);
    COMMIT;


    BEGIN;
    INSERT INTO states (state_code, state_name) VALUES
    -- 1
    ('AL', 'Alabama'),
    -- 2
    ('AK', 'Alaska'),
    -- 3
    ('AZ', 'Arizona'),
    -- 4
    ('AR', 'Arkansas'),
    -- 5
    ('CA', 'California'),
    -- 6
    ('CO', 'Colorado'),
    -- 7
    ('CT', 'Connecticut'),
    -- 8
    ('DE', 'Delaware'),
    -- 9
    ('FL', 'Florida'),
    -- 10
    ('GA', 'Georgia'),
    -- 11
    ('HI', 'Hawaii'),
    -- 12
    ('ID', 'Idaho'),
    -- 13
    ('IL', 'Illinois'),
    -- 14
    ('IN', 'Indiana'),
    -- 15
    ('IA', 'Iowa'),
    -- 16
    ('KS', 'Kansas'),
    -- 17
    ('KY', 'Kentucky'),
    -- 18
    ('LA', 'Louisiana'),
    -- 19
    ('ME', 'Maine'),
    -- 20
    ('MD', 'Maryland'),
    -- 21
    ('MA', 'Massachusetts'),
    -- 22
    ('MI', 'Michigan'),
    -- 23
    ('MN', 'Minnesota'),
    -- 24
    ('MS', 'Mississippi'),
    -- 25
    ('MO', 'Missouri'),
    -- 26
    ('MT', 'Montana'),
    -- 27
    ('NE', 'Nebraska'),
    -- 28
    ('NV', 'Nevada'),
    -- 29
    ('NH', 'New Hampshire'),
    -- 30
    ('NJ', 'New Jersey'),
    -- 31
    ('NM', 'New Mexico'),
    -- 32
    ('NY', 'New York'),
    -- 33
    ('NC', 'North Carolina'),
    -- 34
    ('ND', 'North Dakota'),
    -- 35
    ('OH', 'Ohio'),
    -- 36
    ('OK', 'Oklahoma'),
    -- 36
    ('OR', 'Oregon'),
    -- 38
    ('PA', 'Pennsylvania'),
    -- 39
    ('RI', 'Rhode Island'),
    -- 40
    ('SC', 'South Carolina'),
    -- 41
    ('SD', 'South Dakota'),
    -- 42
    ('TN', 'Tennessee'),
    -- 43
    ('TX', 'Texas'),
    -- 44
    ('UT', 'Utah'),
    -- 45
    ('VT', 'Vermont'),
    -- 46
    ('VA', 'Virginia'),
    -- 47
    ('WA', 'Washington'),
    -- 48
    ('WV', 'West Virginia'),
    -- 49
    ('WI', 'Wisconsin'),
    -- 50
    ('WY', 'Wyoming');
    COMMIT;


    BEGIN;
    -- Alabama
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (1, 0.02, 500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (1, 0.04, 2500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (1, 0.05, 0);
    -- Alaska
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (2, 0.00, 0);
    -- Arizona
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (3, 0.025, 0);
    -- Arkansas
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (4, 0.02, 4400);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (4, 0.04, 4400);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (4, 0.044, 0);
    -- California
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.01, 10412);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.02, 14272);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.04, 14275);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.06, 15122);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.08, 14269);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.093, 280787);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.103, 69824);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.113, 279310);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.123, 301729);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (5, 0.133, 0);
    -- Colorado
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (6, 0.044, 0);
    -- Connecticut
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (7, 0.02, 10000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (7, 0.045, 40000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (7, 0.055, 50000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (7, 0.06, 100000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (7, 0.065, 50000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (7, 0.069, 250000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (7, 0.0699, 0);
    -- Delaware
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (8, 0.022, 5000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (8, 0.039, 5000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (8, 0.048, 10000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (8, 0.052, 5000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (8, 0.0555, 35000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (8, 0.066, 0);
    -- Florida
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (9, 0.0, 0);
    -- Georgia
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (10, 0.0549, 0);
    -- Hawaii
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.014, 2400);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.032, 2400);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.055, 4800);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.064, 4800);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.068, 4800);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.072, 4800);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.076, 12000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.079, 12000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.0825, 102000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.09, 25000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.1, 25000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (11, 0.11, 0);
    -- Idaho
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (12, 0.058, 0);
    -- Illinois
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (13, 0.0495, 0);
    -- Indiana
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (14, 0.0305, 0);
    -- Iowa
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (15, 0.00, 6210);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (15, 0.00, 24840);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (15, 0.00, 0);
    -- Kansas
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (16, 0.031, 15000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (16, 0.0525, 15000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (16, 0.057, 0);
    -- Kentucky
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (17, 0.04, 0);
    -- Louisiana
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (18, 0.0185, 12500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (18, 0.035, 37500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (18, 0.0425, 0);
    -- Maine
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (19, 0.058, 26050);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (19, 0.0675, 35550);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (19, 0.0715, 0);
    -- Maryland
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (20, 0.02, 1000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (20, 0.03, 1000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (20, 0.04, 1000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (20, 0.0475, 97000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (20, 0.05, 25000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (20, 0.0525, 25000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (20, 0.055, 100000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (20, 0.0575, 0);
    -- Massachusetts
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (21, 0.05, 1000000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (21, 0.09, 0);
    -- Michigan
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (22, 0.0425, 0);
    -- Minnesota
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (23, 0.0535, 31690);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (23, 0.068, 72400);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (23, 0.0785, 89150);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (23, 0.0985, 0);
    -- Mississippi
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (24, 0.047, 0);
    -- Missouri
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (25, 0.02, 2546);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (25, 0.025, 1273);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (25, 0.03, 1273);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (25, 0.035, 1273);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (25, 0.04, 1273);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (25, 0.045, 1273);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (25, 0.048, 0);
    -- Montana
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (26, 0.047, 20500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (26, 0.059, 0);
    -- Nebraska
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (27, 0.0246, 3700);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (27, 0.0351, 18470);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (27, 0.0501, 13560);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (27, 0.0584, 0);
    -- Nevada
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (28, 0.00, 0);
    -- New Hampshire
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (29, 0.00, 0);
    -- New Jersey
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (30, 0.014, 20000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (30, 0.0175, 15000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (30, 0.035, 5000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (30, 0.05525, 35000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (30, 0.0637, 425000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (30, 0.0897, 500000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (30, 0.1075, 0);
    -- New Mexico
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (31, 0.017, 5500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (31, 0.032, 4500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (31, 0.047, 5000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (31, 0.049, 194000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (31, 0.059, 0);
    -- New York
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.04, 8500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.045, 3200);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.0525, 2200);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.055, 66750);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.06, 134750);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.0685, 862150);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.0965, 3922450);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.103, 20000000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (32, 0.109, 0);
    -- North Carolina
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (33, 0.045, 0);
    -- North Dakota
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (34, 0.0195, 225975);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (34, 0.025, 0);
    -- Ohio
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (35, 0.025, 92150);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (35, 0.035, 0);
    -- Oklahoma
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (36, 0.0025, 1000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (36, 0.0075, 1500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (36, 0.0175, 1250);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (36, 0.0275, 1150);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (36, 0.0375, 2300);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (36, 0.0475, 0);
    -- Oregon
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (37, 0.0475, 4300);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (37, 0.0675, 6450);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (37, 0.0875, 114250);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (37, 0.099, 0);
    -- Pennsylvania
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (38, 0.0307, 0);
    -- Rhode Island
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (39, 0.0375, 77450);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (39, 0.0475, 98600);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (39, 0.0599, 0);
    -- South Carolina
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (40, 0.00, 3460);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (40, 0.03, 13870);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (40, 0.00, 0);
    -- South Dakota
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (41, 0.00, 0);
    -- Tennessee
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (42, 0.00, 0);
    -- Texas
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (43, 0.00, 0);
    -- Utah
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (44, 0.0465, 0);
    -- Vermont
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (45, 0.0335, 45400);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (45, 0.066, 64650);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (45, 0.076, 119500);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (45, 0.0875, 0);
    -- Virginia
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (46, 0.02, 3000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (46, 0.03, 2000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (46, 0.05, 12000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (46, 0.0575, 0);
    -- Washington
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (47, 0.00, 0);
    -- West Virginia
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (48, 0.0236, 10000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (48, 0.0315, 15000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (48, 0.0354, 15000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (48, 0.0472, 20000);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (48, 0.0512, 0);
    -- Wisconsin
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (49, 0.035, 14320);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (49, 0.044, 14320);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (49, 0.053, 286670);
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (49, 0.0765, 0);
    -- Wyoming
    INSERT INTO state_tax (state_id, rate, income_range) VALUES (50, 0.00, 0);
    COMMIT;

    BEGIN;
    -- Non-itemized deductions
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('Health Savings Account', 3850.000, false);
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('IRA Contributions', 6500.000, false);
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('Student Loan Interest', 90000.000, false);
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('Educator Expenses', 300.000, false);

    -- Itemized deductions
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('Medical Expenses', 0.075, true);
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('State and Local Taxes', 1.000, true);
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('Mortgage Interest', 1.000, true);
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('Charitable Contributions', 0.600, true);
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('Casualty Losses', 0.100, true);
    INSERT INTO deduction (name, agi_limit, itemized) VALUES ('Miscellaneous Deductions', 1.000, true);
    COMMIT;



    --- TRANSACTIONS ---

    DROP TABLE IF EXISTS transaction;

    CREATE TABLE transaction (
        transaction_id SERIAL PRIMARY KEY,
        user_id INT NOT NULL,
        account_id INT NOT NULL,
        vendor_name VARCHAR(100) NOT NULL,
        transaction_date DATE NOT NULL,
        transaction_amount DECIMAL(10, 2) NOT NULL,
        transaction_description VARCHAR(500),
        transaction_category VARCHAR(50) NOT NULL
    );

    INSERT INTO transaction (user_id, account_id, vendor_name, transaction_date, transaction_amount, transaction_description, transaction_category) VALUES
    (1, 1, 'Amazon', '2024-01-15', 59.99, 'Purchase of electronics', 'SHOPPING'),
    (1, 2, 'Starbucks', '2024-01-16', 4.75, 'Coffee and snacks', 'DINING'),
    (1, 1, 'Walmart', '2024-01-17', 120.00, 'Grocery shopping', 'GROCERIES'),
    (1, 3, 'Apple Store', '2024-01-18', 999.99, 'New iPhone purchase', 'SHOPPING'),
    (1, 3, 'Netflix', '2024-01-19', 15.99, 'Monthly subscription', 'ENTERTAINMENT'),
    (1, 3, 'Shell', '2024-01-20', 45.50, 'Gas for car', 'TRANSPORTATION'),
    (1, 1, 'Costco', '2024-01-21', 200.00, 'Bulk shopping', 'GROCERIES'),
    (1, 2, 'Uber', '2024-01-22', 25.00, 'Ride to airport', 'TRANSPORTATION'),
    (1, 3, 'Spotify', '2024-01-23', 9.99, 'Monthly subscription', 'ENTERTAINMENT'),
    (1, 1, 'Best Buy', '2024-01-24', 499.99, 'Laptop purchase', 'SHOPPING'),
    (1, 2, 'Skillstorm', '2024-01-10', 2010.45, 'Paycheck', 'INCOME'),
    (1, 2, 'Whole Foods', '2024-05-29', 75.34, 'Organic groceries', 'GROCERIES'),
    (1, 1, 'Home Depot', '2024-05-28', 120.50, 'Home improvement tools', 'LIVING_EXPENSES'),
    (1, 3, 'Lyft', '2024-05-27', 30.00, 'Ride to downtown', 'TRANSPORTATION'),
    (1, 2, 'Target', '2024-05-26', 150.00, 'Clothing and household items', 'SHOPPING'),
    (1, 1, 'Walgreens', '2024-05-25', 25.99, 'Pharmacy and essentials', 'HEALTHCARE'),
    (1, 2, 'Airbnb', '2024-02-25', 250.00, 'Weekend getaway', 'ENTERTAINMENT'),
    (1, 1, 'Chipotle', '2024-03-01', 12.75, 'Lunch', 'DINING'),
    (1, 1, 'Microsoft Store', '2024-03-05', 150.00, 'Office software', 'SHOPPING'),
    (1, 1, 'BP', '2024-03-10', 48.50, 'Gas for car', 'TRANSPORTATION'),
    (1, 1, 'Costco', '2024-03-15', 220.00, 'Bulk groceries', 'GROCERIES'),
    (1, 3, 'Hulu', '2024-03-20', 11.99, 'Monthly subscription', 'ENTERTAINMENT'),
    (1, 2, 'Pandora', '2024-03-25', 4.99, 'Monthly subscription', 'ENTERTAINMENT'),
    (1, 1, 'Publix', '2024-05-30', 80.00, 'Groceries and snacks', 'GROCERIES'),
    (1, 2, 'REI', '2024-05-24', 200.00, 'Outdoor gear', 'SHOPPING'),
    (1, 2, 'DHL', '2024-05-30', 50.00, 'Package delivery', 'MISC'),
    (1, 1, 'Costco', '2024-03-15', 100.00, 'Bulk groceries', 'GROCERIES'),
    (1, 1, 'Costco', '2024-03-15', 50.00, 'Bulk groceries', 'GROCERIES'),
    (1, 2, 'Costco', '2024-03-15', 425.00, 'Bulk groceries', 'GROCERIES'),
    (1, 1, 'Costco', '2024-03-15', 267.10, 'Bulk groceries', 'GROCERIES'),
    (1, 3, 'Costco', '2024-03-15', 89.10, 'Bulk groceries', 'GROCERIES');



    --- ACCOUNTS ---

    DROP SEQUENCE IF EXISTS accounts_id_seq CASCADE;

    CREATE SEQUENCE accounts_id_seq;

    DROP TABLE IF EXISTS accounts;

    CREATE TABLE IF NOT EXISTS accounts
    (
        id integer NOT NULL DEFAULT nextval('accounts_id_seq'::regclass),
        account_number character varying(255) COLLATE pg_catalog."default",
        institution character varying(255) COLLATE pg_catalog."default",
        investment_rate numeric(38,2),
        routing_number character varying(255) COLLATE pg_catalog."default",
        starting_balance numeric(38,2),
        _type character varying(255) COLLATE pg_catalog."default",
        user_id character varying(255) COLLATE pg_catalog."default",
        CONSTRAINT accounts_pkey PRIMARY KEY (id),
        CONSTRAINT accounts__type_check CHECK (_type::text = ANY (ARRAY['CHECKING'::character varying, 'SAVINGS'::character varying, 'CREDIT'::character varying, 'INVESTMENT'::character varying]::text[]))
    );

    INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
    VALUES 
    ('123456789', 'Bank of Skillstorm - Checking', NULL, '111000025', 1500.00, 'CHECKING', '1'),
    ('987654321', 'Unity Financial - Checking', NULL, '111000026', 2000.00, 'CHECKING', '1'),
    ('112233445', 'Heritage Bank', NULL, '111000027', 1200.00, 'CHECKING', '1');

    INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
    VALUES 
    ('223344556', 'Bank of Skillstorm - Savings', NULL, '222000025', 3000.00, 'SAVINGS', '1'),
    ('667788990', 'Unity Financial - Savings', NULL, '222000026', 2500.00, 'SAVINGS', '1');

    INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
    VALUES 
    ('445566778', 'Ascend Financial Group', NULL, '333000025', 500.00, 'CREDIT', '1'),
    ('998877665', 'Keystone Bank', NULL, '333000026', 800.00, 'CREDIT', '1');

    INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
    VALUES 
    ('554433221', 'Horizon Wealth Management', 5.00, '444000025', 10000.00, 'INVESTMENT', '1'),
    ('776655443', 'Prestige Investment Group', 4.50, '444000026', 8000.00, 'INVESTMENT', '1');

    INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
    VALUES 
    ('112233446', 'Heritage Bank', NULL, '111000027', 1200.00, 'CHECKING', '2');