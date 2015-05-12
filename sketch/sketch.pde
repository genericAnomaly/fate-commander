CommanderDocument sketchDocument = new CommanderDocument();

Settings SETTINGS; 

int genCrewSize = 4;
Actor[] crew;

void setup() {
  
  
  
  SETTINGS = new Settings(loadJSONObject("save/settings.json"));
  println(SETTINGS);
  
  testLocations();
  
  //testSettings();
}


void testSettings() {
  Settings s = new Settings(loadJSONObject("save/settings.json"));
  //saveJSONObject(s.toJson(), "save/settings.json");
  
}




void draw() {
}


void keyPressed() {
  if (key=='s') buttonSaveCrew();
  if (key=='l') buttonLoadCrew();
  if (key=='n') generateNewCrew(genCrewSize);
  if (key=='+' && genCrewSize < 128) genCrewSize ++;
  if (key=='-' && genCrewSize > 1) genCrewSize --;
  if (key=='-' || key=='+') println("sizeToGenerate: " + genCrewSize);
  if (key=='p') printCrewManifest();
  //println("KeyPressed: " + key);
  if (key=='h') print("Debug stuff\n'n'\tGenerate new crew\n's'\tSave crew\n'l'\tLoad crew\n'p'\tPrint crew\n+/-\tIncrease/decrease size of crew to generate");
}


Location[] locations;
void testLocations() {
  locations = new Location[2];
  locations[0] = new Location("Location #1", "loc_1");
  locations[1] = new Location("Location #2", "loc_2");
  generateNewCrew(4);
  printCrewManifest();
  locations[0].addActor(crew[0]);
  locations[0].addActor(crew[1]);
  locations[0].addActor(crew[2]);
  locations[1].addActor(crew[3]);
  locations[0].printActors();
  locations[1].printActors();
  locations[1].addActor(crew[0]);
  locations[0].printActors();
  locations[1].printActors();
  println("----");
  locations[0].addChild(locations[1]);
  locations[0].printLocation();
}


void generateNewCrew(int size) {
  print("Generating New Crew Manifest...\n");
  print("Crew size: " + size + "\n");
  crew = new Actor[size];
  for (int i = 0; i < crew.length; i++) {
    crew[i] = new Actor();
  }
}

void saveCrew(String path) {
  print("Saving Crew Manifest...\n");
  JSONArray j = new JSONArray();
  for (int i = 0; i < crew.length; i++) {
    j.setJSONObject(i, crew[i].toJSON());
  }
  saveJSONArray(j, path);
}

void loadCrew(String path) {
  print("Loading Crew Manifest...\n");
  JSONArray j  = loadJSONArray(path);
  crew = new Actor[j.size()];
  for (int i = 0; i < crew.length; i++) {
    crew[i] = new Actor(j.getJSONObject(i));
  }
  print("Loaded " + crew.length + " Crewmembers.\n");
}

void printCrewManifest() {
  print("Printing Current Crew Manifest...\n");
  print("Crew size: " + crew.length + "\n");
  for (int i = 0; i < crew.length; i++) {
    print(crew[i].toFlatString());
  }
}


void buttonSaveCrew() {
  selectInput("Save crew to JSON", "onSaveSelected");
}
void onSaveSelected (File f) {
  if (f==null) {
    return;
  } else {
    saveCrew(f.getAbsolutePath());
  }
}

void buttonLoadCrew() {
  selectInput("Load crew from a file...", "onLoadSelected");
}
void onLoadSelected (File f) {
  if (f==null) {
    return;
  } else {
    loadCrew(f.getAbsolutePath());
  }
}











