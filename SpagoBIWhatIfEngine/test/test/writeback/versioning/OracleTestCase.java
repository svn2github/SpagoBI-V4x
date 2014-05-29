/**
 * 
 */
package test.writeback.versioning;

import test.writeback.TestConstants;
import it.eng.spagobi.tools.datasource.bo.DataSource;



/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * @author ghedin
 *
 */
public class OracleTestCase extends AbstractVersionManagerTestCase {


	
	public String getCatalogue(){
		
		return "\\test\\test\\writeback\\\resources\\FoodMartOracleSQLTest.xml";
	}
	

	

	

}
