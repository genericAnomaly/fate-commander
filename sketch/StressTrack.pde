//import java.util.concurrent.LinkedBlockingQueue;

public class StressTrack implements JSONable {
  //Consider making this and NarrativeElement into internal classes of Actor?
  
  //StressTracks will be generated in Actor.init. Changes to the stress tracks in Settings (well, any changes in Settings really) will need to bubble out to correct affected values in the Document's CommanderObjects.
  //Regeneration required when Actor's skills change
  
  //Meta info
  int type;  //The name of the stress track and associated skill should always be pulled from document.settings or whatever
  //Actor parent;
  
  //State info
  int size;
  Boolean[] track;
  
  //ArrayList<StressPacket> incoming;
  
  
  /*
  //Referenced info (pulled from higher up in the document)
  //These should be saved to JSON, but the pulled values should supercede the saved ones. I have a feeling altering settings in an already populated document will need a lot of special handling and potential structural changes...
  //Remember not to worry to hard about keeping the stress tracks persistent; if something does go horribly wrong they can be regenerated easily, and if the user is changing around skills and stuff midgame for some reason it is probably not mid-scene and all tracks are probably empty
  int skillIndex;
  int skillValue;
  String name;
  */
  
  
  /*
  public StressTrack (Actor p, int t) {
    //Initialises a new BLANK stress track.
    parent = p;
    type = t;
    
    init();    
  }
  
  public StressTrack (Actor p, JSONObject json) {
    //TODO
    parent = p;
    type = json.getInt("type", 0);  //TODO: scream if the key is missing
    
    init();
    
    //TODO: read in JSON data
    
  }
  */
  
  /*
  public void regenerate() {
    //(Re)builds the stress track, preserving stress if it exists
    skillValue = parent.skills[skillIndex];  //LTToDo: Should probably add accessor methods to Actor to avoid potential oob exceptions
    size = 2;
    if (skillValue > 0) size = 3;  //LongTermToDo: options for setting base track size and when it grows?
    if (skillValue > 2) size = 4;
    Boolean[] newTrack = new Boolean[size];
    for (int i = 0; i < size; i++) newTrack[i] = false;
    if (track != null) for (int i = 0; i < track.length; i++) newTrack[i] = track[i];
    track = newTrack;
  }
  */
  
  /*
  private void init() {
    //Precondition: parent and type must be populated!
    incoming = new ArrayList<StressPacket>();
    name = parent.getDocumentSettings().stressNames[type];
    skillIndex = parent.getDocumentSettings().stressSkills[type];
    regenerate();
  }
  */
  
  
  public StressTrack(int s) {
    size = s;
    //LT ToDo: Constrain size based on min and max track sizes, possibly specified in Settings
    init();
  }
  
  private void init() {
    track = new Boolean[size];
    for (int i = 0; i < size; i++) track[i] = false;
  }
  

  
  public void reset() {
    //Clear the stress track and queue without resolving the queue
    //TODO
  }
  
  JSONObject toJSON() {
    JSONObject json = new JSONObject();
    json.setInt("size", size);
    JSONArray array = new JSONArray();
    for (int i=0; i<track.length; i++) array.setInt(i, track[i] ? 1 : 0 );
    json.setJSONArray("track", array);
    return json;
  }
  
  void loadJSON(JSONObject json) {
    //TODO
  }
  
  
  
  
  public String toString() {
    String s = "[StressTrack] => ";
    for (int i = 0; i < size; i ++) {
      s += "[";
      s += track[i] ? "X" : " ";
      s += "]";
    }
    //if (!incoming.isEmpty()) s += "  (" + incoming.size() + " Unresolved stress packet(s) in queue!)";
    return s;
  }
  
  
  
  
  public Boolean offerStress(StressPacket packet) {
    //Attempt to absord the offeredStress into this stress track.
    //Returns true if the stress could be absorbed, false otherwise.
    
    //TODO: Should this scream about StressPackets of the wrong type?
      //No, StressTracks should not know what their stress type is, that's for the Actor to worry about
    
    //TODO: Document level settings defining stress absorbtion
    //Like, a setting for if stress can be split between boxes
    //And different configurations like STRESS_TRACK _LINEAR, _DOUBLE_LINEAR, _FIBONACCI, _EXPONENTIAL
    //Let's just use linear for now and worry about different dissipation models later
    
    //edge case: no damage, always absorbed so
    if (packet.value <= 0) return true;
    
    //Try each box from small to large
    for (int i = packet.value-1; i < size; i++) {
      if (!track[i]) {
        track[i] = true;
        println("[Stress] Successfully absorbing " + packet + " in box " + i);
        return true;
      }
    }
    return false;
  }
  
  
  
  
  
  
  
}


public class StressPacket {
  int value;
  int type;
  String description;
  
  public StressPacket(int v, int t, String d) {
    value = v;
    type = t;
    description = d;
  }
  
  public String toString() {
    return "[StressPacket] (" + type + "/" + value + "/" + description + ")";
  }
  
}




