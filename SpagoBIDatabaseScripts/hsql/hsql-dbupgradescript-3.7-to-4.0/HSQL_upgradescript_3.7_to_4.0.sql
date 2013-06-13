ALTER TABLE SBI_META_MODELS ADD COLUMN CATEGORY_ID INTEGER NULL;

-- Added column for persistence dataset management
ALTER TABLE SBI_DATA_SET_HISTORY ADD COLUMN IS_PERSISTED BOOLEAN DEFAULT FALSE;
ALTER TABLE SBI_DATA_SET_HISTORY ADD COLUMN DATA_SOURCE_PERSIST_ID INTEGER NULL;
ALTER TABLE SBI_DATA_SET_HISTORY ADD COLUMN IS_FLAT_DATASET BOOLEAN DEFAULT FALSE;
ALTER TABLE SBI_DATA_SET_HISTORY ADD COLUMN FLAT_TABLE_NAME VARCHAR(50) NULL;
ALTER TABLE SBI_DATA_SET_HISTORY ADD COLUMN DATA_SOURCE_FLAT_ID INTEGER NULL;

ALTER TABLE SBI_DATA_SET_HISTORY ADD CONSTRAINT FK_SBI_DATA_SET_DS3 FOREIGN KEY ( DATA_SOURCE_PERSIST_ID ) REFERENCES SBI_DATA_SOURCE( DS_ID ) ON DELETE CASCADE;
ALTER TABLE SBI_DATA_SET_HISTORY ADD CONSTRAINT FK_SBI_DATA_SET_DS4 FOREIGN KEY ( DATA_SOURCE_FLAT_ID ) REFERENCES SBI_DATA_SOURCE( DS_ID ) ON DELETE CASCADE;

CREATE MEMORY TABLE SBI_EXT_ROLES_CATEGORY ( EXT_ROLE_ID INTEGER NOT NULL,CATEGORY_ID INTEGER NOT NULL,PRIMARY KEY (EXT_ROLE_ID,CATEGORY_ID),KEY FK_SB_EXT_ROLES_META_MODEL_CATEGORY_2 (CATEGORY_ID), CONSTRAINT FK_SB_EXT_ROLES_META_MODEL_CATEGORY_1 FOREIGN KEY (EXT_ROLE_ID) REFERENCES SBI_EXT_ROLES (EXT_ROLE_ID),   CONSTRAINT FK_SB_EXT_ROLES_META_MODEL_CATEGORY_2 FOREIGN KEY (CATEGORY_ID) REFERENCES SBI_DOMAINS (VALUE_ID))

