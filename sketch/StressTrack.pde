//import java.util.concurrent.LinkedBlockingQueue;

public class StressTrack implements JSONable {
  //Consider making this and NarrativeElement into internal classes of Actor?
  
  //StressTracks will be generated in Actor.init. Changes to the stress tracks in Settings (well, any changes in Settings really) will need to bubble out to correct affected values in the Document's CommanderObjects.
  //Regeneration required when Actor's skills change
  
  //Meta info
  int type;  //The name of the stress track and associated skill should always be pulled from document.settings or whatever
  //Actor parent;
  
  //State info
  Boolean[] track;
  

  public StressTrack(int s) {
    init();
    resize(s);
  }
  
  public StressTrack (JSONObject json) {
    init();
    loadJSON(json);
  }
  
  
  private void init() {
    track = new Boolean[2];
    for (int i = 0; i < track.length; i++) track[i] = false;
  }
  
  
  
  private void resize(int newSize) {
    Boolean[] newTrack = new Boolean[newSize];
    for (int i = 0; i < newTrack.length; i++) newTrack[i] = false;
    int copy = track.length;
    if (newTrack.length < copy) copy = newTrack.length;
    for (int i = 0; i < copy; i++) newTrack[i] = track[i];
    track = newTrack;
  }
  
  
  void loadJSON(JSONObject json) {
    int[] loading = JSONObjectReader.getIntArray(json, "track", null);
    if (loading == null) return; //LT Todo: alert the user that their save's janked
    track = new Boolean[loading.length];
    for (int i = 0; i < loading.length; i++) {
      track[i] = false;
      if (loading[i] == 1) track[i] = true;
    }
  }
  
  JSONObject toJSON() {
    JSONObject json = new JSONObject();
    JSONArray array = new JSONArray();
    for (int i=0; i<track.length; i++) array.setInt(i, track[i] ? 1 : 0 );
    json.setJSONArray("track", array);
    return json;
  }
  

  
  
  public void reset() {
    //Clear the stress track
    //LT ToDo: Mention this to the logger
    for (int i = 0; i < track.length; i++) track[i] = false;
  }
  
  public String toString() {
    String s = "[StressTrack] => ";
    for (int i = 0; i < track.length; i ++) {
      s += "[";
      s += track[i] ? "X" : " ";
      s += "]";
    }
    return s;
  }
  
  public int size() {
    return track.length;
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




