public class NarrativeElement {
  
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
  Boolean[] skillsAffected;  //Map of all skills this aspect could potentially effect
  ArrayList<String> keywords;  

  
  public NarrativeElement(String n, String d, int t) {
    name = n;
    description = d;
    type = ELEMENT_TYPE_NOTE;
    if (t >= 0 && t < 5) type = t;
  }

  public NarrativeElement(JSONObject json) {
    //TODO
  }
  
  
  
  
  public void loadJSON(JSONObject json) {
    //TODO
  }
  
  public JSONObject toJSON() {
    //TODO
    return new JSONObject();
  }
  
}