CREATE MEMORY TABLE SBI_DATA_SET_TEMP(DS_ID INTEGER NOT NULL, VERSION_NUM INTEGER NOT NULL, ACTIVE BOOLEAN NOT NULL, DESCR VARCHAR(160), LABEL VARCHAR(50) NOT NULL, NAME VARCHAR(50) NOT NULL,OBJECT_TYPE VARCHAR(50),CONFIGURATION VARCHAR,DS_METADATA VARCHAR,PARAMS VARCHAR(4000),CATEGORY_ID INTEGER,TRANSFORMER_ID INTEGER,PIVOT_COLUMN VARCHAR(50),PIVOT_ROW VARCHAR(50),PIVOT_VALUE VARCHAR(50),NUM_ROWS BOOLEAN DEFAULT false,META_VERSION VARCHAR(100),IS_PERSISTED BOOLEAN DEFAULT FALSE,DATA_SOURCE_PERSIST_ID INTEGER NULL,IS_FLAT_DATASET BOOLEAN DEFAULT FALSE,FLAT_TABLE_NAME VARCHAR(50) NULL,DATA_SOURCE_FLAT_ID INTEGER NULL,USER_IN VARCHAR(100) DEFAULT '' NOT NULL, USER_UP VARCHAR(100),USER_DE VARCHAR(100), TIME_IN TIMESTAMP DEFAULT NOW NOT NULL, TIME_UP TIMESTAMP, TIME_DE TIMESTAMP,SBI_VERSION_IN VARCHAR(10),SBI_VERSION_UP VARCHAR(10),SBI_VERSION_DE VARCHAR(10),ORGANIZATION VARCHAR(20),CONSTRAINT XPKSBI_DATA_SET_TEMP PRIMARY KEY(DS_ID, VERSION_NUM),CONSTRAINT XAK2SBI_DATA_SET UNIQUE(LABEL,VERSION_NUM,ORGANIZATION))
INSERT INTO SBI_DATA_SET_TEMP (DS_ID, VERSION_NUM, ACTIVE,  LABEL, DESCR, NAME, OBJECT_TYPE, DS_METADATA, PARAMS, CATEGORY_ID, TRANSFORMER_ID, PIVOT_COLUMN, PIVOT_ROW, PIVOT_VALUE, NUM_ROWS, IS_PERSISTED, 
DATA_SOURCE_PERSIST_ID, IS_FLAT_DATASET, FLAT_TABLE_NAME, DATA_SOURCE_FLAT_ID, USER_IN, USER_UP, USER_DE, TIME_IN, TIME_UP, TIME_DE, SBI_VERSION_IN, SBI_VERSION_UP, SBI_VERSION_DE,
META_VERSION, ORGANIZATION, CONFIGURATION) 
SELECT DS.DS_ID, ds_h.VERSION_NUM, ds_h.ACTIVE, ds.LABEL, ds.DESCR, ds.name,
ds_h.OBJECT_TYPE, ds_h.DS_METADATA,
ds_h.PARAMS, ds_h.CATEGORY_ID, ds_h.TRANSFORMER_ID, ds_h.PIVOT_COLUMN, ds_h.PIVOT_ROW,
ds_h.PIVOT_VALUE, ds_h.NUM_ROWS, ds_h.IS_PERSISTED, ds_h.DATA_SOURCE_PERSIST_ID, 
ds_h.IS_FLAT_DATASET, ds_h.FLAT_TABLE_NAME, ds_h.DATA_SOURCE_FLAT_ID, ds_h.USER_IN, 
null as USER_UP,null as USER_DE, ds_h.TIME_IN, null as TIME_UP, null as TIME_DE,
ds_h.SBI_VERSION_IN, null as SBI_VERSION_UP,  null as SBI_VERSION_DE, ds_h.META_VERSION,
ds_h.ORGANIZATION
,case when ds_h.OBJECT_TYPE = 'SbiQueryDataSet' then 
concat(concat(concat(concat(concat(concat(concat(concat('{"Query":"',REPLACE(ds_h.QUERY,'"','\\"')),'","queryScript":"'),REPLACE(COALESCE(DS_H.QUERY_SCRIPT,''),'"','\\"')),'","queryScriptLanguage":"'),COALESCE(QUERY_SCRIPT_LANGUAGE,'')),'","dataSource":"'),COALESCE(CAST((SELECT LABEL FROM SBI_DATA_SOURCE WHERE DS_ID = DATA_SOURCE_ID) AS CHAR),'')),'"}')
WHEN ds_h.OBJECT_TYPE = 'SbiFileDataSet' then concat(concat('{"fileName":"',COALESCE(DS_H.FILE_NAME,'')),'"}')
WHEN ds_h.OBJECT_TYPE = 'SbiWSDataSet' then concat(concat(concat(concat(concat('{"wsAddress":"',COALESCE(DS_H.ADRESS,'')),'"}'),'","wsOperation":"'),COALESCE(DS_H.OPERATION,'')),'"}')
WHEN ds_h.OBJECT_TYPE = 'SbiScriptDataSet' then concat(concat(concat(concat(concat('{"Script":"',REPLACE(COALESCE(DS_H.SCRIPT,''),'"','\\"')),'"}'),'","scriptLanguage":"'),COALESCE(DS_H.LANGUAGE_SCRIPT,'')),'"}')
WHEN ds_h.OBJECT_TYPE = 'SbiCustomDataSet' then concat(concat(concat(concat(concat('{"customData":"',REPLACE(COALESCE(DS_H.CUSTOM_DATA,''),'"','\\"')),'"}'),'","jClassName":"'),COALESCE(DS_H.JCLASS_NAME,'')),'"}')
WHEN ds_h.OBJECT_TYPE = 'SbiQbeDataSet' then  concat(concat(concat(concat(concat(concat(concat('{"qbeDatamarts":"',COALESCE(DS_H.DATAMARTS,'')),'","qbeJSONQuery":"'),REPLACE(COALESCE(DS_H.JSON_QUERY,''),'"','\\"')),'","qbeDataSource":"'),COALESCE(CAST((SELECT LABEL FROM SBI_DATA_SOURCE WHERE DS_ID = DATA_SOURCE_ID) AS CHAR))),''),'"}')
end AS CONFIGURATION
FROM 
SBI_DATA_SET DS INNER JOIN SBI_DATA_SET_HISTORY DS_H ON (DS.DS_ID = DS_H.DS_ID)
order by ds_id, version_num;

