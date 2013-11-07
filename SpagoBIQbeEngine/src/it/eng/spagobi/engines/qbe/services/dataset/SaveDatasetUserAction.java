/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package it.eng.spagobi.engines.qbe.services.dataset;

import it.eng.spago.base.SourceBean;
import it.eng.spago.error.EMFAbstractError;
import it.eng.spago.error.EMFErrorHandler;
import it.eng.spago.error.EMFErrorSeverity;
import it.eng.spago.validation.EMFValidationError;
import it.eng.spagobi.commons.utilities.StringUtilities;
import it.eng.spagobi.engines.qbe.QbeEngineConfig;
import it.eng.spagobi.engines.qbe.services.core.AbstractQbeEngineAction;
import it.eng.spagobi.services.proxy.DataSetServiceProxy;
import it.eng.spagobi.tools.dataset.bo.FlatDataSet;
import it.eng.spagobi.tools.dataset.bo.IDataSet;
import it.eng.spagobi.tools.dataset.common.datastore.IDataStore;
import it.eng.spagobi.tools.dataset.common.metadata.IFieldMetaData;
import it.eng.spagobi.tools.dataset.common.metadata.IMetaData;
import it.eng.spagobi.tools.dataset.common.metadata.MetaData;
import it.eng.spagobi.tools.dataset.persist.IDataSetTableDescriptor;
import it.eng.spagobi.tools.dataset.utils.DatasetMetadataParser;
import it.eng.spagobi.tools.datasource.bo.IDataSource;
import it.eng.spagobi.utilities.assertion.Assert;
import it.eng.spagobi.utilities.engines.EngineConstants;
import it.eng.spagobi.utilities.engines.SpagoBIEngineServiceException;
import it.eng.spagobi.utilities.engines.SpagoBIEngineServiceExceptionHandler;
import it.eng.spagobi.utilities.exceptions.SpagoBIRuntimeException;
import it.eng.spagobi.utilities.service.JSONSuccess;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.jamonapi.Monitor;
import com.jamonapi.MonitorFactory;

/**
 * @author Zerbetto Davide (davide.zerbetto@eng.it)
 * 
 *         This action is intended for final users; it saves a new dataset.
 * 
 */
public class SaveDatasetUserAction extends AbstractQbeEngineAction {

	private static final long serialVersionUID = 4801143200134017772L;

	public static final String SERVICE_NAME = "SAVE_DATASET_USER_ACTION";
	
	public static final String FLAT_TABLE_NAME_PREFIX = "SBI_FLAT_";
	
	public static final int FLAT_TABLE_NAME_LENGHT = 30; // Oracle supports maximum 30 characters table names

	// INPUT PARAMETERS
	public static final String LABEL = "LABEL";
	public static final String NAME = "NAME";
	public static final String DESCRIPTION = "DESCRIPTION";
	public static final String IS_PUBLIC = "isPublic";
	public static final String FLAT_TABLE_NAME = "flatTableName";
	
	// loggers
	private static Logger logger = Logger.getLogger(SaveDatasetUserAction.class);

	public void service(SourceBean request, SourceBean response)  {
		Monitor totalTimeMonitor = null;
		Monitor errorHitsMonitor = null;
		
		logger.debug("IN");
		
		try {
		
			totalTimeMonitor = MonitorFactory.start("QbeEngine.saveDatasetUserAction.totalTime");
			
			super.service(request, response);	
			
			Assert.assertNotNull(getEngineInstance(), "It's not possible to execute " + this.getActionName() + " service before having properly created an instance of EngineInstance class");
			
			validateLabel();
			validateInput();
			
			IDataSetTableDescriptor descriptor = persistCurrentDataset();
			IDataSet dataset = getEngineInstance().getActiveQueryAsDataSet();
			IDataSet newDataset = createNewDataSet(dataset, descriptor);
			IDataSet datasetSaved = saveNewDataset(newDataset);
			
			int datasetId = datasetSaved.getId();
			
			try {
				JSONObject obj = new JSONObject();
				obj.put("success", "true");
				obj.put("id", String.valueOf(datasetId));
				JSONSuccess success = new JSONSuccess(obj);
				writeBackToClient( success );
			} catch (IOException e) {
				String message = "Impossible to write back the responce to the client";
				throw new SpagoBIEngineServiceException(getActionName(), message, e);
			}

		} catch(Throwable t) {
			errorHitsMonitor = MonitorFactory.start("QbeEngine.errorHits");
			errorHitsMonitor.stop();
			throw SpagoBIEngineServiceExceptionHandler.getInstance().getWrappedException(getActionName(), getEngineInstance(), t);
		} finally {
			if (totalTimeMonitor != null)
				totalTimeMonitor.stop();
			logger.debug("OUT");
		}	
	}

	private void validateLabel() {
		String label = getAttributeAsString(LABEL);
		DataSetServiceProxy proxy = (DataSetServiceProxy) getEnv().get( EngineConstants.ENV_DATASET_PROXY );
		IDataSet dataset = proxy.getDataSetByLabel(label);
		if (dataset != null) {
			getErrorHandler().addError(new EMFValidationError(EMFErrorSeverity.ERROR, "label", "Label already in use", new ArrayList()));
		}
	}
	
