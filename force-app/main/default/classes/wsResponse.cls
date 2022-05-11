public class JSON2Apex {

	public Request request {get;set;} 
	public Location location {get;set;} 
	public Current current {get;set;} 

	public JSON2Apex(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'request') {
						request = new Request(parser);
					} else if (text == 'location') {
						location = new Location(parser);
					} else if (text == 'current') {
						current = new Current(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Request {
		public String type {get;set;} 
		public String query {get;set;} 
		public String language {get;set;} 
		public String unit {get;set;} 

		public Request(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type = parser.getText();
						} else if (text == 'query') {
							query = parser.getText();
						} else if (text == 'language') {
							language = parser.getText();
						} else if (text == 'unit') {
							unit = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Request consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Current {
		public String observation_time {get;set;} 
		public Integer temperature {get;set;} 
		public Integer weather_code {get;set;} 
		public List<String> weather_icons {get;set;} 
		public List<String> weather_descriptions {get;set;} 
		public Integer wind_speed {get;set;} 
		public Integer wind_degree {get;set;} 
		public String wind_dir {get;set;} 
		public Integer pressure {get;set;} 
		public Integer precip {get;set;} 
		public Integer humidity {get;set;} 
		public Integer cloudcover {get;set;} 
		public Integer feelslike {get;set;} 
		public Integer uv_index {get;set;} 
		public Integer visibility {get;set;} 

		public Current(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'observation_time') {
							observation_time = parser.getText();
						} else if (text == 'temperature') {
							temperature = parser.getIntegerValue();
						} else if (text == 'weather_code') {
							weather_code = parser.getIntegerValue();
						} else if (text == 'weather_icons') {
							weather_icons = arrayOfString(parser);
						} else if (text == 'weather_descriptions') {
							weather_descriptions = arrayOfString(parser);
						} else if (text == 'wind_speed') {
							wind_speed = parser.getIntegerValue();
						} else if (text == 'wind_degree') {
							wind_degree = parser.getIntegerValue();
						} else if (text == 'wind_dir') {
							wind_dir = parser.getText();
						} else if (text == 'pressure') {
							pressure = parser.getIntegerValue();
						} else if (text == 'precip') {
							precip = parser.getIntegerValue();
						} else if (text == 'humidity') {
							humidity = parser.getIntegerValue();
						} else if (text == 'cloudcover') {
							cloudcover = parser.getIntegerValue();
						} else if (text == 'feelslike') {
							feelslike = parser.getIntegerValue();
						} else if (text == 'uv_index') {
							uv_index = parser.getIntegerValue();
						} else if (text == 'visibility') {
							visibility = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Current consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Location {
		public String name {get;set;} 
		public String country {get;set;} 
		public String region {get;set;} 
		public String lat {get;set;} 
		public String lon {get;set;} 
		public String timezone_id {get;set;} 
		public String localtime {get;set;} 
		public Integer localtime_epoch {get;set;} 
		public String utc_offset {get;set;} 

		public Location(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'region') {
							region = parser.getText();
						} else if (text == 'lat') {
							lat = parser.getText();
						} else if (text == 'lon') {
							lon = parser.getText();
						} else if (text == 'timezone_id') {
							timezone_id = parser.getText();
						} else if (text == 'localtime') {
							localtime = parser.getText();
						} else if (text == 'localtime_epoch') {
							localtime_epoch = parser.getIntegerValue();
						} else if (text == 'utc_offset') {
							utc_offset = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Location consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static JSON2Apex parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JSON2Apex(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	



    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }





}