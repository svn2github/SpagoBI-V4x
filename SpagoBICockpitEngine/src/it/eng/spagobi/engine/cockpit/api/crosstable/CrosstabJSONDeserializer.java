package it.eng.spagobi.engine.cockpit.api.crosstable;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import it.eng.qbe.serializer.IDeserializer;
import it.eng.qbe.serializer.SerializationException;
import it.eng.qbe.serializer.SerializationManager;
import it.eng.spagobi.utilities.assertion.Assert;
import it.eng.spagobi.engine.cockpit.api.crosstable.CrosstabDefinition;
import it.eng.spagobi.engine.cockpit.api.crosstable.CrosstabDefinition.Column;
import it.eng.spagobi.engine.cockpit.api.crosstable.CrosstabDefinition.Row;

public class CrosstabJSONDeserializer implements IDeserializer {
public static transient Logger logger = Logger.getLogger(CrosstabJSONDeserializer.class);
    
	public CrosstabDefinition deserialize(Object o) throws SerializationException {
		CrosstabDefinition crosstabDefinition = null;
		JSONObject crosstabDefinitionJSON = null;
		
		logger.debug("IN");
		
		try {
			Assert.assertNotNull(o, "Object to be deserialized cannot be null");
			
			if(o instanceof String) {
				logger.debug("Deserializing string [" + (String)o + "]");
				try {
					crosstabDefinitionJSON = new JSONObject( (String)o );
				} catch(Throwable t) {
					logger.debug("Object to be deserialized must be string encoding a JSON object");
					throw new SerializationException("An error occurred while deserializing query: " + (String)o, t);
				}
			} else if(o instanceof JSONObject) {
				crosstabDefinitionJSON = (JSONObject)o;
			} else {
				Assert.assertUnreachable("Object to be deserialized must be of type string or of type JSONObject, not of type [" + o.getClass().getName() + "]");
			}
			
			crosstabDefinition  = new CrosstabDefinition();
			
			try {
				deserializeRows(crosstabDefinitionJSON, crosstabDefinition);
				deserializeColumns(crosstabDefinitionJSON, crosstabDefinition);
				deserializeMeasures(crosstabDefinitionJSON, crosstabDefinition);
				
				// config (measures on rows/columns, totals/subototals on rows/columns) remains a JSONObject 
				JSONObject config = crosstabDefinitionJSON.optJSONObject(CrosstabSerializationConstants.CONFIG);
				crosstabDefinition.setConfig(config);
				
				String maxCellsString= config.optString("maxcellnumber");
				
				if (maxCellsString!=null && !maxCellsString.equals("")){
					try {
						crosstabDefinition.setCellLimit(new Integer(maxCellsString));
					} catch (Exception e) {
						logger.error("The cell limit of the crosstab definition is not a number : "+maxCellsString+". We consier it 0");
					}
					
				}
				
				JSONArray calculatedFields = crosstabDefinitionJSON.optJSONArray(CrosstabSerializationConstants.CALCULATED_FIELDS);
				crosstabDefinition.setCalculatedFields(calculatedFields);
				
				JSONObject additionalData = crosstabDefinitionJSON.optJSONObject(CrosstabSerializationConstants.ADDITIONAL_DATA);
				crosstabDefinition.setAdditionalData(additionalData);
				
			} catch (Exception e) {
				throw new SerializationException("An error occurred while deserializing query: " + crosstabDefinitionJSON.toString(), e);
			}

		} finally {
			logger.debug("OUT");
		}
		
		return crosstabDefinition;
	}
	
	private void deserializeRows(JSONObject crosstabDefinitionJSON, CrosstabDefinition crosstabDefinition) throws Exception {
		List<Row> rows = new ArrayList<Row>();
		JSONArray rowsJSON = crosstabDefinitionJSON.optJSONArray(CrosstabSerializationConstants.ROWS);
		
		AttributeJSONDeserializer attributeJSONDeserializer =(AttributeJSONDeserializer) AttributeDeserializerFactory.getInstance().getDeserializer("application/json");
		
		//Assert.assertTrue(rows != null && rows.length() > 0, "No rows specified!");
		if (rowsJSON != null) {
			for (int i = 0; i < rowsJSON.length(); i++) {
				JSONObject obj = (JSONObject) rowsJSON.get(i);
				Attribute attribute = (Attribute) attributeJSONDeserializer.deserialize(obj);
				rows.add(crosstabDefinition.new Row(attribute));
			}
		}
		crosstabDefinition.setRows(rows);
	}
	
	private void deserializeMeasures(JSONObject crosstabDefinitionJSON, CrosstabDefinition crosstabDefinition) throws Exception {
		List<Measure> measures = new ArrayList<Measure>();
		JSONArray measuresJSON = crosstabDefinitionJSON.optJSONArray(CrosstabSerializationConstants.MEASURES);
		
		MeasureJSONDeserializer measureJSONDeserializer =(MeasureJSONDeserializer) MeasureDeserializerFactory.getInstance().getDeserializer("application/json");
		
		//Assert.assertTrue(rows != null && rows.length() > 0, "No measures specified!");
		if (measuresJSON != null) {
			for (int i = 0; i < measuresJSON.length(); i++) {
				JSONObject obj = (JSONObject) measuresJSON.get(i);
				Measure measure = (Measure) measureJSONDeserializer.deserialize(obj);
				measures.add(measure);
			}
		}
		crosstabDefinition.setMeasures(measures);
	}
	
	private void deserializeColumns(JSONObject crosstabDefinitionJSON, CrosstabDefinition crosstabDefinition) throws Exception {
		List<Column> columns = new ArrayList<Column>();
		JSONArray columnsJSON = crosstabDefinitionJSON.optJSONArray(CrosstabSerializationConstants.COLUMNS);
		//Assert.assertTrue(rows != null && rows.length() > 0, "No columns specified!");
		if (columnsJSON != null) {
			for (int i = 0; i < columnsJSON.length(); i++) {
				JSONObject obj = (JSONObject) columnsJSON.get(i);
				Attribute attribute = (Attribute) SerializationManager.deserialize(obj, "application/json", Attribute.class);
				columns.add(crosstabDefinition.new Column(attribute));
			}
		}
		crosstabDefinition.setColumns(columns);
	}
}
