public class CrewMember {
  static final int SKILL_ATHLETICS = 0;
  static final int SKILL_BURGLARY = 1;
  static final int SKILL_DECEIVE = 2;
  static final int SKILL_PILOT = 3;
  static final int SKILL_EMPATHY = 4;
  static final int SKILL_FIGHT = 5;
  static final int SKILL_INVESTIGATE = 6;
  static final int SKILL_LORE = 7;
  static final int SKILL_NOTICE = 8;
  static final int SKILL_PHYSIQUE = 9;
  static final int SKILL_PROVOKE = 10;
  static final int SKILL_RAPPORT = 11;
  static final int SKILL_SHOOT = 12;
  static final int SKILL_STEALTH = 13;
  static final int SKILL_WILL = 14;

  static final int NUM_SKILLS = 15;
  
  static final int GENDER_FEMALE = 0;
  static final int GENDER_MALE = 1;
  
  int[] skills;
  int luck;
  String fName;
  String lName;
  int gender;
  
  CrewMember() {
    randomise();
  }
  
  CrewMember(JSONObject s) {
    if (s != null) { //yes I KNOW that's not how overloading works in Java I don't care.
      //load in from s
      loadJSON(s);
    } else {
      //generate stats for a new crew member
      randomise();
    }
  }
  
  
  void randomise() {
    //Randomly determine vital stats for this CrewMember. Called by constructor when a saved JSON crewmember is not provided.
    luck = floor(random(5));
    gender = floor(random(2));
    lName = lastnames[floor(random(lastnames.length))];
    fName = ( (gender == GENDER_FEMALE) ? femalenames[floor(random(femalenames.length))] : malenames[floor(random(malenames.length))] );
    skills = new int[NUM_SKILLS];
    int pyramidHeight = 3;  //I am not including a check for pyramids too large for the skill pool. The skill assignment loop is lazy and will loop indefinitely if you pick a pyramid height without enough skills to support it
    for (int rank = 1; rank <= pyramidHeight; rank++) {
      for (int i = 0; i <= pyramidHeight-rank; i++) {
        int s = floor(random(NUM_SKILLS));
        while (skills[s] != 0) {
          s = floor(random(NUM_SKILLS));
        }
        skills[s] = rank;
      }
    }
  }
  

  
  String toFlatString() {
    //Return a human readable string representation of this CrewMember. Useful for debugging.
    String toReturn = "";
    toReturn += "Name: " + fName + " " + lName + "\n";
    toReturn += "Luck: " + luck + "\n";
    int topRank = 0;
    for (int i = 0; i < NUM_SKILLS; i++) {
      if (skills[i] > topRank) topRank = skills[i];
    }
    for (int i = topRank; i > 0; i--) {
      toReturn += "+" + i + " skills: ";
      String delim = "";
      for (int j = 0; j < NUM_SKILLS; j++) {
        if (skills[j] == i) {
          toReturn += delim + skillNames[j];
          delim = ", ";
        }
      }
      toReturn += "\n";
    }
    return toReturn;
  }
  
  
  JSONObject toJSON() {
    //Return this CrewMember in JSON notation for saving to file
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
    //Load in this CrewMember from a saved JSONObject
    fName = json.getString("fName");
    lName = json.getString("lName");
    gender = json.getInt("gender");
    luck = json.getInt("luck");
    JSONArray s = json.getJSONArray("skills");
    skills = s.getIntArray();
  }
  
  
}
