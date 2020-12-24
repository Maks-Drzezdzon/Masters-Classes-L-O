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

DROP TABLE bank_model_settings;
SELECT *
FROM BANK;

update bank set y = 0 where y = 'no';
update bank set y = 1 where y = 'yes';


CREATE SEQUENCE seq_bank;
alter table bank add
(
    row_id integer default seq_bank.nextval
);

drop view bank_train_data;
drop view bank_test_data;

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

select *
from bank_train_data;
select *
from bank_test_data;

create table bank_model_settings
(
    setting_name varchar2(30),
    setting_value varchar2(4000)
);

-- setup above


--- GLM start
begin
    insert into bank_model_settings
    values(dbms_data_mining.ALGO_NAME, dbms_data_mining.ALGO_GENERALIZED_LINEAR_MODEL);
    -- ROW DIAGNOSTICS
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_DIAGNOSTICS_TABLE_NAME, 'GLMS_BANK_DIAG');
    -- DATA PREP
    insert into bank_model_settings
    values(dbms_data_mining.PREP_AUTO, dbms_data_mining.PREP_AUTO_ON);
    -- FEATURE SELECTION
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_FTR_SELECTION, dbms_data_mining.GLMS_FTR_SELECTION_ENABLE);
    -- FEATURE GENERATION
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_FTR_GENERATION, dbms_data_mining.GLMS_FTR_GENERATION_ENABLE);
end;

select *
from table(dbms_data_mining.get_model_details('GLMS_BANK_DIAG'));

begin 
    dbms_data_mining.create_model
(
        model_name => 'GLMR_REGRESSION_BANK',
        mining_function => dbms_data_mining.REGRESSION,
        data_table_name => 'bank_train_data',
        case_id_column_name => 'row_id',
        target_column_name => 'y',
        settings_table_name => 'bank_model_settings'
    );
end;

select *
from GLMR_REGRESSION_BANK;

select *
from table(dbms_data_mining.get_model_details_global('GLMR_REGRESSION_BANK'))
order by global_detail_name;

begin
    dbms_data_mining.apply
(
        'GLMR_REGRESSION_BANK',
        'bank_test_data',
        'row_id',
        'bank_test_predictions'
    );
end;

select *
from bank_test_predictions;

select *
from table(dbms_data_mining.get_model_details_global('bank_test_predictions'))
order by global_detail_name;

--- GLM end


--- NAIVE BAYES start
begin
    insert into bank_model_settings
    values(dbms_data_mining.ALGO_NAME, dbms_data_mining.ALGO_NAIVE_BAYES);
end;

select *
from bank_model_settings;
delete from bank_model_settings;

begin 
    dbms_data_mining.create_model
(
        model_name => 'NAIVE_BAYES_BANK',
        mining_function => dbms_data_mining.Classification,
        data_table_name => 'bank_train_data',
        case_id_column_name => 'row_id',
        target_column_name => 'y',
        settings_table_name => 'bank_model_settings'
    );
end;


select *
from table(dbms_data_mining.get_model_details_global('NAIVE_BAYES_BANK'));

select *
from table(dbms_data_mining.get_model_details_global('NAIVE_BAYES_BANK'))
order by global_detail_name;
--- NAIVE BAYES end


--- Neural Network start
begin
    insert into bank_model_settings
    values(dbms_data_mining.ALGO_NAME, dbms_data_mining.ALGO_GENERALIZED_LINEAR_MODEL);
    -- ROW DIAGNOSTICS
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_DIAGNOSTICS_TABLE_NAME, 'GLMS_BANK_DIAG');
    -- DATA PREP
    insert into bank_model_settings
    values(dbms_data_mining.PREP_AUTO, dbms_data_mining.PREP_AUTO_ON);
    -- FEATURE SELECTION
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_FTR_SELECTION, dbms_data_mining.GLMS_FTR_SELECTION_ENABLE);
    -- FEATURE GENERATION
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_FTR_GENERATION, dbms_data_mining.GLMS_FTR_GENERATION_ENABLE);
end;

select *
from bank_model_settings;

begin 
    dbms_data_mining.create_model
(
        model_name => 'GLMR_REGRESSION_BANK',
        mining_function => dbms_data_mining.REGRESSION,
        data_table_name => 'bank_train_data',
        case_id_column_name => 'row_id',
        target_column_name => 'y',
        settings_table_name => 'bank_model_settings'
    );
end;

select *
from table(dbms_data_mining.get_model_details_global('GLMR_REGRESSION_BANK'))
order by global_detail_name;
--- Neural Network end


--- GLMC_REGRESSION_BANK start
begin
    insert into bank_model_settings
    values(dbms_data_mining.ALGO_NAME, dbms_data_mining.ALGO_GENERALIZED_LINEAR_MODEL);
    -- ROW DIAGNOSTICS
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_DIAGNOSTICS_TABLE_NAME, 'GLMS_BANK_DIAG');
    -- DATA PREP
    insert into bank_model_settings
    values(dbms_data_mining.PREP_AUTO, dbms_data_mining.PREP_AUTO_ON);
    -- FEATURE SELECTION
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_FTR_SELECTION, dbms_data_mining.GLMS_FTR_SELECTION_ENABLE);
    -- FEATURE GENERATION
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_FTR_GENERATION, dbms_data_mining.GLMS_FTR_GENERATION_ENABLE);
end;

select *
from bank_model_settings;
delete from bank_model_settings;

begin 
    dbms_data_mining.create_model
(
        model_name => 'GLMC_REGRESSION_BANK',
        mining_function => dbms_data_mining.Classification,
        data_table_name => 'bank_train_data',
        case_id_column_name => 'row_id',
        target_column_name => 'y',
        settings_table_name => 'bank_model_settings'
    );
end;

select *
from table(dbms_data_mining.get_model_details_global('GLMC_REGRESSION_BANK'))
order by global_detail_name;

begin
    dbms_data_mining.apply
(
        'GLMR_REGRESSION_BANK',
        'bank_test_data',
        'row_id',
        'bank_test_predictions'
    );
end;

--- ttt end

