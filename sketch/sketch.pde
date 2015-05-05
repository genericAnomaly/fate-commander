String[] skillNames = new String[Actor.NUM_SKILLS];
float[] skillWeight = new float[Actor.NUM_SKILLS];

String pwd = "";
String lastnames[];
String femalenames[];
String malenames[];


int genCrewSize = 4;
Actor[] crew;

void setup() {
  print("Initialising...\n");
  lastnames = loadStrings(pwd+"last.txt");
  print("Loaded " + lastnames.length + " last names.\n");
  femalenames = loadStrings(pwd+"first_female.txt");
  print("Loaded " + femalenames.length + " female first names.\n");
  malenames = loadStrings(pwd+"first_male.txt");
  print("Loaded " + malenames.length + " male first names.\n");
  populateSkillNames();
  populateSkillWeight();

  testLocations();
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











void populateSkillNames() {
  skillNames[Actor.SKILL_ATHLETICS] = "Athletics";
  skillNames[Actor.SKILL_BURGLARY] = "Burglary";
  skillNames[Actor.SKILL_CRAFTS] = "Crafts";
  skillNames[Actor.SKILL_CONTACTS] = "Contacts";
  skillNames[Actor.SKILL_DECEIVE] = "Deceive";
  skillNames[Actor.SKILL_DRIVE] = "Pilot";
  skillNames[Actor.SKILL_EMPATHY] = "Empathy";
  skillNames[Actor.SKILL_FIGHT] = "Fight";
  skillNames[Actor.SKILL_INVESTIGATE] = "Investigate";
  skillNames[Actor.SKILL_LORE] = "Science";
  skillNames[Actor.SKILL_NOTICE] = "Notice";
  skillNames[Actor.SKILL_PHYSIQUE] = "Physique";
  skillNames[Actor.SKILL_PROVOKE] = "Provoke";
  skillNames[Actor.SKILL_RAPPORT] = "Rapport";
  skillNames[Actor.SKILL_RESOURCES] = "Resources";
  skillNames[Actor.SKILL_SHOOT] = "Shoot";
  skillNames[Actor.SKILL_STEALTH] = "Stealth";
  skillNames[Actor.SKILL_WILL] = "Will";
}

void populateSkillWeight() {
  skillWeight[Actor.SKILL_LORE] = 1.0;
  skillWeight[Actor.SKILL_CRAFTS] = 0.8;
  skillWeight[Actor.SKILL_INVESTIGATE] = 0.8;
  skillWeight[Actor.SKILL_DECEIVE] = 0.6;
  skillWeight[Actor.SKILL_EMPATHY] = 0.6;
  skillWeight[Actor.SKILL_NOTICE] = 0.6;
  skillWeight[Actor.SKILL_RAPPORT] = 0.6;
  skillWeight[Actor.SKILL_WILL] = 0.6;
  skillWeight[Actor.SKILL_ATHLETICS] = 0.5;
  skillWeight[Actor.SKILL_DRIVE] = 0.5;
  skillWeight[Actor.SKILL_FIGHT] = 0.5;
  skillWeight[Actor.SKILL_PHYSIQUE] = 0.5;
  skillWeight[Actor.SKILL_PROVOKE] = 0.5;
  skillWeight[Actor.SKILL_SHOOT] = 0.5;
  skillWeight[Actor.SKILL_BURGLARY] = 0.25;
  skillWeight[Actor.SKILL_STEALTH] = 0.25;
  skillWeight[Actor.SKILL_CONTACTS] = 0.0;
  skillWeight[Actor.SKILL_RESOURCES] = 0.0;
}

int pickRandomSkillWeighted() {
  //returns a random skill, influenced by skill weight
  int s = -1;
  while ( s == -1 || skillWeight[s] <= random(1) ) {
    //loop will run on first run and continue running until the skillWeight for s is satisfied 
    s = floor(random(Actor.NUM_SKILLS));
  }
  return s;
}

