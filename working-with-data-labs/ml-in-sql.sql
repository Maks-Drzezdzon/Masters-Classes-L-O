drop table bank;

CREATE TABLE BANK
(
    age NUMBER,
    job_type VARCHAR(255),
    marital VARCHAR(255),
    education VARCHAR(255),
    credit_default VARCHAR(255),
    balance NUMBER,
    housing VARCHAR(255),
    loan VARCHAR(255),
    contact VARCHAR(255),
    cday VARCHAR(255),
    cmonth VARCHAR(255),
    cduration NUMBER,
    campaign NUMBER,
    pdays NUMBER,
    previous NUMBER,
    poutcome VARCHAR(255),
    y VARCHAR(255)
);

BEGIN
    EXECUTE IMMEDIATE 
        'CREATE OR REPLACE VIEW 
        bank_train_data AS 
        SELECT * FROM bank 
        SAMPLE (75) SEED (42)';
    EXECUTE IMMEDIATE 
        'CREATE OR REPLACE VIEW 
        bank_test_data AS 
        SELECT * FROM bank 
        MINUS 
        SELECT * FROM bank_train_data';
END;

SELECT count(*)
FROM bank;
SELECT count(*)
FROM bank_train_data;
SELECT count(*)
FROM bank_test_data;