public class Actor extends CommanderObject {
  
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
  // Mechanical character attributes
  int[] skills;
  int luck;
  //Aspects, etc, go here
  
  //CommanderObject relationships
  Location location;
  
  //JSON Export
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
  
  
  // Initialisers
  //================================================================
  
  private void init() {
    //Initialise a blank actor
    gender = 0;
    fName = "Jane";
    lName = "Doe";
    luck = 0;
    skills = new int[getDocumentSettings().numSkills];
  } 
  
  private void randomise() {
    //Generate random vital stats for this Actor.
    luck = 1;
    gender = floor(random(2));
    lName = getDocumentSettings().getRandomLastName();
    fName = getDocumentSettings().getRandomFirstName(gender);
    skills = getDocumentSettings().getRandomSkillPyramid();
  }
  
  
  // toStrings [and related convenience String returning methods]
  //================================================================
  
  String toString() {
    return toString("");
  }
  
  String toString(String t) {
    String s = "";
    s += "[A] " + fName + " " + lName + " (" + luck + ")\n"; 
    t = t + "  "; 
    int peak = 0;
    for (int i = 0; i < skills.length; i++) {
      if (skills[i] > peak) peak = skills[i];
    }
    for (int i = peak; i > 0; i--) {
      s += t + "+" + i + " ";
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
  
  String getName() {
    return fName + " " + lName;
  }
  
  
  // JSON save/load
  //================================================================
  
  JSONObject toJSON() {
    //Return this Actor in JSON notation for saving to file
    JSONObject json = new JSONObject();
    json.setString("fName", fName);
    json.setString("lName", lName);
    json.setInt("gender", gender);
    json.setInt("luck", luck);
    json.setInt("id", getID());
    locationID = -1;
    if (location!=null) locationID = location.getID();
    json.setInt("locationID", locationID);
    JSONArray s = new JSONArray();
    for (int i=0; i<skills.length; i++) {
      s.setInt(i, skills[i]);
    }
    json.setJSONArray("skills", s);
    return json;
  }
  
  void loadJSON(JSONObject json) {
    //Load in this Actor from a saved JSONObject
    fName = json.getString("fName", fName);
    lName = json.getString("lName", lName);
    gender = json.getInt("gender", gender);
    luck = json.getInt("luck", luck);
    skills = JSONObjectReader.getIntArray(json, "skills", skills);
    //relations
    locationID = json.getInt("locationID", -1);  //-1 = no location
  }
  

  
}
