public class Location extends CommanderObject {
  //Locations represent any location, usually a room, a building, or an external area
  
  //Roadmap:
  //[X] Locations house Actors
  //[X] Locations have child Locations
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
  
  
  Location (String l, String s) {
    super(sketchDocument);
    
    //Metadata
    nameLong = l;
    nameShort = s;
    
    //Actor occupation
    actorList = new ArrayList<Actor>();
    
    //Location hierarchy
    parent = null;
    childList = new ArrayList<Location>();
  }
  
  Location (JSONObject s) {
    super(sketchDocument);
    //TODO
    //Constructor to support loading from previously saved JSONObject
  }
  
  
  void loadJson(JSONObject json) {
    //TODO: stub
  }
  
  JSONObject toJSON() {
    //TODO: get this proper working, figure out the best way to save state stuff like actors and children (it's definitely IDs but we gotta implement that first)
    JSONObject json = new JSONObject();
    json.setString("nameLong", nameLong);
    json.setString("nameShort", nameShort);
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

  //These two are almost identical to add/removeActor, so they're not annotated  
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
