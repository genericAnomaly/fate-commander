public static class JSONObjectReader {
  //Static methods for safely reading values from a JSONObject
  
  /*
  JSONObject functions to wrap
  getJSONArray()   Gets the JSONArray value associated with a key
  getJSONObject()  Gets the JSONObject value associated with a key
  
  JSONArray functions to wrap
  getStringArray()      Gets the entire array as an array of Strings
  getIntArray()         Gets the entire array as array of ints
  getFloatArray()       <Unimplemented>
  getJSONObjectArray()  <Unimplemented>
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
  
  
  public static JSONObject getJSONObject(JSONObject json, String key) {
    return getJSONObject(json, key, null);
  }
  
  public static JSONObject getJSONObject(JSONObject json, String key, JSONObject fallback) {
    JSONObject object;
    try {
      object = json.getJSONObject(key);
    } catch (Exception e) {
      println("[Exception] Failed to find a json object at key " + key + ", using fallback values");
      e.printStackTrace();
      return fallback;
    }
    return object;
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
    
    float[] floats = new float[array.size()];;
    for (int i=0; i < floats.length; i++) {
      try {
         floats[i] = array.getFloat(i);
      } catch (Exception e) {
        println("[Exception] getFloat() threw an exception for the value at " + key + "[" + i + "], using fallback values");
        return fallback;
      }
    }
    return floats;
  }
  
  /*
  public static <T> ArrayList<T> getGenericArrayList(JSONObject json, String key) {
    JSONArray array = getJSONArray(json, key);
    ArrayList<T> list = new ArrayList<T>(array.size());
    //I didn't think this through, it /almost/ works but the CommanderDocument can't be passed to any Ts this creates :/
    //Learned a bit about generics though, that's a plus 
    return list;
  }
  */
  
  public static JSONObject[] getJSONObjectArray(JSONObject json, String key) {
    return getJSONObjectArray(json, key, null);
  }
  
  public static JSONObject[] getJSONObjectArray(JSONObject json, String key, JSONObject[] fallback) {
    JSONArray array = getJSONArray(json, key, null);
    if (array == null) return fallback;
    JSONObject[] objects = new JSONObject[array.size()];;
    for (int i=0; i < objects.length; i++) {
      try {
         objects[i] = array.getJSONObject(i);
      } catch (Exception e) {
        println("[Exception] getJSONObect() threw an exception for the value at " + key + "[" + i + "], using fallback values");
        return fallback;
      }
    }
    return objects;
  }
  
  
}
