CommanderDocument sketchDocument;
TestDocument testDocument;

void setup() {
  sketchDocument = new CommanderDocument();
  
  
  testDocument = new TestDocument();
  testDocument.testLoadSettings();
  testDocument.testNPCGeneration(8);
  testDocument.printActors();
  testDocument.testLocations();
  testDocument.testSave();
}






void draw() {
}



/*
void saveCrew(String path) {
  print("Saving Crew Manifest...\n");
  JSONArray j = new JSONArray();
  for (int i = 0; i < crew.length; i++) {
    j.setJSONObject(i, crew[i].toJson());
  }
  saveJSONArray(j, path);
}

void loadCrew(String path) {
  print("Loading Crew Manifest...\n");
  JSONArray j  = loadJSONArray(path);
  crew = new Actor[j.size()];
  for (int i = 0; i < crew.length; i++) {
    crew[i] = new Actor(sketchDocument, j.getJSONObject(i));
  }
  print("Loaded " + crew.length + " Crewmembers.\n");
}
*/





