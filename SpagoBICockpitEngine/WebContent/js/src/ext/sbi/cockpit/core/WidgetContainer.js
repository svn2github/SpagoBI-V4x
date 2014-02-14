/** SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. **/

Ext.ns("Sbi.cockpit.core");

Sbi.cockpit.core.WidgetContainer = function(config) {
	
	this.validateConfigObject(config);
	this.adjustConfigObject(config);
	
	
	// init properties...
	var defaultSettings = {
		// set default values here
	};
	
	var settings = Sbi.getObjectSettings('Sbi.cockpit.core', defaultSettings);
	
	var c = Ext.apply(settings, config || {});
	Ext.apply(this, c);
	
	this.regions = {};

	// constructor
	Sbi.cockpit.core.WidgetContainer.superclass.constructor.call(this, c);
};

/**
 * @class Sbi.cockpit.core.WidgetContainer
 * @extends Ext.util.Observable
 * 
 * bla bla bla bla bla ...
 */

/**
 * @cfg {Object} config
 * ...
 */
Ext.extend(Sbi.cockpit.core.WidgetContainer, Sbi.cockpit.core.Widget, {
    
	// =================================================================================================================
	// PROPERTIES
	// =================================================================================================================
	
	/**
     * @property {Sbi.cockpit.core.WidgetManager} widgetManager
     * The container that manages the all the widgets rendered within this panel
     */
	widgetManager: null

  /**
   * @property {Ext.Window} widgetEditor
   * The wizard that manages the single widget definition
   */
  , widgetEditor: null
	 
	// =================================================================================================================
	// METHODS
	// =================================================================================================================
		
	/**
	 * @method 
	 * 
	 * Controls that the configuration object passed in to the class constructor contains all the compulsory properties. 
	 * If it is not the case an exception is thrown. Use it when there are properties necessary for the object
	 * construction for whom is not possible to find out a valid default value.
	 * 
	 * @param {Object} the configuration object passed in to the class constructor
	 * 
	 * @return {Object} the config object received as input
	 */
	, validateConfigObject: function(config) {

	}

	/**
	 * @method 
	 * 
	 * Modify the configuration object passed in to the class constructor adding/removing properties. Use it for example to 
	 * rename a property or to filter out not necessary properties.
	 * 
	 * @param {Object} the configuration object passed in to the class constructor
	 * 
	 * @return {Object} the modified version config object received as input
	 * 
	 */
	, adjustConfigObject: function(config) {
		if(config.widgetManager === undefined) {
			config.widgetManager = new Sbi.cockpit.core.WidgetManager({storeManager: config.storeManager});
			if(config.storeManager) {
				delete config.storeManager;
			}
		}
			
		if(config.items !== undefined) {
			config.widgetManager.register(config.items);
			delete config.items;
		}	
	}
    
	// -----------------------------------------------------------------------------------------------------------------
    // public methods
	// -----------------------------------------------------------------------------------------------------------------
	
    , addWidget: function(widget, region) {	

		Sbi.trace("[WidgetContainer.addWidget]: IN");
    	
    	if(!widget) {
    		Sbi.trace("[WidgetContainer.addWidget]: Widget is not valorized. An empty componnt will be created in the specified region");	
    	} else if( (widget instanceof Sbi.cockpit.core.Widget) === false) {
    		if(typeof widget === 'object' && !(widget instanceof Ext.util.Observable) === false) {
    			Sbi.trace("[WidgetContainer.addWidget]: The passed in parameter is a widget configuration object");	
    			widget = Sbi.cockpit.core.WidgetExtensionPoint.getWidget(widget.wtype, widget);
    		} else {
    			Sbi.error("[WidgetContainer.addWidget]: The passed in parameter is not valid");	
    		}
    	} else {
    		Sbi.trace("[WidgetContainer.addWidget]: The passed in widget object will be added to a new component placed in the specified region");	
    	}
    	
    	if(widget) {
    		this.widgetManager.register(widget);
    	}
    	
    	var component = this.addComponent(widget, region);
    	
		
		
		
		Sbi.trace("[WidgetContainer.addWidget]: OUT");
	}
    
    , getWidgetRegion: function(component) {
    	return this.regions[component.id];
    }
    
    , setComponentRegion: function(component, region) {
    	this.regions[component.id] = region;
    }
    
    , getWidgetManager: function() {
    	return this.widgetManager;
    }
    
    /**
     * TODO: integrate ace-extjs editor to have the configuration not only pretty printed 
     * but also highlighted
     */
    , showWidgetConfiguration: function(component) {
    	
    	Sbi.trace("[WidgetContainer.showWidgetConfiguration]: IN");
    	
    	if( Sbi.isNotValorized(component) ) {
    		Sbi.trace("[WidgetContainer.showWidgetConfiguration]: component not defined");
    	}
    	
    	var widget = component.getWidget();
    	if(widget) {
    		// to be sure to have the conf pretty printed also on old browser that dont support
        	// JSON object natively it is possible to include json2.jd by Douglas Crockford (
        	// https://github.com/douglascrockford/JSON-js)
        	var confStr = (typeof JSON === 'object')
        					? JSON.stringify(widget.getConfiguration(), null, 2)
        					: Ext.util.JSON.encode(widget.getConfiguration());
        	    		
        		
        	
        	var win = new Ext.Window({
        		id: 'configuration',
                layout:'fit',
                width:500,
                height:300,
                //closeAction:'hide',
                plain: true,
                title: "Widget [" + widget.id + "] configuration",
                items: new Ext.form.TextArea({
                	border: false
                	, value: confStr
                    , name: 'configuration'
                }),

                buttons: [
//              {
//                	text:'Copy to clipboard',
//                  	handler: function(){
//                    		...
//                		}
//              },
                {
                	text: 'Close',
                    handler: function(){
                    	win.close();
                    }
                }]
            });
        	win.show();
    	} else {
    		alert("widget not defined");
    	}
    	
    	
    	
    	Sbi.trace("[WidgetContainer.showWidgetConfiguration]: OUT");
    }
    
    
    , showWidgetEditor: function(component) {    	
    	
    	Sbi.trace("[WidgetContainer.showWidgetEditor]: IN");
    	
    	if(this.widgetEditor === null) {
    		
    		Sbi.trace("[WidgetContainer.showWidgetEditor]: instatiating the editor");

    		this.widgetEditor = new Sbi.cockpit.editor.WidgetEditorWizard();
    		
	    	Sbi.trace("[WidgetContainer.showWidgetEditor]: editor succesfully instantiated");
    	}
    	
    	//this.widgetEditor.setTitle("Widget [" + widget.id + "] editor");
    	this.widgetEditor.setUsedDatasets(this.getWidgetManager().getUsedStoreLabels());
    	this.widgetEditor.setWizardTargetComponent(component);
    	
    	
    	this.widgetEditor.show();
    	
    	Sbi.trace("[WidgetContainer.showWidgetEditor]: OUT");
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    // private methods
	// -----------------------------------------------------------------------------------------------------------------
	
//    , onRender: function(ct, position) {	
//    	Sbi.trace("[WidgetContainer.onRender]: IN");
//    	
//		Sbi.cockpit.core.WidgetContainer.superclass.onRender.call(this, ct, position);
//	
//		this.clearContent();
//		this.renderContent();
//		Sbi.trace("[WidgetContainer.onRender]: OUT");
//	}
//     
//    , clearContent: function() {
//    	 this.items.each( function(item) {
// 			this.items.remove(item);
// 	        item.destroy();           
// 	    }, this); 
//    }
//    
//    , renderContent: function() {
//    	var widgets = this.widgetManager.getWidgets();
//		widgets.each(function(widget, index, length) {
//			this.addComponent(widget);
//		}, this);	
//    }
    
   
    , addComponent: function(widget, region) {
    	
    	Sbi.trace("[WidgetContainer.addComponent]: IN");
    	
    	var componentConf = {};
    	if(widget) {
    		componentConf.widget = widget;
    	}
    	
    	if( Sbi.isNotValorized(region) ) {
    		region = {
        		width : 0.5
        	   	, height : 0.5
        	   	, x : '50%'
        	   	, y: '50%'
        	};
    		this.regions[widget.id] = region;
    	}
    	
    	Sbi.trace("[WidgetContainer.addComponent]: region is equal to: [" + Sbi.toSource(region) + "]");
    	
    	Ext.apply(componentConf, region);
    	
    	var vpSize = Ext.getBody().getViewSize();
    	componentConf.width = Math.ceil(vpSize.width * componentConf.width);
    	componentConf.height = Math.ceil(vpSize.height * componentConf.height);
    	
    	var component = new Sbi.cockpit.core.WidgetContainerComponent(componentConf);
    	
    	component.on('move', this.onComponentMove, this);
    	component.on('resize', this.onComponentResize, this);
    	component.on("performaction", this.onComponentAction, this);
    	
    	this.components = this.components || new Array();
    	this.components.push(component);
    	component.setParentContainer(this);
    	
    	this.regions[component.id] = region;
    	
    	if(widget) {
    		widget.setParentComponent(component);
    	}
    	
    	component.show();
    	
    	Sbi.trace("[WidgetContainer.addComponent]: OUT");
    	
    	return component;
    }
    
    , onShowWidgetConfiguration: function(widget) {
    	this.showWidgetConfiguration(widget);
    	//Ext.Msg.alert('Message', 'The CONFIG tool was clicked.');
    } 
    
    , onShowWidgetEditor: function(component) {
    	this.showWidgetEditor(component);
    	//Ext.Msg.alert('Message', 'The CONFIG tool was clicked.');
    } 
    
//    , onCloseWidgetEditor: function(){
//    	this.widgetEditor.resetState();
//    	this.widgetEditor.hide();
//    }
 
    , defineTemplate: function(wEditor){
    	Sbi.trace("[WidgetContainer.defineTemplate]: IN");

    	//gets the containerComponent to update  (is Dummy for default)
    	var myWidget = this.components[0];
    	var newWidget = myWidget;
    	//Recupero della tipologia : 
    	//si potrebbe ottimizzare  sfruttando l'evento drug dalla palette?
    	var editor = wEditor.getComponent(1).getComponent(1);
    	var widgetEditorMainPanel = editor.getComponent(0);
    	var designer = widgetEditorMainPanel.getComponent(0);  
//
//	    if (designer instanceof Sbi.cockpit.widgets.table.TableWidgetDesigner){
//	    	//gets informations about table widget
//	    	var state = designer.getFormState();
////	    	newWidget = new Sbi.cockpit.widgets.table.TableWidget(); NO PERCH� E? IL  RUNTIME
//	    	if (newWidget.setFormState)
//	    		newWidget.setFormState(state);
//	    	
//	    }
	    
//	    myWidget.setWidget(newWidget);
	    
//	    var template = (typeof JSON === 'object')
//		? JSON.stringify(myWidget.getCustomConfiguration(), null, 2)
//		: Ext.util.JSON.encode(myWidget.getCustomConfiguration());
    	
		var state = {};
    	state.fields =  designer.getFormState().visibleselectfields || [];
    	state.type = 'Table';
		var template = (typeof JSON === 'object')
		? JSON.stringify(state, null, 2)
		: Ext.util.JSON.encode(state);
		
		alert(template);
	    	
	    Sbi.trace("[WidgetContainer.defineTemplate]: OUT");
	    return template;
    }
    
    , onComponentMove: function(component){
    	Sbi.trace("[WidgetContainer.onComponentMove]: IN");
    
    	var r = this.getRegion();
    	
    	r.x = component.getPosition()[0];
    	r.y = component.getPosition()[1];
		
		this.setComponentRegion(component, r);
		
		Sbi.trace("[WidgetContainer.onComponentMove]: OUT");
    	
    }
    
    , onComponentResize: function(component){
    	//refresh size informations of region obj
    	Sbi.trace("[WidgetContainer.onComponentResize]: IN");
    	
    	var r =  this.getRegion();
    	r.width = component.getWidth();
    	r.height = component.getHeight();
    	
    	if (Sbi.settings.cockpit && Sbi.settings.cockpit.layout && 
    			Sbi.settings.cockpit.layout.useRelativeDimensions == true){
    		//get realtive dimensions if necessary
    		var vpSize = Ext.getBody().getViewSize();
	    	var newW = ((100*c.getWidget().getWidth()) / vpSize.width)/100;
			var newH = ((100*c.getWidget().getHeight()) / vpSize.height)/100;
	    	r.width = Ext.util.Format.number(newW, '0.00');
	    	r.height =Ext.util.Format.number(newH, '0.00');
    	}
    	
		this.setComponentRegion(component,r);
		
		Sbi.trace("[WidgetContainer.onComponentResize]: OUT");
    }
    
    , onComponentAction: function(component, action) {
    	Sbi.trace("[WidgetContainer.onComponentAction]: IN");
		
    	if(!component) {
    		Sbi.warn("[WidgetContainer.onComponentAction]: component not defined");
    	}
    	
    	if(action === 'showEditor') {
			this.showWidgetEditor(component);
		} else if(action === 'showConfiguration') {
			this.showWidgetConfiguration(component);
		} else {
			Sbi.warn("[WidgetContainer.onComponentAction]: action [" + action + "] not recognized");
		}
		Sbi.trace("[WidgetContainer.onComponentAction]: OUT");
	}
}); 