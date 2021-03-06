public class Actor extends CommanderObject implements JSONable<Actor> {
  
  // Constants
  //================================================================
  
  //Skill indices (move to Settings maybe?)
  static final int SKILL_ATHLETICS = 0;
  static final int SKILL_BURGLARY = 1;
  static final int SKILL_CONTACTS = 2;
  static final int SKILL_CRAFTS = 3;
  static final int SKILL_DECEIVE = 4;
  static final int SKILL_DRIVE = 5;
  static final int SKILL_EMPATHY = 6;
  static final int SKILL_FIGHT = 7;
  static final int SKILL_INVESTIGATE = 8;
  static final int SKILL_LORE = 9;
  static final int SKILL_NOTICE = 10;
  static final int SKILL_PHYSIQUE = 11;
  static final int SKILL_PROVOKE = 12;
  static final int SKILL_RAPPORT = 13;
  static final int SKILL_RESOURCES = 14;
  static final int SKILL_SHOOT = 15;
  static final int SKILL_STEALTH = 16;
  static final int SKILL_WILL = 17;
  
  //Gender indices
  static final int GENDER_FEMALE = 0;
  static final int GENDER_MALE = 1;
  
  // Instance variables
  //================================================================
  
  // Narrative character attributes
  String fName;
  String lName;
  int gender;
  ArrayList<NarrativeElement> aspectList;
  ArrayList<NarrativeElement> stuntList;
  ArrayList<NarrativeElement> consequenceList;
  ArrayList<NarrativeElement> extraList;
  ArrayList<NarrativeElement> noteList;


  // Mechanical character attributes
  int[] skills;
  StressTrack[] stressTracks;
  ArrayList<StressPacket> stressQueue;
  int luck;
  
  //Flags
  Boolean isPlayer;
  Boolean isPlot;
  Boolean isGenerated;
  Boolean isDeceased;
  
  //CommanderObject relationships
  Location location;
  
  //JSONable CommanderObject relationship export
  int locationID;
  
  
  // Constructors
  //================================================================
  
  Actor(CommanderDocument d) {
    super(d);
    init();
    //No json provided so generate a random Actor
    randomise();
  }
  
  Actor(CommanderDocument d, JSONObject json) {
    super(d, json);
    init();
    //Load actor deets from provided json
    loadJSON(json);
  }
  
  
  Actor construct(JSONObject json) {
    return new Actor(getDocument(), json);
  }
  
  // Initialisers
  //================================================================
  
  private void init() {
    //Initialise a blank actor
    gender = 0;
    fName = "Jane";
    lName = "Doe";
    luck = 0;
    skills = new int[getDocumentSettings().numSkills];
    isPlayer = false;
    isPlot = false;
    isGenerated = false;
    isDeceased = false;
    initNarrativeElements();
    initStressTracks();
  }
  
  private void initNarrativeElements() {
    //Reset the NarrativeElement ArrayLists associated with this Actor and load default values
    aspectList = new ArrayList<NarrativeElement>(5);
    aspectList.add(new NarrativeElement("High Concept", "Description", NarrativeElement.ELEMENT_TYPE_ASPECT));
    aspectList.add(new NarrativeElement("Trouble", "Description", NarrativeElement.ELEMENT_TYPE_ASPECT));
    stuntList = new ArrayList<NarrativeElement>();
    consequenceList = new ArrayList<NarrativeElement>();
    extraList = new ArrayList<NarrativeElement>();
    noteList = new ArrayList<NarrativeElement>();
  }
  
  private void initStressTracks() {
    stressQueue = new ArrayList<StressPacket>();
    stressTracks = new StressTrack[getDocumentSettings().numStressTracks];
    for (int i = 0; i < stressTracks.length; i++) stressTracks[i] = new StressTrack( getStressTrackSize(i) );
  }

  private void randomise() {
    //Generate random vital stats for this Actor.
    isGenerated = true;
    isPlayer = false;
    isPlot = false;
    isDeceased = false;
    luck = 1;
    gender = floor(random(2));
    lName = getDocumentSettings().getRandomLastName();
    fName = getDocumentSettings().getRandomFirstName(gender);
    skills = getDocumentSettings().getRandomSkillPyramid();
    initStressTracks();
  }
  
  
  // toStrings [and related convenience String returning methods]
  //================================================================
  
  String toString() {
    return toString("");
  }
  
  //LT ToDo: Create an interface for everything with a print_r style recursive toString?
  String toString(String t) {
    String s = "";
    s += "[A] " + fName + " " + lName + " (" + luck + ")\n"; 
    t = t + "  "; 

    //NarrativeElements
    s += stringifyList("Aspect", aspectList, t);
    s += stringifyList("Stunt", stuntList, t);
    s += stringifyList("Consequence", consequenceList, t);
    s += stringifyList("Extra", extraList, t);
    s += stringifyList("Note", noteList, t);
    
    //Stress
    s += t + "Stress:\n";
    for (int i = 0; i < stressTracks.length; i++) s += t + " " + getDocumentSettings().stressNames[i] + stressTracks[i] + "\n";
    s += t + "Stress Queue:\n";
    for (StressPacket packet : stressQueue) s += t + " " + packet + "\n";
    
    //Skills
    s += t + "Skills:\n";
    int peak = 0;
    for (int i = 0; i < skills.length; i++) {
      if (skills[i] > peak) peak = skills[i];
    }
    for (int i = peak; i > 0; i--) {
      s += t + " +" + i + " ";
      String delim = "";
      for (int j = 0; j < skills.length; j++) {
        if (skills[j] == i) {
          s += delim + getDocumentSettings().skillNames[j];
          delim = ", ";
        }
      }
      s += "\n";
    }
    return s;
  }
  
  //TODO: consider genericising this method to apply to anything implementing a recursively stringable interface
  String stringifyList(String title, ArrayList<NarrativeElement> list, String t) {
    String s = "";
    if (list == null) return t + "No " + title + "s\n";
    if (list.size() == 0) return t + "No " + title + "s\n";
    s += t + title + "s:\n";
    for (NarrativeElement e : list) s += t + " " + e.name + "\n";
    return s;
  } 
  
  String getName() {
    return fName + " " + lName;
  }
  
  String getStress() {
    String s = getName() + "'s Stress\n";
    for (StressTrack track : stressTracks) s += " " + track + "\n";
    return s;
  }
  
  // JSONable
  //================================================================
  
  JSONObject toJSON() {
    JSONObject json = new JSONObject();

    //Meta
    json.setString("fName", fName);
    json.setString("lName", lName);
    json.setInt("gender", gender);
    json.setInt("luck", luck);
    json.setInt("id", getID());

    //Flags
    json.setBoolean("isPlayer",      isPlayer);
    json.setBoolean("isPlot",        isPlot);
    json.setBoolean("isGenerated",   isGenerated);
    json.setBoolean("isDeceased",    isDeceased);
    
    //LocationRef
    locationID = -1;
    if (location!=null) locationID = location.getID();
    json.setInt("locationID", locationID);
    
    //Skills
    JSONArray s = new JSONArray();
    for (int i=0; i<skills.length; i++) s.setInt(i, skills[i]);
    json.setJSONArray("skills", s);
     
    //Stress
    json.setJSONArray("stressTracks",      JSONObjectReader.arrayToJSONArray(stressTracks));
    json.setJSONArray("stressQueue",       JSONObjectReader.arrayListToJSONArray(stressQueue));
    
    //NarrativeElements
    json.setJSONArray("aspectList",        JSONObjectReader.arrayListToJSONArray(aspectList));
    json.setJSONArray("stuntList",         JSONObjectReader.arrayListToJSONArray(stuntList));
    json.setJSONArray("consequenceList",   JSONObjectReader.arrayListToJSONArray(consequenceList));
    json.setJSONArray("extraList",         JSONObjectReader.arrayListToJSONArray(extraList));
    json.setJSONArray("noteList",          JSONObjectReader.arrayListToJSONArray(noteList));
    
    return json;
  }
  
  //Figure this out later: Since T construct(JSONObject json) is in the interface, does loadJSON (which should probably be private) still need to be in JSONable?
  void loadJSON(JSONObject json) {
    //Meta
    fName = json.getString("fName", fName);
    lName = json.getString("lName", lName);
    gender = json.getInt("gender", gender);
    luck = json.getInt("luck", luck);

    //Flags
    isPlayer =      json.getBoolean("isPlayer",    false);
    isPlot =        json.getBoolean("isPlot",      false);
    isGenerated =   json.getBoolean("isGenerated", false);
    isDeceased =    json.getBoolean("isDeceased",  false);
    
    //Location Ref
    locationID = json.getInt("locationID", -1);  //-1 = no location
    
    //Skills
    skills =              JSONObjectReader.getIntArray(json, "skills", skills);
    
    //Stress
    stressQueue =         JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "stressQueue", null),       new StressPacket()     );
    stressTracks =        JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "stressTracks", null),      new StressTrack()      ).toArray(stressTracks);

    //NarrativeElements
    aspectList =          JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "aspectList", null),        new NarrativeElement() );
    stuntList =           JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "stuntList", null),         new NarrativeElement() );
    consequenceList =     JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "consequenceList", null),   new NarrativeElement() );
    extraList =           JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "extraList", null),         new NarrativeElement() );
    noteList =            JSONObjectReader.toArrayList( JSONObjectReader.getJSONArray(json, "noteList", null),          new NarrativeElement() );
    
  }
  
  // Mechanical functionality
  //================================================================


  // Stress
  //================================================================
  void addStress(int amount, int type, String description) {
    StressPacket packet = new StressPacket(amount, type, description);
    addStress(packet);
  }
  void addStress(StressPacket packet) {
    stressQueue.add(packet);
  }
  void autoResolveStressQueue() {
    //Automatically resolve all queued stress
    while ( !stressQueue.isEmpty() ) {
      StressPacket packet = stressQueue.get(0);
      if ( !stressTracks[packet.type].offerStress(packet) ) {
        //TODO:
        println("[Stress] " + getName() + " cannot absorb " + packet + ", forwarding it to Consequences");
        println("[TODO] Implement Consequence handling.");
      }
      stressQueue.remove(packet);
    }
    
  }
  
  //Convenience getters for Stress
  //================================================================
  private String getStressTrackName(int stressType) {
    return getDocumentSettings().stressNames[stressType];
  }
  private int getStressTrackSkillIndex(int stressType) {
    return getDocumentSettings().stressSkills[stressType];
  }
  private int getStressTrackSize(int stressType) {
    //LT ToDo: Get info from Settings object for custom StressTrack sizes
    //LT ToDo: Should this maybe go in the StressTrack class but as a static method?
    int skillValue = skills[ getStressTrackSkillIndex(stressType) ];
    int trackSize = 2;
    if (skillValue > 0) trackSize = 3;
    if (skillValue > 2) trackSize = 4;
    return trackSize;
  }



}
