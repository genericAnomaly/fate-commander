public class CommanderDocument {
  String name;
  Settings settings;
  ArrayList<Actor> actorList;
  ArrayList<Location> locationList;
  
  
  public CommanderDocument() {
    //TODO: Constructor stub
    init();
  }
  
  public CommanderDocument(JSONObject json) {
    //TODO: Constructor stub
    init();
    loadJSON(json);
    //TODO: if loadJSON returns false, inform the user. I think this is actually the right time to use throwing exceptions? Dunno, research it.
  }
  
  private void init() {
    //Initialise this document with the default values
    name = "Untitled Fate Commander Document";
    settings = new Settings();
    actorList = new ArrayList<Actor>();
    locationList = new ArrayList<Location>();
  }
  
  private Boolean loadJSON(JSONObject json) {
    //TODO: implement
    //Load in values from passed json
    Boolean error = false;
    JSONObject object;
    JSONObject[] array;
    
    name = json.getString("name", name);
    
    object = JSONObjectReader.getJSONObject(json, "settings");
    if (object != null) {
      settings = new Settings(object);
    } else {
      error = true;
    }
    
    array = JSONObjectReader.getJSONObjectArray(json, "actorList");
    if (array != null) {
      actorList = new ArrayList<Actor>(array.length);
      for(int i=0; i < array.length; i++) {
        actorList.add( new Actor(this, array[i]) );
      }
    } else {
      error = true;
    }
    
    array = JSONObjectReader.getJSONObjectArray(json, "locationList");
    if (array != null) {
      locationList = new ArrayList<Location>(array.length);
      for(int i=0; i < array.length; i++) {
        locationList.add( new Location(this, array[i]) );
      }
    } else {
      error = true;
    }
    
    return !error;
  }
  
  public JSONObject toJSON() {
    setIDs();
    
    JSONObject json = new JSONObject();
    
    json.setString("name", name);
    json.setJSONObject( "settings", settings.toJSON() );
    json.setJSONArray( "actorList", getActorsAsJSON() );
    json.setJSONArray( "locationList", getLocationsAsJSON() );
    
    return json;
  }
  
  public String toString() {
    //TODO: stub
    String s = "[FATE Commander Document]\n";
    
    s += "Name: " + name + "\n";
    s += "Settings: " + settings + "\n";
    s += "Locations:\n";
    for (Location l : locationList) s += l;
    s += "Actors:\n";
    for (Actor a : actorList) s += a;
    
    return s;
  }
  
  public JSONArray getActorsAsJSON() {
    JSONArray a = new JSONArray();
    for (int i = 0; i < actorList.size(); i++) {
      a.setJSONObject(i, actorList.get(i).toJSON());
    }
    return a;
  }
  
  public JSONArray getLocationsAsJSON() {
    JSONArray a = new JSONArray();
    for (int i = 0; i < locationList.size(); i++) {
      a.setJSONObject(i, locationList.get(i).toJSON());
    }
    return a;
  }
  
  public void addActor(Actor a) {
    //TODO: stub
  }
  
  public void addLocation(Location l) {
    //TODO: stub
  }
  
  public void setIDs() {
    //Set ID values on all child CommanderObjects to match their index in their containing ArrayLists
    //Postcondition: This MUST be called by data export methods prior to calling ANY toJSON() methods
    //               Failure to do so will result in missing or corrupted relation information being saved!
    for (int i=0; i < actorList.size(); i++) actorList.get(i).setID(i);
    for (int i=0; i < locationList.size(); i++) locationList.get(i).setID(i);
  }



}
