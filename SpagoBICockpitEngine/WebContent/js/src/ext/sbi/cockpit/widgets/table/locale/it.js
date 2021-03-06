/** SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. **/

Ext.ns("Sbi.locale");
Sbi.locale.ln = Sbi.locale.ln || new Array();



//===================================================================
//MESSAGE BOX BUTTONS
//===================================================================
Ext.Msg.buttonText.yes = 'Sì'; 
Ext.Msg.buttonText.no = 'No';


//===================================================================
//GENERAL
//===================================================================
Sbi.locale.ln['sbi.qbe.messagewin.yes'] = 'Si';
Sbi.locale.ln['sbi.qbe.messagewin.no'] = 'No';
Sbi.locale.ln['sbi.qbe.messagewin.cancel'] = 'Cancella';

Sbi.locale.ln['sbi.generic.label'] = 'Etichetta';
Sbi.locale.ln['sbi.generic.name'] = 'Nome';
Sbi.locale.ln['sbi.generic.descr'] = 'Descrizione';
Sbi.locale.ln['sbi.generic.scope'] = 'Scope';
Sbi.locale.ln['sbi.generic.scope.private'] = 'Privato';
Sbi.locale.ln['sbi.generic.scope.public'] = 'Pubblico';
Sbi.locale.ln['sbi.generic.actions.save'] = 'Salva';

Sbi.locale.ln['sbi.generic.wait'] = "Attendere prego...";
Sbi.locale.ln['sbi.generic.error'] = "Errore";
Sbi.locale.ln['sbi.generic.success'] = "Successo";
Sbi.locale.ln['sbi.generic.operationSucceded'] = "Operazione riuscita";
Sbi.locale.ln['sbi.generic.query.SQL'] = "Query SQL";
Sbi.locale.ln['sbi.generic.query.JPQL'] = "Query JPLQ";

//===================================================================
// MESSAGE WINDOW
//===================================================================
Sbi.locale.ln['sbi.qbe.messagewin.warning.title'] = 'Warning';
Sbi.locale.ln['sbi.qbe.messagewin.error.title'] = 'Messaggio di Errore';
Sbi.locale.ln['sbi.qbe.messagewin.info.title'] = 'Informazione';


//===================================================================
//SESSION EXPIRED
//===================================================================
Sbi.locale.ln['sbi.qbe.sessionexpired.msg'] = 'La sessione di lavoro è scaduta. Prova a rieseguire il documento';

//===================================================================
//DATASTORE PANEL
//===================================================================
Sbi.locale.ln['sbi.qbe.datastorepanel.title'] = 'Risultati';

Sbi.locale.ln['sbi.qbe.datastorepanel.grid.displaymsg'] = 'Visualizza {0} - {1} of {2}';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.emptymsg'] = 'Nessun risultato';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.emptywarningmsg'] = 'La query non ha restituito valori';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.beforeoverflow'] = 'Soglia massima del numero di record';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.afteroverflow'] = 'superata';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.beforepagetext'] = 'Pagina';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.afterpagetext'] = 'di {0}';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.firsttext'] = 'Prima Pagina';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.prevtext'] = 'Pagina precedente';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.nexttext'] = 'Pagina successiva';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.lasttext'] = 'Pagina successiva';
Sbi.locale.ln['sbi.qbe.datastorepanel.grid.refreshtext'] = 'Aggiorna';

Sbi.locale.ln['sbi.qbe.datastorepanel.button.tt.exportto'] = 'Esporta a';