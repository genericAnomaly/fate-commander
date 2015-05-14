//CommanderDocument sketchDocument;
TestDocument testDocument;

void setup() {
//  sketchDocument = new CommanderDocument();
  
  
  //testDocument = new TestDocument();
  //testDocument.testLoadSettings();
  //testDocument.testNPCGeneration(8);
  //testDocument.printActors();

  JSONObject saveFile = loadJSONObject("save/testsave.json");
  testDocument = new TestDocument(saveFile);
  testDocument.testLocations();
  println(testDocument);
  testDocument.testSave();
}


void draw() {
}

