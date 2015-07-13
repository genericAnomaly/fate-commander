import java.util.Set;

public static class JSONObjectReader {
  //Static methods for safely reading values from a JSONObject
  
  /*
  Wrappers:
  Wraps the following existing JSONObject functions with code to return a fallback value when dealing with missing keys and other exceptions
  [x] getJSONArray()        Gets the JSONArray value associated with a key
  [x] getJSONObject()       Gets the JSONObject value associated with a key
  
  Two-step convenience methods; first pull the JSONArray at key in json, then wrap its built-in toPrimitiveArray functions. Returns fallback value if key missing or exception thrown
  [x] getStringArray()      Gets an array at key as an array of Strings
  [x] getIntArray()         Gets an array at key as array of ints
  
  New:
  //Mimic getPrimitiveArray function above but for floats, which don't have a built in getFloatArray function 
  [x] getFloatArray()       Gets an array at key as array of floats
  //Reads in a Boolean saved as an int
  [x] getBoolean()          Gets a Boolean value associated with a key
  
  //TODO document that new junk
  */
  
  
  
  
  
  //Helper: Retrieve a JSONArray object from a JSONObject and fallback to either null or a provided fallback value if something goes wrong
  //======================================================================================================================================
  public static JSONArray getJSONArray(JSONObject json, String key) {
    return getJSONArray(json, key, null);
  }
  public static JSONArray getJSONArray(JSONObject json, String key, JSONArray fallback) {
    if (!keyPresent(json, key) ) return fallback;
    JSONArray array;
    try {
      array = json.getJSONArray(key);
    } catch (Exception e) {
      println("[Exception] Failed to find a JSONArray at key " + key + ", using fallback values");
      e.printStackTrace();
      return fallback;
    }
    return array;
  }
  
  
  //Helper: Retrieve a JSONObject object from a JSONObject and fallback to either null or a provided fallback value if something goes wrong
  //======================================================================================================================================
  public static JSONObject getJSONObject(JSONObject json, String key) {
    return getJSONObject(json, key, null);
  }
  public static JSONObject getJSONObject(JSONObject json, String key, JSONObject fallback) {
    if (!keyPresent(json, key) ) return fallback;
    JSONObject object;
    try {
      object = json.getJSONObject(key);
    } catch (Exception e) {
      println("[Exception] Failed to find a JSONObject at key " + key + ", using fallback values");
      e.printStackTrace();
      return fallback;
    }
    return object;
  }
  
  
  //Helpers: Retrieve arrays of primitives from a JSONObject w/ built-in fallback 
  //======================================================================================================================================
  public static int[] getIntArray(JSONObject json, String key, int[] fallback) {
    if (!keyPresent(json, key) ) return fallback;
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
    if (!keyPresent(json, key) ) return fallback;
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
    if (!keyPresent(json, key) ) return fallback;
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
  
  
  //Helper: Retrieve Booleans stored as ints
  //======================================================================================================================================
  public static Boolean getBoolean(JSONObject json, String key) {
    return getBoolean(json, key, false);
  }
  public static Boolean getBoolean(JSONObject json, String key, Boolean fallback) {
    if (!keyPresent(json, key) ) return fallback;
    int d = 0;
    if (fallback) d = 1;  
    int read = json.getInt(key, d);
    if (read == 0) return false;
    if (read == 1) return true;
    return fallback;
  }
  
  
  //Helpers: JSONable Collections -> JSONArray
  //======================================================================================================================================
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
  
  
  //Helper: JSONArray -> ArrayList<T extends JSONable>
  //======================================================================================================================================
  public static <T extends JSONable> ArrayList<T> toArrayList(JSONArray array, T factory) {
    //Reads in a JSONArray to an ArrayList of any JSONable implementing class T
    ArrayList<T> list = new ArrayList<T>();
    if (array == null || factory == null) return list; 
    for (int i = 0; i < array.size(); i++) {
      JSONObject json = array.getJSONObject(i);
      list.add( (T) factory.construct(json) );
    }
    return list;
  }
  
  
  //Helpers: Key awareness on a JSONObject
  //======================================================================================================================================
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
