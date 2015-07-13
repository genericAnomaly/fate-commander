import java.util.Set;

public static class JSONObjectReader {
  //Static methods for safely reading values from a JSONObject
  
  /*
  JSONObject functions to wrap
  [x] getJSONArray()        Gets the JSONArray value associated with a key
  [x] getJSONObject()       Gets the JSONObject value associated with a key
  
  
  JSONArray functions to wrap (Note these are just called on JSONObjects and a key containing an array)
  [x] getStringArray()      Gets an array at key as an array of Strings
  [x] getIntArray()         Gets an array at key as array of ints
  
  New functions
  [x] getFloatArray()       Gets an array at key as array of floats
  [x] getJSONObjectArray()  Gets an array at key as array of JSONObjects
  [x] getBoolean()          Gets a Boolean value associated with a key
  */
  
  public static JSONArray getJSONArray(JSONObject json, String key) {
    return getJSONArray(json, key, null);
  }
  
  public static JSONArray getJSONArray(JSONObject json, String key, JSONArray fallback) {
    JSONArray array;
    if (!keyPresent(json, key) ) return fallback;
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
    if (!keyPresent(json, key) ) return fallback;
    try {
      object = json.getJSONObject(key);
    } catch (Exception e) {
      println("[Exception] Failed to find a json object at key " + key + ", using fallback values");
      e.printStackTrace();
      return fallback;
    }
    return object;
  }
  
  
  public static int[] getIntArray(JSONObject json, String key, int[] fallback) {
    JSONArray array = getJSONArray(json, key, null);
    if (array == null) return fallback;
    
    int[] ints;
    try {
      ints = array.getIntArray();
    } catch (Exception e) {
      println("[Exception] getIntArray() threw an exception for the array at " + key + ", using fallback values");
      e.printStackTrace();
      return fallback;
    }
    return ints;
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
  
  
  public static Boolean getBoolean(JSONObject json, String key) {
    return getBoolean(json, key, false);
  }
  
  public static Boolean getBoolean(JSONObject json, String key, Boolean fallback) {
    int d = 0;
    if (fallback) d = 1;  
    int read = json.getInt(key, d);
    if (read == 0) return false;
    if (read == 1) return true;
    return fallback;
  }
  
  
  
  

  public static JSONArray arrayListToJSONArray(ArrayList<? extends JSONable> list) {
    JSONArray array = new JSONArray();
    int i = 0;
    for (JSONable e : list) {
      array.setJSONObject(i, e.toJSON());
      i++;
    }
    return array;
  }
  
  public static JSONArray arrayToJSONArray(JSONable[] array) {
    JSONArray jarray = new JSONArray();
    int i = 0;
    for (JSONable e : array) {
      jarray.setJSONObject(i, e.toJSON());
      i++;
    }
    return jarray;
  }
  
  /*
  //ALMOST frickin' got it but OH WHOOPS NVM TYPE ERASURE FUCK
  public static <T extends JSONable> ArrayList<T> readJSONArrayToArrayList(JSONArray array, ArrayList<T> list) {
    for (int i = 0; i < array.size(); i++) {
      JSONObject json = array.getJSONObject(i);
      //list.add( new T(json) );
    }
    return list;
  }*/
  
  
  
  public static String[] getKeyArray(JSONObject json) {
    Set keys = json.keys();
    String[] array = new String[1];
    array = (String[]) keys.toArray(array);
    return array;
  }
  
  public static Boolean keyPresent(JSONObject json, String key) {
    if ( json.keys().contains(key) ) return true;
    println("[Notice] Expected key " + key + " was not found!");
    return false;
  }
  //TODO: Update ALL the functions in here that use try-catch blocks to deal with potential missing keys to check with keyPresent first
  
}
