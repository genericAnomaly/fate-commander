import java.util.Set;

public static class JSONObjectReader {
  /*
  Static methods for safely reading values from a JSONObject
  
  All JSONHelper methods will return a provided fallback or null if they encounter a missing key or type mismatch exception
  
  Simple wrappers:
      getJSONArray          Gets the JSONArray value associated with a key
      getJSONObject         Gets the JSONObject value associated with a key
  
  Two-step convenience methods equivalent to calling getJSONArray(json, key).toPrimitiveArray()
      getStringArray        Gets an array at key as an array of Strings
      getIntArray           Gets an array at key as an array of ints
      getFloatArray         Gets an array at key as an array of floats (note that there is no native JSONObject.getFloatArray() for some reason)
      getBooleanArray       Gets an array at key as an array of Booleans //TODO 
      
  Wrapper method for retrieving a Boolean value stored as an int
      getBoolean            Gets a Boolean value associated with a key
      //TODO: Consider going through and replacing this with the existing native (but inexplicably undocumented) getBoolean and setBoolean JSONObject methods
  
  to JSONArray convenience methods
      arrayListToJSONArray  Returns the JSONArray representation of the provided ArrayList<? extends JSONable>
      arrayToJSONArray      Returns the JSONArray representation of the provided JSONable[]
  
  JSONable deserialisation method
      toArrayList           Loads the provided JSONArray into an ArrayList of any JSONable implementing class provided as a factory instane 
  
  Key check methods
      getKeyArray           Returns an array of all keys in the provided JSONObject
      keyPresent            Returns true if key is present in json
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
  
  public static Boolean[] getBooleanArray(JSONObject json, String key, Boolean[] fallback) {
    if (!keyPresent(json, key) ) return fallback;
    JSONArray array = getJSONArray(json, key, null);
    if (array == null) return fallback;
    
    Boolean[] bools = new Boolean[array.size()];;
    for (int i=0; i < bools.length; i++) {
      try {
         bools[i] = array.getBoolean(i);
      } catch (Exception e) {
        println("[Exception] getBoolean() threw an exception for the value at " + key + "[" + i + "], using fallback values");
        return fallback;
      }
    }
    return bools;
  }
  
  /*
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
  */
  
  
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
  
  
  
  
  
  

  
  /*
  public static JSONArray primitiveArrayToJSONArray(Object[] prims) {
    JSONArray array = new JSONArray();
    for (int i = 0; i < prims.length; i++) {
      if (prims[i] instanceof Integer) array.setInt(i, (Integer) prims[i]);
      if (prims[i] instanceof Float)   array.setFloat(i, (Float) prims[i]);
      if (prims[i] instanceof Boolean) array.setBoolean(i, (Boolean) prims[i]);
      if (prims[i] instanceof String)  array.setString(i, (String) prims[i]);
    }
    return array;
  }*/
  //That doesn't work because of float/Float int/Integer

  public static JSONArray floatArrayToJSONArray(float[] in) {
    JSONArray array = new JSONArray();
    for (int i = 0; i < in.length; i++) array.setFloat(i, in[i]);
    return array;
  }
  public static JSONArray intArrayToJSONArray(int[] in) {
    JSONArray array = new JSONArray();
    for (int i = 0; i < in.length; i++) array.setInt(i, in[i]);
    return array;
  }
  public static JSONArray booleanArrayToJSONArray(Boolean[] in) {
    JSONArray array = new JSONArray();
    for (int i = 0; i < in.length; i++) array.setBoolean(i, in[i]);
    return array;
  }
  public static JSONArray stringArrayToJSONArray(String[] in) {
    JSONArray array = new JSONArray();
    for (int i = 0; i < in.length; i++) array.setString(i, in[i]);
    return array;
  }
  
  
  
}
