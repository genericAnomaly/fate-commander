public class NarrativeElement implements JSONable<NarrativeElement> {
  
  static final int ELEMENT_TYPE_ASPECT = 0;
  static final int ELEMENT_TYPE_STUNT = 1;
  static final int ELEMENT_TYPE_CONSEQUENCE = 2;
  static final int ELEMENT_TYPE_EXTRA = 3;
  static final int ELEMENT_TYPE_NOTE = 4;
  
  String name;
  String description;
  int type;
  Boolean isDisabled;  //For muting aspects without deleting them
  
  //Mechanical tie-ins; this stuff all strictly TODO atm. Ideally, any rolls on actors will check for relevant narrative aspects and prompt the GM whether to apply them or not.
  Boolean[] skillsAffected;          //Map of all skills this NE could potentially modify
  ArrayList<String> keywords;        //List of keywords to check for when determining if this NE applies to a roll
  int value;                         //Roll modifier when this NE is invoked

  
  NarrativeElement(String n, String d, int t) {
    init();
    name = n;
    description = d;
    if (t >= 0 && t < 5) type = t;
  }

  NarrativeElement(JSONObject json) {
    init();
    loadJSON(json);
  }
  
  NarrativeElement() {
    init();
    description = "Empty constructor NarrativeElement - for use as a factory object only!";
  }
  
  NarrativeElement construct(JSONObject json) {
    return new NarrativeElement(json);
  }

  
  
  public void init() {
    name = "Name";
    description = "Description";
    type = ELEMENT_TYPE_NOTE;
    isDisabled = false;
    
    value = 0;
    keywords = new ArrayList<String>();
    skillsAffected = new Boolean[0];  //Must init to empty since NE's aren't allowed to know the Document
  }
  
  void loadJSON(JSONObject json) {
    name = json.getString("name", name);
    description = json.getString("description", description);
    type = json.getInt("type", type);
    isDisabled = json.getBoolean("isDisabled", isDisabled);
    value = json.getInt("value", value);
    //skillsAffected = JSONObjectReader.getBooleanArray(json, "skillsAffected", skillsAffected);
    //TODO: Better support for reading in ArrayLists?
    String[] kw = JSONObjectReader.getStringArray(json, "keywords", new String[0] );
    keywords = new ArrayList<String>();
    for (String s : kw) keywords.add(s);
  }
  
  JSONObject toJSON() {
    JSONObject json = new JSONObject();
    json.setString("name", name);
    json.setString("description", description);
    json.setInt("type", type);
    json.setBoolean("isDisabled", isDisabled);
    json.setInt("value", value);
    json.setJSONArray("skillsAffected", JSONObjectReader.booleanArrayToJSONArray(skillsAffected));
    json.setJSONArray("keywords",       JSONObjectReader.stringArrayToJSONArray(keywords.toArray(new String[keywords.size()])));
    return json;
  }
  
  
  
  
  
  
  
  
  // Mechanical hooks
  //===============================================================

  //Skill checks
  Boolean affectsSkill(int skillIndex) {
    if (skillsAffected.length < skillIndex) return false;
    return skillsAffected[skillIndex];
  }
  void addSkill(int skillIndex) {
    if (skillsAffected.length < skillIndex) {
      Boolean[] s = new Boolean[skillIndex+1];
      for (int i = 0; i < skillsAffected.length; i++) s[i] = skillsAffected[i];
      skillsAffected = s;
    }
    skillsAffected[skillIndex] = true;
  }
  void removeSkill(int skillIndex) {
    if (skillsAffected.length < skillIndex) return;
    skillsAffected[skillIndex] = false;
  }
  Boolean affectsKeyword(String kw) {
    if (keywords.contains(kw)) return true;
    return false;
  }
  void addKeyword(String kw) {
    if (keywords.contains(kw)) return;
    keywords.add(kw);
  }
  void removeKeyword(String kw) {
    if (keywords.contains(kw)) keywords.remove(kw);
  }
  
  
  
  
}
