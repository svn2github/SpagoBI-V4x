ALTER TABLE SBI_DATA_SOURCE ADD  COLUMN ATTR_SCHEMA character varying(45) DEFAULT NULL;
ALTER TABLE SBI_DATA_SOURCE ADD COLUMN MULTI_SCHEMA BOOLEAN DEFAULT FALSE;
ALTER TABLE SBI_EXT_ROLES ADD COLUMN BUILD_QBE_QUERY BOOLEAN DEFAULT TRUE;
ALTER TABLE SBI_KPI_VALUE ADD COLUMN XML_DATA TEXT;

commit;