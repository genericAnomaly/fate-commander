//import java.util.concurrent.LinkedBlockingQueue;

public class StressTrack implements JSONable {
  //Consider making this and NarrativeElement into internal classes of Actor?
  
  //StressTracks will be generated in Actor.init. Changes to the stress tracks in Settings (well, any changes in Settings really) will need to bubble out to correct affected values in the Document's CommanderObjects.
  //Regeneration required when Actor's skills change
  
  int type;  //The name of the stress track and associated skill should always be pulled from document.settings or whatever
  
  int size;
  Boolean[] track;
  //LinkedBlockingQueue<Integer> incoming; //Can't be an integer, needs to be an int string pair where the string describes the stress
  ArrayList<StressPacket> incoming;
  
  
  public StressTrack (JSONObject json) {
    //TODO
  }
  
  
  private void init() {
    //TODO
    incoming = new ArrayList<StressPacket>();
    size = 2;
    int skill = 3;//TODO fetch this
    if (skill > 1) size++;
    if (skill > 2) size++;
    track = new Boolean[size];
    for (int i = 0; i < size; i++) track[i] = false;
  }
  
  
  public void addStress(int v, String d) {
    StressPacket packet = new StressPacket(v, d);
    incoming.add(packet);
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
    Boolean resolved = false;
    for (int i = packet.value; i < size; i++) {
      if (!track[i]) {
        track[i] = true;
        resolved = true;
        continue;
      }
    }
    if (!resolved) {
      println("[Stress] StressPacket{" + packet.value + ", " + packet.description + "} could not be resolved, passing to consequence manager!");
      //TODO
    }
  }
  
  
  JSONObject toJSON() {
    //TODO
    JSONObject json = new JSONObject();
    return json;
  }
  
  void loadJSON(JSONObject json) {
    //TODO
  }
  
}


public class StressPacket {
  int value;
  String description;
  
  public StressPacket(int v, String d) {
    value = v;
    description = d;
  }
  
}




