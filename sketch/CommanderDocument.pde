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
    loadJson(json);
    //TODO: if loadJson returns false, inform the user. I think this is actually the right time to use throwing exceptions? Dunno, research it.
  }
  
  private void init() {
    //Initialise this document with the default values
    name = "Untitled Fate Commander Document";
    settings = new Settings();
    actorList = new ArrayList<Actor>();
    locationList = new ArrayList<Location>();
  }
  
  private Boolean loadJson(JSONObject json) {
    //TODO: implement
    //Load in values from passed json
    return false;
  }
  
  public JSONObject toJSON() {
    JSONObject json = new JSONObject();
    
    json.setString("name", name);
    json.setJSONObject( "settings", settings.toJSON() );
    json.setJSONArray( "actorList", getActorsAsJson() );
    json.setJSONArray( "locationList", getLocationsAsJson() );
    
    return json;
  }
  
  public String toString() {
    //TODO: stub
    return "[Todo] write this method";
  }
  
  public JSONArray getActorsAsJson() {
    JSONArray a = new JSONArray();
    for (int i = 0; i < actorList.size(); i++) {
      a.setJSONObject(i, actorList.get(i).toJSON());
    }
    return a;
  }
  
  public JSONArray getLocationsAsJson() {
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
  
  



}
