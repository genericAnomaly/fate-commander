//import java.util.concurrent.LinkedBlockingQueue;

public class StressTrack implements JSONable {
  //Consider making this and NarrativeElement into internal classes of Actor?
  
  //StressTracks will be generated in Actor.init. Changes to the stress tracks in Settings (well, any changes in Settings really) will need to bubble out to correct affected values in the Document's CommanderObjects.
  //Regeneration required when Actor's skills change
  
  //Meta info
  int type;  //The name of the stress track and associated skill should always be pulled from document.settings or whatever
  Actor parent;
  
  //State info
  int size;
  Boolean[] track;
  ArrayList<StressPacket> incoming;
  
  //Referenced info (pulled from higher up in the document)
  //These should be saved to JSON, but the pulled values should supercede the saved ones. I have a feeling altering settings in an already populated document will need a lot of special handling and potential structural changes...
  //Remember not to worry to hard about keeping the stress tracks persistent; if something does go horribly wrong they can be regenerated easily, and if the user is changing around skills and stuff midgame for some reason it is probably not mid-scene and all tracks are probably empty
  int skillIndex;
  int skillValue;
  String name;
  
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
  
  /*
  private void loadUpper() {
    //Precondition: parent and type are populated
    name = parent.getDocumentSettings().stressNames[type];
    skillIndex = parent.getDocumentSettings().stressSkills[type];
    skillValue = parent.skills[skillIndex];
    println("Loading upper for " + parent.getName() + "/Stress[" + type + "] (" + name + " stress): skillValue is " + skillValue); 
  }
  */
  
  private void init() {
    //Precondition: parent and type must be populated!
    incoming = new ArrayList<StressPacket>();
    name = parent.getDocumentSettings().stressNames[type];
    skillIndex = parent.getDocumentSettings().stressSkills[type];
    regenerate();
  }
  
  
  
  public void addStress(int v, String d) {
    StressPacket packet = new StressPacket(v, type, d);
    incoming.add(packet);
  }
  
  public void addStress(StressPacket packet) {
    if (packet.type == type) incoming.add(packet);
  }
  
  public void resolveQueue() {
    //TODO
    //Force naive resolution of all queued stress.
    //If there is too much stress for the track to legally absorb, it will be passed upwards to the Actor's ConsequenceManager
    while ( !incoming.isEmpty() ) {
      StressPacket packet = incoming.get(0); //I am not sure if this will generate queuelike behaviour off the top of my head :\
      bestResolution(packet);
      incoming.remove(packet);
    }
  }
  
  public void bestResolution(StressPacket packet) {
    //Find the smallest box it'll fit then keep going up until it's resolved. If it can't be, pass it up to the Consequence handler or whatever
    //TODO: Maybe include document settings for how much stress each box can take like STRESS_TRACK _LINEAR, _DOUBLE_LINEAR, _FIBONACCI, _EXPONENTIAL
    //TODO: Can you split stress between boxes, i.e. 5 goes in a 1 and 4 box? Eck this whole thing could use more work, handling all this mechanical flexibility is a mega pain.
    Boolean resolved = false;
    for (int i = packet.value-1; i < size; i++) {
      if (!track[i]) {
        track[i] = true;
        resolved = true;
        break;
      }
    }
    if (!resolved) {
      println("[Stress] " + packet + " could not be absorbed, passing to consequence manager!");
      println("[TODO] Implement a consequence manager :/");
      //TODO
    }
  }
  
  public void reset() {
    //Clear the stress track and queue without resolving the queue
    //TODO
  }
  
  JSONObject toJSON() {
    //Ugh does something as ephemeral as the stress track /really/ need to save/load?
    JSONObject json = new JSONObject();
    json.setInt("type", type);
    json.setInt("size", size);
    JSONArray array = new JSONArray();
    for (int i=0; i<track.length; i++) array.setInt(i, track[i] ? 1 : 0 );
    json.setJSONArray("track", array);
    //TODO ArrayList<StressPacket> incoming;
    json.setInt("skillIndex", skillIndex);
    json.setInt("skillValue", skillValue);
    json.setString("name", name);
    return json;
  }
  
  void loadJSON(JSONObject json) {
    //TODO
  }
  
  
  
  
  public String toString() {
    String s = "[Stress Track] " + name + " stress: ";
    for (int i = 0; i < size; i ++) {
      s += "[";
      s += track[i] ? "X" : " ";
      s += "]";
    }
    if (!incoming.isEmpty()) s += "  (" + incoming.size() + " Unresolved stress packet(s) in queue!)";
    return s;
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
    return "[StressPacket] (type/value/description) = (" + type + "/" + value + "/" + description + ")";
  }
  
}




