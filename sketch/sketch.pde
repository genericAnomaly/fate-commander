String[] skillNames = new String[CrewMember.NUM_SKILLS];

String pwd = "";
String lastnames[];
String femalenames[];
String malenames[];


int genCrewSize = 4;
CrewMember[] crew;

void setup() {
  print("Initialising...\n");
  lastnames = loadStrings(pwd+"last.txt");
  print("Loaded " + lastnames.length + " last names.\n");
  femalenames = loadStrings(pwd+"first_female.txt");
  print("Loaded " + femalenames.length + " female first names.\n");
  malenames = loadStrings(pwd+"first_male.txt");
  print("Loaded " + malenames.length + " male first names.\n");
  populateSkillNames();
  


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
}



void generateNewCrew(int size) {
  print("Generating New Crew Manifest...\n");
  print("Crew size: " + size + "\n");
  crew = new CrewMember[size];
  for (int i = 0; i < crew.length; i++) {
    crew[i] = new CrewMember();
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
  crew = new CrewMember[j.size()];
  for (int i = 0; i < crew.length; i++) {
    crew[i] = new CrewMember(j.getJSONObject(i));
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
  skillNames[CrewMember.SKILL_ATHLETICS] = "Athletics";
  skillNames[CrewMember.SKILL_BURGLARY] = "Burglary";
  skillNames[CrewMember.SKILL_DECEIVE] = "Deceive";
  skillNames[CrewMember.SKILL_PILOT] = "Pilot";
  skillNames[CrewMember.SKILL_EMPATHY] = "Empathy";
  skillNames[CrewMember.SKILL_FIGHT] = "Fight";
  skillNames[CrewMember.SKILL_INVESTIGATE] = "Investigate";
  skillNames[CrewMember.SKILL_LORE] = "Science";
  skillNames[CrewMember.SKILL_NOTICE] = "Notice";
  skillNames[CrewMember.SKILL_PHYSIQUE] = "Physique";
  skillNames[CrewMember.SKILL_PROVOKE] = "Provoke";
  skillNames[CrewMember.SKILL_RAPPORT] = "Rapport";
  skillNames[CrewMember.SKILL_SHOOT] = "Shoot";
  skillNames[CrewMember.SKILL_STEALTH] = "Stealth";
  skillNames[CrewMember.SKILL_WILL] = "Will";
}



  

