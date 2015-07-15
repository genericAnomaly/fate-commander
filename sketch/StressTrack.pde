public class StressTrack implements JSONable<StressTrack> {

  // Instance variables
  //================================================================
  Boolean[] track;

  
  // Constructors
  //================================================================
  
  StressTrack(int s) {
    init();
    resize(s);
  }
  
  StressTrack (JSONObject json) {
    init();
    loadJSON(json);
  }
  
  StressTrack () {
    init();
    //Empty constructor StressTrack - for use as a factory object only!
  }
  
  StressTrack construct(JSONObject json) {
    return new StressTrack(json);
  }


  // Initialisers
  //================================================================
  
  private void init() {
    track = new Boolean[2];
    for (int i = 0; i < track.length; i++) track[i] = false;
  }
  
  
  // JSONable
  //================================================================
  
  void loadJSON(JSONObject json) {
    track = JSONObjectReader.getBooleanArray(json, "track", null);
  }
  
  JSONObject toJSON() {
    JSONObject json = new JSONObject();
    JSONArray array = new JSONArray();
    for (int i=0; i<track.length; i++) array.setBoolean(i, track[i]);
    json.setJSONArray("track", array);
    return json;
  }
  
  
  // toString
  //================================================================
  
  public String toString() {
    String s = "[StressTrack] => ";
    for (int i = 0; i < track.length; i ++) {
      s += "[";
      s += track[i] ? "X" : " ";
      s += "]";
    }
    return s;
  }
  
  
  // Structure functionality
  //================================================================
  
  void resize(int newSize) {
    Boolean[] newTrack = new Boolean[newSize];
    for (int i = 0; i < newTrack.length; i++) newTrack[i] = false;
    int copy = track.length;
    if (newTrack.length < copy) copy = newTrack.length;
    for (int i = 0; i < copy; i++) newTrack[i] = track[i];
    track = newTrack;
  }
  
  int size() {
    return track.length;
  }
  

  // Mechanical functionality
  //================================================================
  //LT TODO: Most methods classified as mechanical should probably mention their results to the logger object if that ever happens
  
  void reset() {
    //Clear the stress track
    //LT ToDo: Mention this to the logger
    for (int i = 0; i < track.length; i++) track[i] = false;
  }
  
  
  Boolean offerStress(StressPacket packet) {
    //Attempt to absorb packet into this stress track.
    //Returns true if the stress was absorbed, false otherwise.
    
    //TODO: Document level settings defining stress absorbtion
    //Like, a setting for if stress can be split between boxes
    //And different configurations like STRESS_TRACK _LINEAR, _DOUBLE_LINEAR, _FIBONACCI, _EXPONENTIAL
    //Let's just use linear for now and worry about different dissipation models later
    
    //Edge case: Packet contains no shifts, returns true without consuming any boxes
    if (packet.value <= 0) return true;
    
    //Try each box from small to large
    for (int i = packet.value-1; i < track.length; i++) {
      if (!track[i]) {
        track[i] = true;
        println("[Stress] Successfully absorbing " + packet + " in box " + i);
        return true;
      }
    }
    return false;
  }
}





public class StressPacket implements JSONable<StressPacket> {
  int value;
  int type;
  String description;
  
  StressPacket(int v, int t, String d) {
    value = v;
    type = t;
    description = d;
  }
  StressPacket(JSONObject json) {
    loadJSON(json);
  }
  StressPacket() {
    value = -1;
    type = -1;
    description = "Empty constructor StressPacket - for use as a factory object only!";
  }

  StressPacket construct(JSONObject json) {
    return new StressPacket(json);
  }
  
  JSONObject toJSON() {
    JSONObject json = new JSONObject();
    json.setInt("value", value);
    json.setInt("type", type);
    json.setString("description", description);
    return json;
  }
  void loadJSON(JSONObject json) {
    value = json.getInt("value", 0);
    type = json.getInt("type", 0);
    description = json.getString("description", "Description");
  }
  
  String toString() {
    return "[StressPacket] (" + type + "/" + value + "/" + description + ")";
  }
}




