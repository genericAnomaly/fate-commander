public class Settings {
  
  //Skills
  String[] skillNames;
  float[] skillWeight;
  int numSkills;
  int skillPeak;
  
  //Names
  String namesLast[];
  String namesFemale[];
  String namesMale[];
  
  
  
  Settings() {
    //No argument supplied, load the defaults
    loadDefaults();
  }
  
  Settings(JSONObject json) {
    //json provided, read it in
    loadJson(json);
  }
  
  
  
  void loadDefaults () {
    //load/set the default values
    namesLast = loadStrings("last.txt");
    namesFemale = loadStrings("first_female.txt");
    namesMale = loadStrings("first_male.txt");
    setDefaultSkills();
  }
  

  
  JSONObject toJson() {
    JSONObject json = new JSONObject();
    json.setInt("numSkills", numSkills);
    json.setInt("skillPeak", skillPeak);
    JSONArray a;
    a = new JSONArray();
    for (int i=0; i<skillNames.length; i++) a.setString(i, skillNames[i]);
    json.setJSONArray("skillNames", a);
    a = new JSONArray();
    for (int i=0; i<skillWeight.length; i++) a.setFloat(i, skillWeight[i]);
    json.setJSONArray("skillWeight", a);
    return json;
  }
  
  void loadJson(JSONObject json) {
    //Load defaults first to populate anything missing from the saved settings
    loadDefaults();
    //Read in values from json. If a value is missing or otherwise fails to read, fall back on the defaults.
    numSkills = json.getInt("numSkills", numSkills);
    skillPeak = json.getInt("skillPeak", skillPeak);
    skillNames =  JSONObjectReader.getStringArray(json, "skillNames", skillNames);
    skillWeight = JSONObjectReader.getFloatArray(json, "skillWeight", skillWeight);
    //Validate everything
    validateSettings();
  }
  
  void validateSettings() {
    //Ensure skillPeak is not set too high to generate a pyramid
    int numActualSkills = 0;
    for (int i=0; i < skillWeight.length; i++) {
      if (skillWeight[i] > 0) numActualSkills++;
    }
    if ( (skillPeak*skillPeak+1)/2 > numActualSkills) println("[Error] Not enough skills present to generate skill pyramids " + skillPeak + " tall. Adjusting value...");
    while ( (skillPeak*skillPeak+1)/2 > numActualSkills) skillPeak--;
    
    //Ensure skillNames and skillWeight are the same length
    //If not, truncate or pad skillWeight to match skillNames
    if (skillNames.length != skillWeight.length) {
      println("[Error] Skill name and weight mismatch; adjusting...");
      float[] newSkillWeight = new float[skillNames.length];
      for (int i=0; i < skillNames.length; i++) {
        if (i < skillWeight.length) {
          newSkillWeight[i] = skillWeight[i];
        } else {
          newSkillWeight[i] = 1.0;
        }
      }
      skillWeight = newSkillWeight;
    }
    
    //Make sure numSkills is correct
    if (numSkills != skillNames.length) {
      println("[Error] " + skillNames.length + " skills are named but numSkills is " + numSkills + ". Setting numSkills to " + skillNames.length);
    }
    
  }
  
  
  void setDefaultSkills() {
    numSkills = 18;
    skillPeak = 3;
    skillNames = new String[numSkills];
    skillNames[Actor.SKILL_ATHLETICS]     = "Athletics";
    skillNames[Actor.SKILL_BURGLARY]      = "Burglary";
    skillNames[Actor.SKILL_CRAFTS]        = "Crafts";
    skillNames[Actor.SKILL_CONTACTS]      = "Contacts";
    skillNames[Actor.SKILL_DECEIVE]       = "Deceive";
    skillNames[Actor.SKILL_DRIVE]         = "Drive";
    skillNames[Actor.SKILL_EMPATHY]       = "Empathy";
    skillNames[Actor.SKILL_FIGHT]         = "Fight";
    skillNames[Actor.SKILL_INVESTIGATE]   = "Investigate";
    skillNames[Actor.SKILL_LORE]          = "Lore";
    skillNames[Actor.SKILL_NOTICE]        = "Notice";
    skillNames[Actor.SKILL_PHYSIQUE]      = "Physique";
    skillNames[Actor.SKILL_PROVOKE]       = "Provoke";
    skillNames[Actor.SKILL_RAPPORT]       = "Rapport";
    skillNames[Actor.SKILL_RESOURCES]     = "Resources";
    skillNames[Actor.SKILL_SHOOT]         = "Shoot";
    skillNames[Actor.SKILL_STEALTH]       = "Stealth";
    skillNames[Actor.SKILL_WILL]          = "Will";
    setDefaultSkillWeight();
  }
  
  void setDefaultSkillWeight() {
    //precondition: numSkills is set;
    skillWeight = new float[numSkills];
    for (int i = 0; i < numSkills; i++) skillWeight[i] = 1;
  }
  
  
  
  String toString() {
    //Mostly for debug, obvs
    String s = "Settings object\n";
    s += "Skills: " + numSkills + "\n";
    for (int i=0; i < numSkills; i++) s += "["+i+"] => \t" + skillNames[i] + " \t " + "(weight: " + skillWeight[i] + ")\n";
    return s; 
  }
  
  
  
}
