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

  
  public NarrativeElement(String n, String d, int t) {
    init();
    name = n;
    description = d;
    if (t >= 0 && t < 5) type = t;
  }

  public NarrativeElement(JSONObject json) {
    init();
    loadJSON(json);
  }
  
  public NarrativeElement() {
    init();
    description = "Empty constructor NarrativeElement - for use as a factory object only!";
  }
  
  
  public void init() {
    name = "Name";
    description = "Description";
    type = ELEMENT_TYPE_NOTE;
    isDisabled = false;
  }
  
  public void loadJSON(JSONObject json) {
    name = json.getString("name", name);
    description = json.getString("description", description);
    type = json.getInt("type", type);
    isDisabled = json.getBoolean("isDisabled", isDisabled);
  }
  
  public JSONObject toJSON() {
    JSONObject json = new JSONObject();
    json.setString("name", name);
    json.setString("description", description);
    json.setInt("type", type);
    json.setBoolean("isDisabled", isDisabled);
    return json;
  }
  
  
  public NarrativeElement construct(JSONObject json) {
    return new NarrativeElement(json);
  }
  
}
