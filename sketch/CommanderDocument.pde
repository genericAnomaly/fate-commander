public class CommanderDocument {
  String name;
  Settings settings;
  ArrayList<Actor> actorList;
  ArrayList<Location> locationList;
  
  
  public CommanderDocument() {
    init();
  }
  
  public CommanderDocument(JSONObject json) {
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
    
    actorList =      JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "actorList", null),      new Actor(this) );
    locationList =   JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "locationList", null),   new Location(this, "Factory instance", "LocationFactory") );
    
    if (!checkIDs()) {
      println("[Warning] ID mismatch detected! Did you tweak your save file?");
      repairIDs();
    }
    
    relinkIDs();
    
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
  
  //A quick word on IDs: They literally only matter on import/export, which is why we can steamroll them here
  public void setIDs() {
    //Set ID values on all child CommanderObjects to match their index in their containing ArrayLists
    //Postcondition: This MUST be called by data export methods prior to calling ANY toJSON() methods
    //               Failure to do so will result in missing or corrupted relation information being saved!
    for (int i=0; i < actorList.size(); i++) actorList.get(i).setID(i);
    for (int i=0; i < locationList.size(); i++) locationList.get(i).setID(i);
  }
  
  public void relinkIDs() {
    //This should only ever be run after reading in a document from JSON and running checkIDs()
    //Runs through every child CommanderObject and restores relationships to other CommanderObjects based on relational IDs
    for (Actor a : actorList) {
      if (a.locationID >= 0) locationList.get(a.locationID).addActor(a);
      //a a.locationID value of -1 indicates an orphaned value, TODO: orphan handler location?
    }
    for (Location l : locationList) {
      if (l.parentID >= 0) locationList.get(l.parentID).addChild(l);
    }
  }
  
  public Boolean checkIDs() {
    //This is the complement to setIDs and should only be run after reading in a document from JSON
    //Checks after that the id values of the loaded CommanderObjects match their actual keys
    //Shouldn't ever return false unless the save file was manually edited
    for (int i=0; i < actorList.size(); i++) if (actorList.get(i).getID() != i) return false;
    for (int i=0; i < locationList.size(); i++) if (locationList.get(i).getID() != i) return false;
    return true;
  }
  
  public void repairIDs() {
    //Run this if checkIDs returns false
    //Attempts to rebuild the CommanderObject lists and place everything at the indices indicated by their id values
    println("[Warning] Attempting to rebuild document lists in accordance with incongruent ids from save. This can cause unexpected behaviour!");
    Actor[] actors = new Actor[actorList.size()];
    for (Actor a : actorList) {
      println("  Processing Actor " + a.getName() + " with id " + a.getID());
      if (a.getID() >= 0 && a.getID() < actors.length && actors[a.getID()] == null) {
        actors[a.getID()] = a;
      } else {
        println("[Warning] Duplicate, missing, or OOB ID detected! Cannot automatically repair your save!");
        return;
      }
    }
    actorList = new ArrayList<Actor>(actors.length);
    for (int i=0; i < actors.length; i++) {
      actorList.add(actors[i]);
    } 
    
    Location[] locations = new Location[locationList.size()];
    for (Location l : locationList) {
      println("  Processing Location " + l.nameShort + " with id " + l.getID());
      if (l.getID() >= 0 && l.getID() < locations.length && locations[l.getID()] == null) {
        locations[l.getID()] = l;
      } else {
        println("[Warnig] Duplicate, missing, or OOB ID detected! Cannot automatically repair your save!");
        return;
      }
    }
    locationList = new ArrayList<Location>(locations.length);
    for (int i=0; i < locations.length; i++) {
      locationList.add(locations[i]);
    }
  }



}
