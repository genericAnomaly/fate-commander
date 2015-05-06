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
    //load defaults first to populate anything missing from the saved settings
    loadDefaults();
    //Should this involve temp vars and null checks, or try/catch? Answer: YES. VERY YES. THIS NEEDS FIXING
    numSkills = json.getInt("numSkills");
    skillPeak = 3; //json.getInt("skillPeak"); 
    skillNames = json.getJSONArray("skillNames").getStringArray();
    skillWeight = jsonGetFloatArray(json.getJSONArray("skillWeight"));
    validateSkillPeak();
  }
  
  float[] jsonGetFloatArray(JSONArray json) { //Because for some reason this was missing from the built-in JSONArray object when I wrote this
    float[] a = new float[json.size()];
    for (int i=0; i < a.length; i++) a[i] = json.getFloat(i);
    return a;
  }
  
  void validateSkillPeak() {
    //Ensure skillPeak is not set too high to generate a pyramid
    int numActualSkills = 0;
    for (int i=0; i < skillWeight.length; i++) {
      if (skillWeight[i] > 0) numActualSkills++;
    }
    while ( (skillPeak*skillPeak+1)/2 > numActualSkills) skillPeak--;
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
