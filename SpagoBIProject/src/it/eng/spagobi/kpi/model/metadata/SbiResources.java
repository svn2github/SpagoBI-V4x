/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package it.eng.spagobi.kpi.model.metadata;
// Generated 5-nov-2008 17.17.20 by Hibernate Tools 3.1.0 beta3

import it.eng.spagobi.commons.metadata.SbiDomains;
import it.eng.spagobi.commons.metadata.SbiHibernateModel;

import java.util.HashSet;
import java.util.Set;


/**
 * SbiResources generated by hbm2java
 */

public class SbiResources  extends SbiHibernateModel {


    // Fields    

     private Integer resourceId;
     private SbiDomains type;
     private String tableName;
     private String columnName;
     private String resourceName;
     private String resourceDescr;
     private String resourceCode;
     private Set sbiKpiValues = new HashSet(0);
     private Set sbiKpiModelResourceses = new HashSet(0);


    // Constructors

    /** default constructor */
    public SbiResources() {
    }

	/** minimal constructor */
    public SbiResources(Integer resourceId, SbiDomains sbiDomains) {
        this.resourceId = resourceId;
        this.type = sbiDomains;
    }
    
    /** full constructor */
    public SbiResources(Integer resourceId, SbiDomains sbiDomains, String tableName, String columnName, String resourceName, String resourceDescr, Set sbiKpiValues, Set sbiKpiModelResourceses) {
        this.resourceId = resourceId;
        this.type = sbiDomains;
        this.tableName = tableName;
        this.columnName = columnName;
        this.resourceName = resourceName;
        this.resourceDescr = resourceDescr;
        this.sbiKpiValues = sbiKpiValues;
        this.sbiKpiModelResourceses = sbiKpiModelResourceses;
    }
    

   
    // Property accessors

    public Integer getResourceId() {
        return this.resourceId;
    }
    
    public void setResourceId(Integer resourceId) {
        this.resourceId = resourceId;
    }

    public SbiDomains getType() {
        return this.type;
    }
    
    public void setType(SbiDomains sbiDomains) {
        this.type = sbiDomains;
    }

    public String getTableName() {
        return this.tableName;
    }
    
    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getColumnName() {
        return this.columnName;
    }
    
    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getResourceName() {
        return this.resourceName;
    }
    
    public void setResourceName(String resourceName) {
        this.resourceName = resourceName;
    }

    public Set getSbiKpiValues() {
        return this.sbiKpiValues;
    }
    
    public void setSbiKpiValues(Set sbiKpiValues) {
        this.sbiKpiValues = sbiKpiValues;
    }

    public Set getSbiKpiModelResourceses() {
        return this.sbiKpiModelResourceses;
    }
    
    public void setSbiKpiModelResourceses(Set sbiKpiModelResourceses) {
        this.sbiKpiModelResourceses = sbiKpiModelResourceses;
    }

	public String getResourceDescr() {
		return resourceDescr;
	}

	public void setResourceDescr(String resourceDescr) {
		this.resourceDescr = resourceDescr;
	}
	
	public String getResourceCode() {
		return resourceCode;
	}

	public void setResourceCode(String resourceCode) {
		this.resourceCode = resourceCode;
	}
   
}
