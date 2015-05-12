public class TestDocument extends CommanderDocument {
  //Debug only CommanderDocument to dump test cases in
  
  TestDocument() {
    super();
  }
  
  TestDocument(JSONObject json) {
    super(json);
  }
  
  
  
  void testNPCGeneration(int size) {
    println("Generating New NPC List...");
    actorList = new ArrayList<Actor>(size);
    for (int i = 0; i < size; i++) {
      actorList.add(new Actor(this));
    }
  }
  
  void printActors() {
    println("Printing NPC List...\n");
    for (int i = 0; i < actorList.size(); i++) {
      print(actorList.get(i).toString());
    }
  }
  
  void testLoadSettings() {
    settings = new Settings(loadJSONObject("save/settings.json"));
  }
  
  void testLocations() {
    
    locationList.add( new Location("Location #1", "loc_1") );
    locationList.add( new Location("Location #2", "loc_2") );
    testNPCGeneration(4);
    printActors();
    locationList.get(0).addActor(actorList.get(0));
    locationList.get(0).addActor(actorList.get(1));
    locationList.get(0).addActor(actorList.get(2));
    locationList.get(1).addActor(actorList.get(3));
    println(locationList.get(0).toString());
    println(locationList.get(1).toString());
    println("Adding " + actorList.get(0).getName() + " to Location #2"); 
    locationList.get(1).addActor(actorList.get(0));
    println(locationList.get(0).toString());
    println(locationList.get(1).toString());
    println("Childing Location #2 to Location #1");
    locationList.get(0).addChild(locationList.get(1));
    println(locationList.get(0).toString());
  }
  
  void testSave() {
    JSONObject json = toJSON();
    saveJSONObject(json, "save/testsave.json");
  }
  
}