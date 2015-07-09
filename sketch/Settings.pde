public class Settings {
  
  //Skills
  String[] skillNames;
  float[] skillWeight;
  int numSkills;
  int skillPeak;
  
  //Stress
  String[] stressNames;
  int[] stressSkills;
  int numStressTracks;
  
  //Names
  String namesLast[];
  String namesFemale[];
  String namesMale[];
  
  
  //Constructors
  Settings() {
    //No argument supplied, load the defaults
    loadDefaults();
  }
  
  Settings(JSONObject json) {
    //json provided, read it in
    loadJSON(json);
  }
  
  
  
  void loadDefaults () {
    //load/set the default values
    //NB: All Processing's load methods rely on a sketch global set by setup and accessible by running dataPath(""); to avoid frustration just stop making objects outside of setup
    namesLast = loadStrings("last.txt");
    namesFemale = loadStrings("first_female.txt");
    namesMale = loadStrings("first_male.txt");
    setDefaultSkills();
    setDefaultStress();
  }
  

  
  JSONObject toJSON() {
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
  
  void loadJSON(JSONObject json) {
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
  
  void setDefaultStress() {
    stressNames = new String[2];
    stressSkills = new int[2];
    stressNames[0] = "Physical";
    stressNames[1] = "Mental";
    stressSkills[0] = Actor.SKILL_PHYSIQUE;
    stressSkills[1] = Actor.SKILL_WILL;
    numStressTracks = 2;
  }
  
  
  String toString() {
    //Mostly for debug, obvs
    String s = "Settings object\n";
    s += "Skills: " + numSkills + "\n";
    for (int i=0; i < numSkills; i++) s += "["+i+"] => \t" + skillNames[i] + " \t " + "(weight: " + skillWeight[i] + ")\n";
    s += "Names (l/f/m): " + namesLast.length + "/" + namesFemale.length + "/" + namesMale.length + "\n";
    return s; 
  }
  
  //Actor generation helpers
  String getRandomFirstName(int gender) {
    return ( (gender == Actor.GENDER_FEMALE) ? namesFemale[floor(random(namesFemale.length))] : namesMale[floor(random(namesMale.length))] );
  }
  String getRandomLastName() {
    return namesLast[floor(random(namesLast.length))];
  }
  int[] getRandomSkillPyramid() {
    int[] skills = new int[numSkills];
    for (int rank = skillPeak; rank > 0; rank--) {
      for (int i = 0; i <= skillPeak-rank; i++) {
        int s = getRandomSkill();
        while (skills[s] != 0) {
          s = getRandomSkill();
        }
        skills[s] = rank;
      }
    }
    return skills;
  }
  int getRandomSkill() {
    int s = -1;
    while ( s == -1 || skillWeight[s] <= random(1) ) {
      s = floor(random(numSkills));
    }
    return s;
  }
  
}


/*
//NB: Consider replacing all these loosely associated arrays in Settings with specialised struct-y classes in the long term, something like this
public class StressDefinition implements JSONable {
  int skill;
  String name;
}
*/

