public class Actor extends CommanderObject {
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
  
  static final int GENDER_FEMALE = 0;
  static final int GENDER_MALE = 1;
  
  //Character attributes
  String fName;
  String lName;
  int gender;
  //Mechanical character attributes
  int[] skills;
  int luck;
  //Aspects, etc, go here
  
  //Program state
  Location at;
  
  
  //Constructors
  Actor() {
    super(sketchDocument);
    //No json provided so generate a random Actor
    randomise();
  }
  
  Actor(JSONObject json) {
    super(sketchDocument);
    //Load actor deets from provided json
    loadJSON(json);
  }
  
  
  void randomise() {
    //Randomly determine vital stats for this Actor. Called by constructor when a saved JSON crewmember is not provided.
    luck = 1;
    gender = floor(random(2));
    lName = SETTINGS.namesLast[floor(random(SETTINGS.namesLast.length))];
    fName = ( (gender == GENDER_FEMALE) ? SETTINGS.namesFemale[floor(random(SETTINGS.namesFemale.length))] : SETTINGS.namesMale[floor(random(SETTINGS.namesMale.length))] );
    skills = new int[SETTINGS.numSkills];
    int pyramidHeight = SETTINGS.skillPeak;
    for (int rank = pyramidHeight; rank > 0; rank--) {
      for (int i = 0; i <= pyramidHeight-rank; i++) {
        int s = getWeightedRandomSkill();
        while (skills[s] != 0) {
          s = getWeightedRandomSkill();
        }
        skills[s] = rank;
      }
    }
  }
  
  int getWeightedRandomSkill() {
    int s = -1;
    while ( s == -1 || SETTINGS.skillWeight[s] <= random(1) ) {
      //loop will run on first run and continue running until the skillWeight for s is satisfied 
      s = floor(random(SETTINGS.numSkills));
    }
    return s;
  }

  
  String toFlatString() {
    //Return a human readable string representation of this Actor. Useful for debugging.
    String toReturn = "";
    toReturn += "Name: " + fName + " " + lName + "\n";
    toReturn += "Luck: " + luck + "\n";
    int topRank = 0;
    for (int i = 0; i < SETTINGS.numSkills; i++) {
      if (skills[i] > topRank) topRank = skills[i];
    }
    for (int i = topRank; i > 0; i--) {
      toReturn += "+" + i + " skills: ";
      String delim = "";
      for (int j = 0; j < SETTINGS.numSkills; j++) {
        if (skills[j] == i) {
          toReturn += delim + SETTINGS.skillNames[j];
          delim = ", ";
        }
      }
      toReturn += "\n";
    }
    return toReturn;
  }
  
  String getName() {
    return fName + " " + lName;
  }
  
  JSONObject toJSON() {
    //Return this Actor in JSON notation for saving to file
    JSONObject json = new JSONObject();
    json.setString("fName", fName);
    json.setString("lName", lName);
    json.setInt("gender", gender);
    json.setInt("luck", luck);
    JSONArray s = new JSONArray();
    for (int i=0; i<skills.length; i++) {
      s.setInt(i, skills[i]);
    }
    json.setJSONArray("skills", s);
    return json;
  }
  
  void loadJSON(JSONObject json) {
    //Load in this Actor from a saved JSONObject
    fName = json.getString("fName");
    lName = json.getString("lName");
    gender = json.getInt("gender");
    luck = json.getInt("luck");
    JSONArray s = json.getJSONArray("skills");
    skills = s.getIntArray();
  }
  
  
}
