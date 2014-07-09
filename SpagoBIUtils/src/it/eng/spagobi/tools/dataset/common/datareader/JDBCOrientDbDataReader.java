/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package it.eng.spagobi.tools.dataset.common.datareader;

import it.eng.spago.error.EMFInternalError;
import it.eng.spago.error.EMFUserError;
import it.eng.spagobi.tools.dataset.common.datastore.DataStore;
import it.eng.spagobi.tools.dataset.common.datastore.Field;
import it.eng.spagobi.tools.dataset.common.datastore.IDataStore;
import it.eng.spagobi.tools.dataset.common.datastore.IField;
import it.eng.spagobi.tools.dataset.common.datastore.IRecord;
import it.eng.spagobi.tools.dataset.common.datastore.Record;
import it.eng.spagobi.tools.dataset.common.metadata.FieldMetadata;
import it.eng.spagobi.tools.dataset.common.metadata.MetaData;
import it.eng.spagobi.utilities.engines.SpagoBIEngineException;

import java.sql.Ref;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;

import org.apache.log4j.Logger;

/**
 * @author Monica Franceschini (monica.franceschini@eng.it)
 * NOTE: This reader works well when user specifies the column names in the query, fails order retrieval when 
 * query is select *...
 */
public class JDBCOrientDbDataReader extends AbstractDataReader {

	private static transient Logger logger = Logger
			.getLogger(JDBCOrientDbDataReader.class);

	public JDBCOrientDbDataReader() {
	}

	public boolean isOffsetSupported() {
		return true;
	}

	public boolean isFetchSizeSupported() {
		return true;
	}

	public boolean isMaxResultsSupported() {
		return true;
	}

	public IDataStore read(Object data) throws EMFUserError, EMFInternalError {
		DataStore dataStore = null;
		MetaData dataStoreMeta;
		ResultSet rs;

		int columnIndex;

		logger.debug("IN");
		dataStore = new DataStore();
		dataStoreMeta = new MetaData();

		dataStore.setMetaData(dataStoreMeta);
		rs = (ResultSet) data;

		try {
			boolean ok = true;
			while (rs.next()) {
				IRecord record = new Record(dataStore);
				ResultSetMetaData meta = rs.getMetaData();

				columnIndex = 1;
				try {
					while (true) {
						String name = meta.getColumnName(columnIndex);

						Object value = rs.getObject(name);

						FieldMetadata fieldMeta = new FieldMetadata();
						fieldMeta.setName(name);
						
						String c = value.getClass().getName();
						Class clazz = Class.forName(c);
						fieldMeta.setType(getType(c));
						if (dataStoreMeta.getFieldIndex(name) == -1) {
							dataStoreMeta.addFiedMeta(fieldMeta);
						}

						if(clazz.getName().contains("orient")){
							value = value.toString();
						}
						IField field = new Field(value);
						
						record.appendField(field);					

						columnIndex++;
					}

				} catch (ArrayIndexOutOfBoundsException arrEx) {
					ok = false;
				} catch (ClassNotFoundException e) {
					logger.error("", e);
				}
				if (!record.getFields().isEmpty()) {
					dataStore.appendRecord(record);
				}

			}

		} catch (SQLException e) {
			logger.error("An unexpected error occured while reading resultset",
					e);
		} catch (RuntimeException e) {
			logger.error("Must use a JDBC data source - not JNDI", e);
		} finally {
			logger.debug("OUT");
		}

		return dataStore;
	}

	private Class getType(String classNn) throws ClassNotFoundException {

		if (!classNn.equals(String.class.getName()) && !classNn.equals(java.math.BigDecimal.class.getName())
				&& !classNn.equals(Boolean.class.getName()) && !classNn.equals(Short.class.getName())
				&& !classNn.equals(Integer.class.getName()) && !classNn.equals(Long.class.getName())
				&& !classNn.equals(Float.class.getName()) && !classNn.equals(Double.class.getName())
				&& !classNn.equals(java.sql.Date.class.getName()) && !classNn.equals(java.sql.Time.class.getName())
				&& !classNn.equals(java.sql.Timestamp.class.getName())) {
			return String.class;
		}
		return Class.forName(classNn);

	}
}
