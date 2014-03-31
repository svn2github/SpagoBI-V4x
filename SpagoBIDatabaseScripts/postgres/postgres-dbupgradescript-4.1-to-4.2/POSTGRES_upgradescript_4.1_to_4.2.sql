ALTER TABLE SBI_ORGANIZATIONS ADD COLUMN THEME VARCHAR(100) NULL DEFAULT 'SPAGOBI.THEMES.THEME.default';
ALTER TABLE SBI_USER ADD COLUMN IS_SUPERADMIN BOOLEAN DEFAULT FALSE;

UPDATE SBI_USER us SET us.IS_SUPERADMIN = TRUE WHERE us.ID IN(
	SELECT ur.ID FROM SBI_EXT_USER_ROLES ur WHERE ur.EXT_ROLE_ID IN( 
		SELECT role.EXT_ROLE_ID FROM SBI_EXT_ROLES role WHERE role.ROLE_TYPE_CD = 'ADMIN'
	)
);

CREATE TABLE SBI_ORGANIZATION_ENGINE (
  ENGINE_ID INTEGER NOT NULL,
  ORGANIZATION_ID INTEGER NOT NULL,
  CREATION_DATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  LAST_CHANGE_DATE timestamp NULL DEFAULT NULL,
  USER_IN VARCHAR(100) NOT NULL,
  USER_UP VARCHAR(100) DEFAULT NULL,
  USER_DE VARCHAR(100) DEFAULT NULL,
  TIME_IN TIMESTAMP NULL DEFAULT NULL,
  TIME_UP TIMESTAMP NULL DEFAULT NULL,
  TIME_DE TIMESTAMP NULL DEFAULT NULL,
  SBI_VERSION_IN VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_UP VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_DE VARCHAR(10) DEFAULT NULL,
  META_VERSION VARCHAR(100) DEFAULT NULL,
  ORGANIZATION VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (ENGINE_ID,ORGANIZATION_ID ),
  CONSTRAINT FK_ENGINE_1 FOREIGN KEY (ENGINE_ID) REFERENCES SBI_ENGINES (ENGINE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_ORGANIZATION_1 FOREIGN KEY (ORGANIZATION_ID) REFERENCES SBI_ORGANIZATIONS (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;


CREATE TABLE SBI_ORGANIZATION_DATASOURCE (
  DATASOURCE_ID INTEGER NOT NULL,
  ORGANIZATION_ID INTEGER NOT NULL,
  CREATION_DATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  LAST_CHANGE_DATE TIMESTAMP NULL DEFAULT NULL,
  USER_IN VARCHAR(100) NOT NULL,
  USER_UP VARCHAR(100) DEFAULT NULL,
  USER_DE VARCHAR(100) DEFAULT NULL,
  TIME_IN TIMESTAMP NULL DEFAULT NULL,
  TIME_UP TIMESTAMP NULL DEFAULT NULL,
  TIME_DE TIMESTAMP NULL DEFAULT NULL,
  SBI_VERSION_IN VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_UP VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_DE VARCHAR(10) DEFAULT NULL,
  META_VERSION VARCHAR(100) DEFAULT NULL,
  ORGANIZATION VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (DATASOURCE_ID,ORGANIZATION_ID ),
  CONSTRAINT FK_DATASOURCE_2 FOREIGN KEY (DATASOURCE_ID) REFERENCES SBI_DATA_SOURCE (DS_ID) ON DELETE CASCADE,
  CONSTRAINT FK_ORGANIZATION_2 FOREIGN KEY (ORGANIZATION_ID) REFERENCES SBI_ORGANIZATIONS (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;

INSERT INTO sbi_organization_datasource (DATASOURCE_ID, ORGANIZATION_ID, CREATION_DATE, LAST_CHANGE_DATE, USER_IN, TIME_IN, SBI_VERSION_IN)
  SELECT ds.ds_id, org.id,  CURRENT_TIMESTAMP,  CURRENT_TIMESTAMP, 'server',  CURRENT_TIMESTAMP, '4.1'
  FROM sbi_data_source ds, sbi_organizations org WHERE ds.organization = org.name;
    
 INSERT INTO sbi_organization_engine (ENGINE_ID, ORGANIZATION_ID, CREATION_DATE, LAST_CHANGE_DATE, USER_IN, TIME_IN, SBI_VERSION_IN)
  SELECT eng.engine_id, org.id,  CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'server',  CURRENT_TIMESTAMP, '4.1'
  FROM sbi_engines eng, sbi_organizations org WHERE eng.organization = org.name;
COMMIT;

UPDATE SBI_OBJECTS r JOIN (
SELECT B.ENGINE_ID AS OK, A.ENGINE_ID AS KO
FROM
(SELECT ENGINE_ID, LABEL, ORGANIZATION FROM SBI_ENGINES WHERE ORGANIZATION !='SPAGOBI') A,
(SELECT ENGINE_ID, LABEL, ORGANIZATION FROM SBI_ENGINES WHERE ORGANIZATION ='SPAGOBI') B
WHERE A.LABEL=B.LABEL
) t ON (r.ENGINE_ID = t.KO)
SET r.ENGINE_ID = t.OK
WHERE r.ENGINE_ID = t.KO;

DELETE FROM SBI_EXPORTERS where engine_id IN (SELECT ENGINE_ID FROM SBI_ENGINES WHERE ORGANIZATION !='SPAGOBI');
COMMIT;

delete from SBI_ENGINES where organization !='SPAGOBI';
COMMIT;

CREATE TABLE SBI_AUTHORIZATIONS (
  ID INTEGER NOT NULL,
  NAME VARCHAR(200) DEFAULT NULL,
  CREATION_DATE timestamp NOT NULL,
  LAST_CHANGE_DATE timestamp NOT NULL,
  USER_IN VARCHAR(100) NOT NULL,
  USER_UP VARCHAR(100) DEFAULT NULL,
  USER_DE VARCHAR(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL,
  TIME_UP timestamp DEFAULT NULL,
  TIME_DE timestamp DEFAULT NULL,
  SBI_VERSION_IN VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_UP VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_DE VARCHAR(10) DEFAULT NULL,
  META_VERSION VARCHAR(100) DEFAULT NULL,
  ORGANIZATION VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (ID)
);
insert into hibernate_sequences (SEQUENCE_NAME, NEXT_VAL) 
values('SBI_AUTHORIZATIONS', 1);
COMMIT;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SAVE_SUBOBJECTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_SUBOBJECTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_VIEWPOINTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_SNAPSHOTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_NOTES', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEND_MAIL', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SAVE_INTO_FOLDER', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SAVE_REMEMBER_ME', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_METADATA', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SAVE_METADATA', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'BUILD_QBE_QUERY', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'DO_MASSIVE_EXPORT', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'EDIT_WORKSHEET', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'MANAGE_USERS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_DOCUMENT_BROWSER', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_FAVOURITES', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_SUBSCRIPTIONS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_MY_DATA', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;


INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'SEE_TODO_LIST', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;



INSERT INTO SBI_AUTHORIZATIONS
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS'), 
'CREATE_DOCUMENTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_AUTHORIZATIONS';
commit;

CREATE TABLE SBI_AUTHORIZATIONS_ROLES (
  AUTHORIZATION_ID INTEGER NOT NULL,
  ROLE_ID INTEGER NOT NULL,
  USER_IN VARCHAR(100) NOT NULL,
  USER_UP VARCHAR(100) DEFAULT NULL,
  USER_DE VARCHAR(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL,
  TIME_UP timestamp  DEFAULT NULL,
  TIME_DE timestamp  DEFAULT NULL,
  SBI_VERSION_IN VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_UP VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_DE VARCHAR(10) DEFAULT NULL,
  META_VERSION VARCHAR(100) DEFAULT NULL,
  ORGANIZATION VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (AUTHORIZATION_ID,ROLE_ID ),
  CONSTRAINT FK_ROLE1 FOREIGN KEY (ROLE_ID) REFERENCES SBI_EXT_ROLES (EXT_ROLE_ID),
  CONSTRAINT FK_AUTHORIZATION_1 FOREIGN KEY (AUTHORIZATION_ID) REFERENCES SBI_AUTHORIZATIONS (ID)
);

INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SAVE_SUBOBJECTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_SUBOBJECTS IS TRUE;

INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'CREATE_DOCUMENTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.CREATE_DOCUMENTS IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_SUBOBJECTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SUBOBJECTS IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_VIEWPOINTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_VIEWPOINTS IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_SNAPSHOTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SNAPSHOTS IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_NOTES') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_NOTES IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEND_MAIL') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEND_MAIL IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SAVE_INTO_FOLDER') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_INTO_FOLDER IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SAVE_REMEMBER_ME') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_REMEMBER_ME IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_METADATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_METADATA IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SAVE_METADATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_METADATA IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'BUILD_QBE_QUERY') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.BUILD_QBE_QUERY IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'DO_MASSIVE_EXPORT') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.DO_MASSIVE_EXPORT IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'EDIT_WORKSHEET') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.EDIT_WORKSHEET IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'MANAGE_USERS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.MANAGE_USERS IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_DOCUMENT_BROWSER') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_DOCUMENT_BROWSER IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_FAVOURITES') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_FAVOURITES IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_SUBSCRIPTIONS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SUBSCRIPTIONS IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_MY_DATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_MY_DATA IS TRUE;
INSERT INTO SBI_AUTHORIZATIONS_ROLES 
(AUTHORIZATION_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_AUTHORIZATIONS WHERE NAME= 'SEE_TODO_LIST') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_TODO_LIST IS TRUE;
commit;

UPDATE SBI_ENGINES SET DRIVER_NM = 'it.eng.spagobi.engines.drivers.gis.GisDriver' 
		WHERE DRIVER_NM = 'it.eng.spagobi.engines.drivers.generic.GenericDriver' 
		AND BIOBJ_TYPE IN (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'MAP'); 
COMMIT;

--27/01/2014: Added SpagoBICockpitEngine configuration
INSERT INTO SBI_ENGINES
(ENGINE_ID,ENCRYPT,NAME,DESCR,MAIN_URL,SECN_URL,OBJ_UPL_DIR,OBJ_USE_DIR,DRIVER_NM,LABEL,ENGINE_TYPE,CLASS_NM,BIOBJ_TYPE,USE_DATASET,USE_DATASOURCE,USER_IN,USER_UP,USER_DE,TIME_IN,
TIME_UP,TIME_DE,SBI_VERSION_IN,SBI_VERSION_UP,SBI_VERSION_DE,META_VERSION,ORGANIZATION)
VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_ENGINES'), 0, 'Cockpit Engine', 'Cockpit Engine', '/SpagoBICockpitEngine/CockpitEngineStartAction', NULL, NULL, NULL, 'it.eng.spagobi.engines.drivers.cockpit.CockpitDriver', 'SpagoBICockpitEngine', (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'ENGINE_TYPE' AND VALUE_CD = 'EXT'), '',(SELECT VALUE_ID FROM spagobi.SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'DOCUMENT_COMPOSITE'), false, false, 'database', 'biadmin', NULL, '2014-01-09 00:00:00', '2014-01-09 00:00:00', NULL, '4.1', '4.1', NULL, NULL, 'SPAGOBI');
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_ENGINES';
commit;
INSERT INTO SBI_ORGANIZATION_ENGINE (ENGINE_ID, ORGANIZATION_ID, CREATION_DATE, LAST_CHANGE_DATE, USER_IN, TIME_IN, SBI_VERSION_IN)
values((SELECT engine_id from sbi_engines where label='SpagoBICockpitEngine'), (select id from sbi_organizations where name = 'SPAGOBI'),
NOW(), NOW(), 'server', NOW(), '4.1');
commit;

update SBI_ENGINES SET DRIVER_NM = 'it.eng.spagobi.engines.drivers.xmla.XMLADriver' where label = 'XMLAEngine';
commit;

ALTER TABLE SBI_AUDIT ALTER COLUMN DOC_LABEL varchar(200);
ALTER TABLE SBI_AUDIT ALTER COLUMN DOC_NAME varchar(200);
ALTER TABLE SBI_OBJECTS DROP FOREIGN KEY FK_SBI_OBJECTS_5 ;
ALTER TABLE SBI_OBJECTS DROP FOREIGN KEY FK_SBI_OBJECTS_6;
ALTER TABLE SBI_OBJECTS DROP FOREIGN KEY FK_SBIDATA_SOURCE;

CREATE TABLE SBI_TRIGGER_PAUSED (
	   ID 					INTEGER  NOT NULL ,
       TRIGGER_NAME	 	    VARCHAR(80) NOT NULL,
       TRIGGER_GROUP 	    VARCHAR(80) NOT NULL,
       JOB_NAME 	        VARCHAR(80) NOT NULL,
       JOB_GROUP 	        VARCHAR(80) NOT NULL,	   	   
       USER_IN              VARCHAR(100) NOT NULL,
       USER_UP              VARCHAR(100),
       USER_DE              VARCHAR(100),
       TIME_IN              TIMESTAMP NOT NULL,
       TIME_UP              TIMESTAMP NULL DEFAULT NULL,
       TIME_DE              TIMESTAMP NULL DEFAULT NULL,
       SBI_VERSION_IN       VARCHAR(10),
       SBI_VERSION_UP       VARCHAR(10),
       SBI_VERSION_DE       VARCHAR(10),
       META_VERSION         VARCHAR(100),
       ORGANIZATION         VARCHAR(20),  
       CONSTRAINT XAK1SBI_TRIGGER_PAUSED UNIQUE(TRIGGER_NAME, TRIGGER_GROUP, JOB_NAME, JOB_GROUP),
       PRIMARY KEY (ID)
) WITHOUT OIDS;

INSERT INTO SBI_CONFIG ( ID, LABEL, NAME, DESCRIPTION, IS_ACTIVE, VALUE_CHECK, VALUE_TYPE_ID, CATEGORY, USER_IN, TIME_IN) VALUES 
((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_CONFIG'), 
'SPAGOBI.DOCUMENTS.MAX_PREVIEW_IMAGE_SIZE', 'Max preview image size', 'Max dimension for a document''s preview image', true, '1048576',
(select VALUE_ID from SBI_DOMAINS where VALUE_CD = 'NUM' AND DOMAIN_CD = 'PAR_TYPE'), 'GENERIC_CONFIGURATION', 'biadmin', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_CONFIG';
commit;
INSERT INTO SBI_CONFIG ( ID, LABEL, NAME, DESCRIPTION, IS_ACTIVE, VALUE_CHECK, VALUE_TYPE_ID, CATEGORY, USER_IN, TIME_IN) VALUES 
((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_CONFIG'), 
'SPAGOBI.DOCUMENTS.MAX_PREVIEW_IMAGES_NUM', 'Max preview images', 'Max number for documents'' preview images', true, '200',
(select VALUE_ID from SBI_DOMAINS where VALUE_CD = 'NUM' AND DOMAIN_CD = 'PAR_TYPE'), 'GENERIC_CONFIGURATION', 'biadmin', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_CONFIG';
commit;

ALTER TABLE SBI_OBJECTS DROP COLUMN IS_PUBLIC;