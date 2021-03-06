public class Location extends CommanderObject implements JSONable<Location> {
  //Locations represent any location, usually a room, a building, or an external area
  
  //Roadmap:
  //[ ] Locations will satisfy specific Motives
  //[ ] Locations occupy a volume of space
  //[ ] Location pathfinding, probably node-based
  //[ ] Load custom PCG rules for generating complex collections of locations
  
  // Instance variables
  //================================================================

  //Metadata
  String nameLong;
  String nameShort;

  //Actor occupation
  ArrayList<Actor> actorList;
  int capacity;  //This is not a hard limit, might consider this metadata or associated with motives?
  
  //Location tree relationships
  Location parent;
  ArrayList<Location> childList;
  
  //JSONable CommanderObject relationship export
  int parentID;
  
  //LT TODO: Location in space and pathing
  //ArrayList nodes;
  //PVector origin;
  //PVector dimensions;
  

  // Constructors
  //================================================================
  
  Location (CommanderDocument d, String l, String s) {
    super(d);
    init();
    nameLong = l;
    nameShort = s;
  }
  
  Location (CommanderDocument d, JSONObject json) {
    super(d, json);
    init();
    loadJSON(json);
  }
  
  Location construct(JSONObject json) {
    return new Location(getDocument(), json);
  }
  

  // Initialisers
  //================================================================
  
  private void init() {
    //Initialise this Location with default values
    //TODO: Should this talk to the document to make sure it gets a unique name?
    nameLong = "Unnamed Location";
    nameShort = "unnamed";
    actorList = new ArrayList<Actor>();
    parent = null;
    childList = new ArrayList<Location>();
  }
  
  
  // toStrings
  //================================================================
  
  String toString () {
    return toString("");
  }
  
  String toString (String t) {
    String s = "";
    s += t + "[L] " + nameLong + "\n";
    t = t + "  ";
    for (Actor a : actorList) {
      s += t + a.toString(t);
    }
    for (Location l : childList) {
      s += l.toString(t);
    }
    return s;
  }
  
  
  // JSONable
  //================================================================
  
  void loadJSON(JSONObject json) {
    nameLong = json.getString("nameLong", nameLong);
    nameShort = json.getString("nameShort", nameShort);
    parentID = json.getInt("parentID", -1);
  }
  
  JSONObject toJSON() {
    JSONObject json = new JSONObject();
    json.setString("nameLong", nameLong);
    json.setString("nameShort", nameShort);
    json.setInt("id", getID());
    parentID = -1;
    if (parent != null) parentID = parent.getID();
    json.setInt("parentID", parentID);
    return json;
  }





  // Mechanical functionality
  //================================================================
  
  
  // Connections to other CommanderObjects 
  //================================================================
  
  //TODO: Is it best practice to have Actor.location exposed like this?
  void addActor (Actor a) {
    //return if Actor is already here
    if (a.location == this) return;
    //Actor can only be in one Location, remove from previous Location
    if (a.location != null) a.location.removeActor(a);
    //push Actor on actorList
    actorList.add(a);
    //set Actor.location for easy lookups
    a.location = this;
  }
  
  void removeActor (Actor a) {
    //return in case Actor is not present (this should never happen)
    if (a.location != this) return;
    //remove Actor from actorList
    actorList.remove(a);
    //Clear Actor.location so it doesn't mistakenly call back here in future
    a.location = null;
  }

  void addChild (Location l) {
    if (l.parent == this) return;
    if (l.parent != null) l.parent.removeChild(l);
    childList.add(l);
    l.parent = this;
  }
  void removeChild (Location l) {
    if (l.parent != this) return;
    childList.remove(l);
    l.parent = null;
  }
  
  

  

  /*
  void addConnection(Location l) {
    //TODO: Stub for when I get to location connections
    //Adds a mutual connection between this location and l 
  }
  */
  
}
