//CommanderDocument sketchDocument;
TestDocument testDocument;

void setup() {
//  sketchDocument = new CommanderDocument();
  
  
  //testDocument = new TestDocument();
  //testDocument.testLoadSettings();
  //testDocument.testNPCGeneration(8);
  //testDocument.printActors();
  //testDocument.testLocations();
  //testDocument.testSave();
  JSONObject saveFile = loadJSONObject("save/testsave.json");
  testDocument = new TestDocument(saveFile);
  println(testDocument);
}


void draw() {
}

