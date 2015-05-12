public class CommanderDocument {
  
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
    settings = new Settings();
    actorList = new ArrayList<Actor>();
    locationList = new ArrayList<Location>();
  }
  
  private Boolean loadJson(JSONObject json) {
    //TODO: implement
    //Load in values from passed json
    return false;
  }
  
  
  public void addActor(Actor a) {
    //TODO: stub
  }
  
  public void addLocation(Location l) {
    //TODO: stub
  }
  
  public JSONObject toJson() {
    //TODO: stub
    return new JSONObject();
  }
  
  public String toString() {
    //TODO: stub
    return "[Todo] write this method";
  }
}
