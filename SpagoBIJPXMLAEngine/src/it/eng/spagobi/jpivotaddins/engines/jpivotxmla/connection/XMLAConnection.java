/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package it.eng.spagobi.jpivotaddins.engines.jpivotxmla.connection;

import it.eng.spago.base.SourceBean;

/**
 * @author Andrea Gioia
 *
 */
public class XMLAConnection implements IConnection {
	private String name;
	private int type;
	private String xmlaServerUrl;
	
	public XMLAConnection(SourceBean connSb) {
		name = (String)connSb.getAttribute("name");
		type = XMLA_CONNECTION;
		xmlaServerUrl = (String)connSb.getAttribute("xmlaServerUrl");
	}

	public String getName() {
		return name;
	}

	public String getXmlaServerUrl() {
		return xmlaServerUrl;
	}

	public int getType() {
		return type;
	}
}
