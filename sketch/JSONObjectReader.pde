public static class JSONObjectReader {
  //Static methods for safely reading values from a JSONObject
  
  /*
  JSONObject functions to wrap
  getJSONArray()   Gets the JSONArray value associated with a key
  getJSONObject()  Gets the JSONObject value associated with a key
  
  JSONArray functions to wrap
  getStringArray()  Gets the entire array as an array of Strings
  getIntArray()     Gets the entire array as array of ints
  getFloatArray()   <Unimplemented>
  */
  
  public static JSONArray getJSONArray(JSONObject json, String key) {
    return getJSONArray(json, key, null);
  }
  
  public static JSONArray getJSONArray(JSONObject json, String key, JSONArray fallback) {
    JSONArray array;
    try {
      array = json.getJSONArray(key);
    } catch (Exception e) {
      println("[Exception] Failed to find an array at key " + key + ", using fallback values");
      e.printStackTrace();
      return fallback;
    }
    return array;
  }
  
  
  public static String[] getStringArray(JSONObject json, String key, String[] fallback) {
    JSONArray array = getJSONArray(json, key, null);
    if (array == null) return fallback;
    
    String[] strings;
    try {
      strings = array.getStringArray();
    } catch (Exception e) {
      println("[Exception] getStringArray() threw an exception for the array at " + key + ", using fallback values");
      e.printStackTrace();
      return fallback;
    }
    return strings;
  }
  
  
  public static float[] getFloatArray(JSONObject json, String key, float[] fallback) {
    JSONArray array = getJSONArray(json, key, null);
    if (array == null) return fallback;
    
    float[] floats;
    try {
      floats = new float[array.size()];
      for (int i=0; i < floats.length; i++) floats[i] = array.getFloat(i);
    } catch (Exception e) {
      println("[Exception] getFloat() threw an exception for the value at " + key + "[" + i + "], using fallback values");
      return fallback;
    }
    return floats;
  }
  
  
  
}