commit;

-- to do at the end, when all it's ended correctly!
--DROP OLDER FK TO SBI_DATA_SET
--ALTER TABLE SBI_LOV DROP CONSTRAINT FK_SBI_LOV_2;
--ALTER TABLE SBI_KPI DROP CONSTRAINT SBI_KPI_IBFK_1;
--DROP TABLE SBI_DATA_SET_HISTORY CASCADE;   
--DROP TABLE SBI_DATA_SET CASCADE;
-- to do only after drop stmt
--ALTER TABLE SBI_DATA_SET ADD CONSTRAINT FK_SBI_DATA_SET_T  FOREIGN KEY ( TRANSFORMER_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID ) ON DELETE CASCADE;
--ALTER TABLE SBI_DATA_SET ADD CONSTRAINT FK_SBI_DATA_SET_CAT  FOREIGN KEY (CATEGORY_ID) REFERENCES SBI_DOMAINS (VALUE_ID) ON DELETE CASCADE ON UPDATE RESTRICT;
--ALTER TABLE SBI_DATA_SET ADD CONSTRAINT FK_SBI_DATA_SET_DS3 FOREIGN KEY ( DATA_SOURCE_PERSIST_ID ) REFERENCES SBI_DATA_SOURCE( DS_ID ) ON DELETE CASCADE;
--ALTER TABLE SBI_DATA_SET ADD CONSTRAINT FK_SBI_DATA_SET_DS4 FOREIGN KEY ( DATA_SOURCE_FLAT_ID ) REFERENCES SBI_DATA_SOURCE( DS_ID ) ON DELETE CASCADE;   
ALTER TABLE SBI_DATA_SET RENAME TO SBI_DATA_SET_OLD;
ALTER TABLE SBI_DATA_SET_HISTORY RENAME TO SBI_DATA_SET_HISTORY_OLD;
ALTER TABLE SBI_DATA_SET_TEMP RENAME TO SBI_DATA_SET;

-- insert records for selfservice dataset management 
INSERT INTO SBI_USER_FUNC (USER_FUNCT_ID, NAME, DESCRIPTION, USER_IN, TIME_IN)
    VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_USER_FUNC'), 
    'SelfServiceDatasetManagement','SelfServiceDatasetManagement', 'server', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_USER_FUNC';
commit;
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'USER' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceDatasetManagement'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceDatasetManagement'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'DEV_ROLE' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceDatasetManagement'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'TEST_ROLE' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceDatasetManagement'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'MODEL_ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceDatasetManagement'));
commit;

UPDATE SBI_ENGINES SET USE_DATASET = TRUE WHERE DRIVER_NM = 'it.eng.spagobi.engines.drivers.worksheet.WorksheetDriver';
commit;

ALTER TABLE SBI_DATA_SET ADD COLUMN OWNER VARCHAR(50);
ALTER TABLE SBI_DATA_SET ADD COLUMN IS_PUBLIC BOOLEAN DEFAULT FALSE;

UPDATE SBI_DATA_SET SET IS_PUBLIC = TRUE, OWNER = 'biadmin';
COMMIT;

INSERT INTO SBI_USER_FUNC (USER_FUNCT_ID, NAME, DESCRIPTION, USER_IN, TIME_IN)
    VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_USER_FUNC'), 
    'SelfServiceMetaModelManagement','SelfServiceMetaModelManagement', 'server', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_USER_FUNC';
commit;
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'USER' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceMetaModelManagement'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceMetaModelManagement'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'DEV_ROLE' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceMetaModelManagement'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'TEST_ROLE' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceMetaModelManagement'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'MODEL_ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'SelfServiceMetaModelManagement'));
commit;

ALTER TABLE SBI_META_MODELS  ADD DATA_SOURCE_ID INTEGER;