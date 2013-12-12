INSERT INTO SBI_USER_FUNC (USER_FUNCT_ID, NAME, DESCRIPTION, USER_IN, TIME_IN)
VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_USER_FUNC'),
'TenantManagement','TenantManagement', 'server', CURRENT_TIMESTAMP);
UPDATE hibernate_sequences SET next_val = next_val+1 WHERE sequence_name = 'SBI_USER_FUNC';

INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'),
(SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'TenantManagement'));
COMMIT;

ALTER TABLE SBI_ORGANIZATIONS ADD COLUMN THEME VARCHAR(100) NULL DEFAULT 'SPAGOBI.THEMES.THEME.default';
ALTER TABLE SBI_USER ADD COLUMN IS_SUPERADMIN TINYINT(1) DEFAULT 0;

UPDATE SBI_USER us SET us.IS_SUPERADMIN = 1 WHERE us.ID IN(
	SELECT ur.ID FROM SBI_EXT_USER_ROLES ur WHERE ur.EXT_ROLE_ID IN( 
		SELECT role.EXT_ROLE_ID FROM SBI_EXT_ROLES role WHERE role.ROLE_TYPE_CD = 'ADMIN'
	)
);

CREATE TABLE SBI_ORGANIZATION_ENGINE (
  ENGINE_ID int(11) NOT NULL,
  ORGANIZATION_ID int(11) NOT NULL,
  CREATION_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  LAST_CHANGE_DATE timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (ENGINE_ID,ORGANIZATION_ID ),
  CONSTRAINT FK_ENGINE_1 FOREIGN KEY (ENGINE_ID) REFERENCES SBI_ENGINES (ENGINE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_ORGANIZATION_1 FOREIGN KEY (ORGANIZATION_ID) REFERENCES SBI_ORGANIZATIONS (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;

CREATE TABLE SBI_ORGANIZATION_DATASOURCE (
  DATASOURCE_ID int(11) NOT NULL,
  ORGANIZATION_ID int(11) NOT NULL,
  CREATION_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  LAST_CHANGE_DATE timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (DATASOURCE_ID,ORGANIZATION_ID ),
  CONSTRAINT FK_DATASOURCE_2 FOREIGN KEY (DATASOURCE_ID) REFERENCES SBI_DATA_SOURCE (DS_ID) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_ORGANIZATION_2 FOREIGN KEY (ORGANIZATION_ID) REFERENCES SBI_ORGANIZATIONS (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;

INSERT INTO SBI_ORGANIZATION_DATASOURCE (DATASOURCE_ID, ORGANIZATION_ID, CREATION_DATE, LAST_CHANGE_DATE, USER_IN, TIME_IN, SBI_VERSION_IN)
  SELECT ds.ds_id, org.id, SYSDATE(), SYSDATE(), "server", SYSDATE(), "4.1"
  FROM SBI_DATA_SOURCE ds, SBI_ORGANIZATIONS org WHERE ds.organization = org.name;
  
 INSERT INTO SBI_ORGANIZATION_ENGINE (ENGINE_ID, ORGANIZATION_ID, CREATION_DATE, LAST_CHANGE_DATE, USER_IN, TIME_IN, SBI_VERSION_IN)
  SELECT eng.engine_id, org.id, SYSDATE(), SYSDATE(), "server", SYSDATE(), "4.1"
  FROM SBI_ENGINES eng, SBI_ORGANIZATIONS org WHERE eng.organization = org.name;
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
(SELECT ENGINE_ID, LABEL, ORGANIZATION FROM SBI_ENGINES WHERE ORGANIZATION !='SPAGOBI');

DELETE FROM SBI_EXPORTERS where engine_id IN (SELECT ENGINE_ID FROM SBI_ENGINES WHERE ORGANIZATION !='SPAGOBI');
COMMIT;

DELETE from SBI_ENGINES where organization !='SPAGOBI';
COMMIT;

CREATE TABLE SBI_FUNCTIONALITIES (
  ID int(11) NOT NULL,
  NAME varchar(200) DEFAULT NULL,
  CREATION_DATE timestamp NOT NULL,
  LAST_CHANGE_DATE timestamp NOT NULL,
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL,
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (ID)
) ;
insert into hibernate_sequences (SEQUENCE_NAME, NEXT_VAL) 
values('SBI_FUNCTIONALITIES', 1);
COMMIT;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SAVE_SUBOBJECTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_SUBOBJECTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_VIEWPOINTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;


INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_SNAPSHOTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
commit;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_NOTES', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEND_MAIL', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SAVE_INTO_FOLDER', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SAVE_REMEMBER_ME', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_METADATA', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SAVE_METADATA', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'BUILD_QBE_QUERY', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'DO_MASSIVE_EXPORT', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'EDIT_WORKSHEET', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;


INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'MANAGE_USERS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_DOCUMENT_BROWSER', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_FAVOURITES', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_SUBSCRIPTIONS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;


INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_MY_DATA', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;


INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'SEE_TODO_LIST', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;



INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN, LAST_CHANGE_DATE)
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'CREATE_DOCUMENTS', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP, current_timestamp) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;


CREATE TABLE SBI_FUNCTIONALITIES_ROLES (
  FUNCTIONALITY_ID int(11) NOT NULL,
  ROLE_ID int(11) NOT NULL,
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL,
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  PRIMARY KEY (FUNCTIONALITY_ID,ROLE_ID ),
  CONSTRAINT FK_ROLE1 FOREIGN KEY (ROLE_ID) REFERENCES SBI_EXT_ROLES (EXT_ROLE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT FK_FUNCTIONALITY_1 FOREIGN KEY (FUNCTIONALITY_ID) REFERENCES SBI_FUNCTIONALITIES (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;

INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SAVE_SUBOBJECTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_SUBOBJECTS =1;

INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'CREATE_DOCUMENTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.CREATE_DOCUMENTS =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_SUBOBJECTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SUBOBJECTS =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_VIEWPOINTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_VIEWPOINTS =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_SNAPSHOTS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SNAPSHOTS =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_NOTES') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_NOTES =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEND_MAIL') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEND_MAIL =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SAVE_INTO_FOLDER') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_INTO_FOLDER =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SAVE_REMEMBER_ME') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_REMEMBER_ME =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_METADATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_METADATA =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SAVE_METADATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SAVE_METADATA =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'BUILD_QBE_QUERY') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.BUILD_QBE_QUERY =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'DO_MASSIVE_EXPORT') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.DO_MASSIVE_EXPORT =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'EDIT_WORKSHEET') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.EDIT_WORKSHEET =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'MANAGE_USERS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.MANAGE_USERS =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_DOCUMENT_BROWSER') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_DOCUMENT_BROWSER =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_FAVOURITES') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_FAVOURITES =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_SUBSCRIPTIONS') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_SUBSCRIPTIONS =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_MY_DATA') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_MY_DATA =1;
INSERT INTO SBI_FUNCTIONALITIES_ROLES 
(FUNCTIONALITY_ID, ROLE_ID, ORGANIZATION, TIME_IN, USER_IN) 
SELECT (SELECT ID FROM SBI_FUNCTIONALITIES WHERE NAME= 'SEE_TODO_LIST') F ,
D.EXT_ROLE_ID, 
D.ORGANIZATION, 
CURRENT_TIMESTAMP, 'server' FROM SBI_EXT_ROLES D WHERE D.SEE_TODO_LIST =1;

ALTER TABLE SBI_EXT_ROLES DROP COLUMN SAVE_SUBOBJECTS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN SEE_SUBOBJECTS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_VIEWPOINTS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_SNAPSHOTS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_NOTES;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEND_MAIL;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SAVE_INTO_FOLDER;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SAVE_REMEMBER_ME;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_METADATA; 
ALTER TABLE SBI_EXT_ROLES DROP COLUMN SAVE_METADATA;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  BUILD_QBE_QUERY;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  DO_MASSIVE_EXPORT;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  EDIT_WORKSHEET;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  MANAGE_USERS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_DOCUMENT_BROWSER;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_FAVOURITES;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_SUBSCRIPTIONS;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_MY_DATA;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  SEE_TODO_LIST;
ALTER TABLE SBI_EXT_ROLES DROP COLUMN  CREATE_DOCUMENTS;

INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'KPI_COMMENT_EDIT_ALL', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;
INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'KPI_COMMENT_EDIT_MY', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;
INSERT INTO SBI_FUNCTIONALITIES
(ID, NAME, CREATION_DATE, USER_IN, TIME_IN) 
values ((SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_FUNCTIONALITIES'), 
'KPI_COMMENT_DELETE', 
CURRENT_TIMESTAMP, 'server', CURRENT_TIMESTAMP) ;
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_FUNCTIONALITIES';
commit;

UPDATE SBI_ENGINES SET DRIVER_NM = 'it.eng.spagobi.engines.drivers.gis.GisDriver' 
		WHERE DRIVER_NM = 'it.eng.spagobi.engines.drivers.generic.GenericDriver' 
		AND BIOBJ_TYPE IN (SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'BIOBJ_TYPE' AND VALUE_CD = 'MAP'); 
COMMIT;