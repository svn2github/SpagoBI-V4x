/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package it.eng.spagobi.analiticalmodel.document.metadata;

import it.eng.spagobi.commons.metadata.SbiHibernateModel;


/**
 * SbiObjFunc generated by hbm2java
 */
public class SbiObjFunc extends SbiHibernateModel implements  Comparable {

    // Fields    

     private SbiObjFuncId id;
     private Integer prog;


    // Constructors

    /**
     * default constructor.
     */
    public SbiObjFunc() {
    }
    
    /**
     * constructor with id.
     * 
     * @param id the id
     */
    public SbiObjFunc(SbiObjFuncId id) {
        this.id = id;
    }
   
    
    

    // Property accessors

    /**
     * Gets the id.
     * 
     * @return the id
     */
    public SbiObjFuncId getId() {
        return this.id;
    }
    
    /**
     * Sets the id.
     * 
     * @param id the new id
     */
    public void setId(SbiObjFuncId id) {
        this.id = id;
    }

    /**
     * Gets the prog.
     * 
     * @return the prog
     */
    public Integer getProg() {
        return this.prog;
    }
    
    /**
     * Sets the prog.
     * 
     * @param prog the new prog
     */
    public void setProg(Integer prog) {
        this.prog = prog;
    }

	/* (non-Javadoc)
	 * @see java.lang.Comparable#compareTo(T)
	 */
	public int compareTo(Object obj2) {
		SbiObjFunc sbiObjFunc2 = (SbiObjFunc) obj2;
		String path2 = sbiObjFunc2.getId().getSbiFunctions().getPath();
		String thisPath = this.getId().getSbiFunctions().getPath();
		int folderComparison = thisPath.compareTo(path2);
		if (folderComparison == 0) {
			SbiObjects sbiObj1 = this.getId().getSbiObjects();
			SbiObjects sbiObj2 = sbiObjFunc2.getId().getSbiObjects();
			String sbiObjName1 = sbiObj1.getLabel();
			String sbiObjName2 = sbiObj2.getLabel();
			return sbiObjName1.compareTo(sbiObjName2);
		} else {
			return folderComparison;
		}

	}

}