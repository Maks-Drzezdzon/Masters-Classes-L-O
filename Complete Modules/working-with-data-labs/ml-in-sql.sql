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


--- GLMR start
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
from table(dbms_data_mining.GET_MODEL_DETAILS_GLM('GLMR_REGRESSION_BANK'));

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

--- GLMR end


--- NAIVE BAYES start
begin
    insert into bank_model_settings
    values(dbms_data_mining.ALGO_NAME, dbms_data_mining.ALGO_NAIVE_BAYES);
    -- DATA PREP
    insert into bank_model_settings
    values(dbms_data_mining.PREP_AUTO, dbms_data_mining.PREP_AUTO_ON);

end;

select *
from bank_model_settings;
delete from bank_model_settings;

begin 
    dbms_data_mining.create_model
(
        model_name => 'NAIVE2_BAYES_BANK',
        mining_function => dbms_data_mining.Classification,
        data_table_name => 'bank_train_data',
        case_id_column_name => 'row_id',
        target_column_name => 'y',
        settings_table_name => 'bank_model_settings'
    );
end;


select target_attribute_name, target_attribute_str_value, prior_probability
from table(dbms_data_mining.GET_MODEL_DETAILS_NB('NAIVE2_BAYES_BANK'));

begin
    dbms_data_mining.apply
(
        'NAIVE2_BAYES_BANK',
        'bank_test_data',
        'row_id',
        'NB_bank_test_predictions'
    );
end;

select *
from NB_bank_test_predictions
fetch first 15 rows only;

select
    NB_bank_test_predictions.row_id, bank.y as actual, NB_bank_test_predictions.prediction as prediction,
    round(NB_bank_test_predictions.probability) as probability, round(NB_bank_test_predictions.cost, 4) as cost
from NB_bank_test_predictions
    inner join bank on NB_bank_test_predictions.row_id=bank.row_id;

with
    bank_data
    as
    (
        select count(row_id) as bank_row_count
        from bank
    ),
    model_data
    as
    (
        select count(*) as model_row_count
        from NB_bank_test_predictions
            inner join bank on NB_bank_test_predictions.row_id = bank.row_id
        where bank.y = NB_bank_test_predictions.prediction and round(NB_bank_test_predictions.probability) = 1
    )
select round(model_row_count/bank_row_count, 2) as Model_Accuracy
from bank_data, model_data;



--- NAIVE BAYES end


--- Neural Network start
begin
    insert into bank_model_settings
    values(dbms_data_mining.ALGO_NAME, dbms_data_mining.ALGO_NEURAL_NETWORK);
    -- ROW DIAGNOSTICS
    insert into bank_model_settings
    values(dbms_data_mining.GLMS_DIAGNOSTICS_TABLE_NAME, 'NN_BANK_DIAG');
    -- DATA PREP
    insert into bank_model_settings
    values(dbms_data_mining.PREP_AUTO, dbms_data_mining.PREP_AUTO_ON);
end;

select *
from bank_model_settings;
delete from bank_model_settings;

begin 
    dbms_data_mining.create_model
(
        model_name => 'NEURAL_NETWORK_BANK',
        mining_function => dbms_data_mining.Classification,
        data_table_name => 'bank_train_data',
        case_id_column_name => 'row_id',
        target_column_name => 'y',
        settings_table_name => 'bank_model_settings'
    );
end;

select *
from table(dbms_data_mining.get_model_details_global('NEURAL_NETWORK_BANK'));

begin
    dbms_data_mining.apply
(
        'NEURAL_NETWORK_BANK',
        'bank_test_data',
        'row_id',
        'NN_bank_test_predictions'
    );
end;


select
    NN_bank_test_predictions.row_id, bank.y as actual, NN_bank_test_predictions.prediction as prediction,
    round(NN_bank_test_predictions.probability) as probability, round(NN_bank_test_predictions.cost, 4) as cost
from NN_bank_test_predictions
    inner join bank on NN_bank_test_predictions.row_id=bank.row_id;

with
    bank_data
    as
    (
        select count(row_id) as bank_row_count
        from bank
    ),
    model_data
    as
    (
        select count(*) as model_row_count
        from NN_bank_test_predictions
            inner join bank on NN_bank_test_predictions.row_id = bank.row_id
        where bank.y = NN_bank_test_predictions.prediction and round(NN_bank_test_predictions.probability) = 1
    )
select round(model_row_count/bank_row_count, 2) as Model_Accuracy
from bank_data, model_data;


select *
from table(dbms_data_mining.get_model_details_global('NN_bank_test_predictions'));


end;

--- Neural Network end

--- SVM start
begin
    insert into bank_model_settings
    values(dbms_data_mining.ALGO_NAME, dbms_data_mining.ALGO_SUPPORT_VECTOR_MACHINES);
    -- DATA PREP
    insert into bank_model_settings
    values(dbms_data_mining.PREP_AUTO, dbms_data_mining.PREP_AUTO_ON);

    insert into bank_model_settings
    values(dbms_data_mining.SVMS_KERNEL_FUNCTION, dbms_data_mining.SVMS_GAUSSIAN);
end;

select *
from bank_model_settings;
delete from bank_model_settings;

begin 
    dbms_data_mining.create_model
(
        model_name => 'SVM_v2_REGRESSION_BANK',
        mining_function => dbms_data_mining.Classification,
        data_table_name => 'bank_train_data',
        case_id_column_name => 'row_id',
        target_column_name => 'y',
        settings_table_name => 'bank_model_settings'
    );
end;

/* There isnt much info in the global details, just the iteration count which is 30*/

select *
from table(dbms_data_mining.get_model_details_global('SVM_v2_REGRESSION_BANK'))
order by global_detail_name;


begin
    dbms_data_mining.apply
(
        'SVM_v2_REGRESSION_BANK',
        'bank_test_data',
        'row_id',
        'SVM_v2_bank_test_predictions'
    );
end;

select *
from SVM_v2_bank_test_predictions;
select max(prediction)
from SVM_R_bank_test_predictions;


select
    bank.y as actual, SVM_v2_bank_test_predictions.prediction as prediction,
    round(SVM_v2_bank_test_predictions.probability) as probability, round(SVM_v2_bank_test_predictions.cost, 4) as cost
from SVM_v2_bank_test_predictions
    inner join bank on SVM_v2_bank_test_predictions.row_id=bank.row_id;

with
    bank_data
    as
    (
        select count(row_id) as bank_row_count
        from bank
    ),
    model_data
    as
    (
        select count(*) as model_row_count
        from SVM_v2_bank_test_predictions
            inner join bank on SVM_v2_bank_test_predictions.row_id = bank.row_id
        where bank.y = SVM_v2_bank_test_predictions.prediction and round(SVM_v2_bank_test_predictions.probability) = 1
    )
select round(model_row_count/bank_row_count, 2) as Model_Accuracy
from bank_data, model_data;

--- SVM end