	public void validateInput() {
		EMFErrorHandler errorHandler = getErrorHandler();
		if (!errorHandler.isOKBySeverity(EMFErrorSeverity.ERROR)) {
			Collection errors = errorHandler.getErrors();
			Iterator it = errors.iterator();
			while (it.hasNext()) {
				EMFAbstractError error = (EMFAbstractError) it.next();
				if (error.getSeverity().equals(EMFErrorSeverity.ERROR)) {
					throw new SpagoBIEngineServiceException(getActionName(), error.getMessage(), null);
				}
			}
		}
	}

	private IDataSet createNewDataSet(IDataSet dataset, IDataSetTableDescriptor descriptor) {
		logger.debug("IN");
		FlatDataSet flatFataSet = new FlatDataSet();
		flatFataSet.setLabel( getAttributeAsString(LABEL) );
		flatFataSet.setName( getAttributeAsString(NAME) );
		flatFataSet.setDescription( getAttributeAsString(DESCRIPTION) );

		flatFataSet.setPublic( getAttributeAsBoolean(IS_PUBLIC, Boolean.TRUE) );
		
		flatFataSet.setCategoryCd(dataset.getCategoryCd());
		flatFataSet.setCategoryId(dataset.getCategoryId());
		
		JSONObject jsonConfig = new JSONObject();
		try {
			jsonConfig.put( FlatDataSet.FLAT_TABLE_NAME, descriptor.getTableName() );
			jsonConfig.put( FlatDataSet.DATA_SOURCE, descriptor.getDataSource().getLabel() );
		} catch (JSONException e) {
			throw new SpagoBIRuntimeException("Error while creating dataset's JSON config", e);
		}
		
		flatFataSet.setTableName( descriptor.getTableName() );
		flatFataSet.setDataSource( descriptor.getDataSource() );
		flatFataSet.setConfiguration( jsonConfig.toString() );
		
		String metadata = getMetadataAsString(dataset, descriptor);
		logger.debug("Dataset's metadata: [" + metadata + "]");
		flatFataSet.setDsMetadata(metadata);
		
		logger.debug("OUT");
		return flatFataSet;
	}

	private String getMetadataAsString(IDataSet dataset,
			IDataSetTableDescriptor descriptor) {
		IMetaData metadata = getDataSetMetadata(dataset);
		MetaData newMetadata;
		try {
			newMetadata = (MetaData) ((MetaData) metadata).clone();
		} catch (CloneNotSupportedException e) {
			throw new SpagoBIRuntimeException("Error while cloning dataset's metadata", e);
		}
		
		for (int i = 0; i < metadata.getFieldCount(); i++) {
			IFieldMetaData fieldMetadata = metadata.getFieldMeta(i);
			IFieldMetaData newFieldMetadata = newMetadata.getFieldMeta(i);
			String columnName = descriptor.getColumnName(fieldMetadata.getName());
			newFieldMetadata.setName(columnName);
		}

		DatasetMetadataParser parser = new DatasetMetadataParser();
		String toReturn = parser.metadataToXML(newMetadata);
		return toReturn;
	}

	private IMetaData getDataSetMetadata(IDataSet dataset) {
		IMetaData metaData = null;
		Integer start = new Integer(0);
		Integer limit = new Integer(10);
		Integer maxSize = QbeEngineConfig.getInstance().getResultLimit();			
		try {
			dataset.loadData(start, limit, maxSize);
			IDataStore dataStore = dataset.getDataStore();
			metaData = dataStore.getMetaData();
		} catch (Exception e) {
			throw new SpagoBIRuntimeException("Error while executing dataset", e);
		}
		return metaData;
	}

	private IDataSet saveNewDataset(IDataSet newDataset) {
		DataSetServiceProxy proxy = (DataSetServiceProxy) getEnv().get( EngineConstants.ENV_DATASET_PROXY );
		logger.debug("Saving new dataset ...");
		IDataSet saved = proxy.saveDataSet(newDataset);
		logger.debug("Dataset saved without errors");
		return saved;
	}

	private IDataSetTableDescriptor persistCurrentDataset() {
		logger.debug("Retrieving working dataset ...");
		IDataSet dataset = getEngineInstance().getActiveQueryAsDataSet();
		// gets the name of the table that will contain data
		String flatTableName = getFlatTableName();
		logger.debug("Flat table name : [" + flatTableName + "]");
		IDataSource dataSource = getEngineInstance().getDataSourceForWriting();
		logger.debug("Persisting working dataset ...");
		IDataSetTableDescriptor descriptor = dataset.persist(flatTableName, dataSource);
		logger.debug("Working dataset persisted");
		return descriptor;
	}

	private String getFlatTableName() {
		logger.debug("IN");
		String persistTableName = FLAT_TABLE_NAME_PREFIX + StringUtilities.getRandomString(FLAT_TABLE_NAME_LENGHT - FLAT_TABLE_NAME_PREFIX.length());
		logger.debug("OUT : returning [" + persistTableName + "]");
		return persistTableName;
	}

}
