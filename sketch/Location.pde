public class Location extends CommanderObject {
  //Locations represent any location, usually a room, a building, or an external area
  
  //Roadmap:
  //[X] Locations house Actors
  //[X] Locations have child Locations
  //[ ] Location to and from JSON works
  //[ ] Locations will satisfy specific Motives
  //[ ] Locations occupy a volume of space
  //[ ] Location pathfinding, probably node-based
  //[ ] Load custom PCG rules for generating complex collections of locations
  
  //Metadata
  String nameLong;
  String nameShort;

  //Actor occupation
  ArrayList actorList;
  int capacity;  //This is not a hard limit, might consider this metadata or associated with motives?
  
  //Location hierarchy
  Location parent;
  ArrayList childList;
  
  //Location in space and pathing
  //(We'll deal with this stuff later)
  //ArrayList nodes;
  //PVector origin;
  //PVector dimensions;
  
  
  Location (CommanderDocument d, String l, String s) {
    super(d);
    init();
    //Build from arguments
    nameLong = l;
    nameShort = s;
  }
  
  Location (CommanderDocument d, JSONObject json) {
    super(d);
    init();
    loadJSON(json);
  }
  
  private void init() {
    //Initialise this Location with default values
    //TODO: Should this talk to the document to make sure it gets a unique name?
    nameLong = "Unnamed Location";
    nameShort = "unnamed";
    actorList = new ArrayList<Actor>();
    parent = null;
    childList = new ArrayList<Location>();
  }
  
  void loadJSON(JSONObject json) {
    nameLong = json.getString("nameLong", nameLong);
    nameShort = json.getString("nameShort", nameShort);
  }
  
  JSONObject toJSON() {
    //TODO: get this proper working, figure out the best way to save state stuff like actors and children (it's definitely IDs but we gotta implement that first)
    JSONObject json = new JSONObject();
    json.setString("nameLong", nameLong);
    json.setString("nameShort", nameShort);
    json.setInt("id", getID());
    return json;
  }
  
  
  void addActor (Actor a) {
    //return if Actor is already here
    if (a.at == this) return;
    //Actor can only be in one Location, remove from previous Location
    if (a.at != null) a.at.removeActor(a);
    //push Actor on actorList
    actorList.add(a);
    //set Actor.at for easy lookups
    println("[debug] Setting " + a.getName() + "'s location to " + this.nameLong);
    a.at = this;
  }
  
  void removeActor (Actor a) {
    //return in case Actor is not present (this should never happen)
    if (a.at != this) return;
    //remove Actor from actorList
    actorList.remove(a);
    //Clear Actor.at so it doesn't mistakenly call back here in future
    a.at = null;
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
  
  

  
  String toString () {
    return toString("");
  }
  
  String toString (String t) {
    String s = "";
    s += t + "[L] " + nameLong + "\n";
    t = t + "  ";
    for (int i = 0; i < actorList.size(); i++) {
      Actor a = (Actor) actorList.get(i);
      s += t + a.toString(t);
    }
    for (int i = 0; i < childList.size(); i++) {
      Location l = (Location) childList.get(i);
      s += l.toString(t);
    }
    return s;
  }
  

  /*
  void addConnection(Location l) {
    //Adds a mutual connection between this location and l 
    nodes.add(l);
    l.nodes.add(this);
  }
  
  
  void draw() {
    rect(origin.x, origin.y, dimensions.x, dimensions.y);
  }
  */
  
}
