/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package it.eng.spagobi.commons.initializers.metadata;

import it.eng.spago.base.SourceBean;
import it.eng.spago.init.InitializerIFace;
import it.eng.spagobi.behaviouralmodel.check.metadata.SbiChecks;
import it.eng.spagobi.behaviouralmodel.lov.metadata.SbiLov;
import it.eng.spagobi.commons.SingletonConfig;
import it.eng.spagobi.commons.dao.AbstractHibernateDAO;
import it.eng.spagobi.commons.metadata.SbiConfig;
import it.eng.spagobi.commons.metadata.SbiDomains;
import it.eng.spagobi.commons.metadata.SbiUserFunctionality;
import it.eng.spagobi.engines.config.metadata.SbiEngines;
import it.eng.spagobi.engines.config.metadata.SbiExporters;
import it.eng.spagobi.engines.config.metadata.SbiExportersId;
import it.eng.spagobi.kpi.config.metadata.SbiKpiPeriodicity;
import it.eng.spagobi.kpi.ou.metadata.SbiOrgUnitGrant;
import it.eng.spagobi.utilities.exceptions.SpagoBIRuntimeException;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.xml.sax.InputSource;

/**
 * @author Zerbetto (davide.zerbetto@eng.it)
 * 
 * This class initializes SpagoBI metadata repository, if it is empty, with predefined: 
 * 
 * 	- domains, 
 * 	- checks, 
 * 	- lovs, 
 * 	- engines, 
 * 	- user functionalities
 **/
public class MetadataInitializer extends SpagoBIInitializer {
	
	List<SpagoBIInitializer> metadataInitializers;
	
	static private boolean disposed = false;
	static private Logger logger = Logger.getLogger(MetadataInitializer.class);

	public MetadataInitializer() {
		targetComponentName = "SpagoBI Metadata Database";
		
		metadataInitializers = new ArrayList<SpagoBIInitializer>();
		metadataInitializers.add( new TenantsInitializer() );
		metadataInitializers.add( new DomainsInitializer() );
		metadataInitializers.add( new EnginesInitializer() );
		metadataInitializers.add( new ChecksInitializer() );		
		metadataInitializers.add( new LovsInitializer() );
		metadataInitializers.add( new FunctionalitiesInitializer() );
		metadataInitializers.add( new ExportersInitializer() );		
		metadataInitializers.add( new ConfigurationsInitializer() );
		metadataInitializers.add( new KpiPeriodicityInitializer() );
		metadataInitializers.add( new UnitGrantInitializer() );		
	}
	
	public void init(SourceBean config) {
		if(disposed) {
			logger.warn("[" + targetComponentName + "] hsa been already initialized");
		} else {
			super.init(config);
			disposed = true;
		}	
	}
	
	public void init(SourceBean config, Session hibernateSession) {
		
		long startTime;
		long endTime;
		
		logger.debug("IN");
		
		try {
			for(SpagoBIInitializer metadataInitializer : metadataInitializers) {
				startTime = System.currentTimeMillis();
				metadataInitializer.init(config, hibernateSession);
				endTime = System.currentTimeMillis();
				logger.info("[" + metadataInitializer.getTargetComponentName() + "] succesfully initializated in " + (endTime - startTime) + " ms");
			}
		} catch (Throwable t) {
			logger.error("An unexpected error occured while initializing metadata", t);
		} finally {
			logger.debug("OUT");
		}
	}
}
