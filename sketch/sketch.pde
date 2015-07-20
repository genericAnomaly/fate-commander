//CommanderDocument sketchDocument;
TestDocument testDocument;

void setup() {
//  sketchDocument = new CommanderDocument();
  
  
  testDocument = new TestDocument();
  //testDocument.testLoadSettings();
  //testDocument.printActors();

  JSONObject saveFile = loadJSONObject("save/testsave2.json");
  testDocument = new TestDocument(saveFile);
  
  //testDocument.testNPCGeneration(8);
  
  //testDocument.testLocations();
  //println(testDocument);
  //testDocument.testStress();
  //println(testDocument);
  //testDocument.testSave();
  
  testDocument.drySave();
  
  
  //testDocument.testBatchRolling();

  
}


void draw() {
}

