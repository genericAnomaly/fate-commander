public class RollManager extends CommanderObject {
  
  ArrayList<RollResult> outstanding;
  
  
  RollManager(CommanderDocument d) {
    //TODO
    super(d);
  }
  
  
  //TODO: Extend CommanderObject? Needs awareness enough to reach Settings
  
  //TODO: JSONable?
    //Worry
    //About it laaater
  
  
  
  void batchRoll(RollRequest rr, ArrayList<Actor> selection) {
    //ArrayList<RollResult> results = new ArrayList<RollResult>();
    for (Actor a : selection) {
      //results.add( new RollResult(rr, a) );
      RollResult result = new RollResult(rr, a);
      
      println("[Roll] " + result.target.getName() + " rolling " + getDocumentSettings().skillNames[rr.skillIndex] + " (+" + result.target.skills[rr.skillIndex] + ") against a difficulty of " + result.request.threshold);
      println("       " + "rolled " + result.rollRaw + ", for " + result.rollShifts + " shifts, with " + result.complications.size() + " potentially applicable Narrative Elements and a variance of " + result.alteredMinimumShifts + " to " + result.alteredMaximumShifts);
      if (result.isOutstanding() ) println("       " + "Applicable NarrativeElements could potentially alter outcome of roll! Adding to Outstanding Rolls queue.");
      
      //TODO: if rr generates stress on failure, hand it out
      //Use a separate method to handle that so it can work on rolls after they're moved to Outstanding
      
    }
    
    
    
  }
  
  
  
  
  
  
  
  
}






// RollRequest
//======================================================================================================================================

public class RollRequest {
  
  int threshold;                    //The success threshold of this Roll
  int skillIndex;                   //The skill this Roll requires

  Boolean stressOnFailure;           //Should this Roll inflict stress on Actors that fail it?
  int stressType;                   //The type of stress that failing this roll will inflict
  
  String description;               //A short description of this Roll that will be included when the roll is logged and applied to any StressPackets it generates
  ArrayList<String> keywords;       //Any keywords associated with this Roll for checking against NarrativeElements on targeted Actors
  
  
  RollRequest() {
    init();
  }
  
  
  
  private void init() {
    threshold = 0;
    skillIndex = 0;
    stressOnFailure = false;
    stressType = 0;
    description = "Undescribed Roll";  //TODO: Should this grab a unique number from the RollManager? Maybe leave it null and have RollManager populate it with a unique Roll# when it actually rolls
    keywords = new ArrayList<String>();
  }
  
  
}






//RollResult
//======================================================================================================================================

public class RollResult {
  
  //All rolls
  RollRequest request;      //RollRequest defining roll
  Actor target;             //Actor roll applied to
  int rollRaw;              //The raw result of target's roll
  int rollShifts;           //The number of shifts when the roll is compared to the success threshold
  
  //Outstanding rolls only
  ArrayList<NarrativeElement> complications;     //All NarrativeElements with matching skills or keywords 
  int alteredMinimumShifts;                      //The minimum altered value of this roll if all potentially applicable negative NEs are applied
  int alteredMaximumShifts;                      //The maximum altered value of this roll if all potentially applicable positive NEs are applied



  RollResult(RollRequest rr, Actor a) {
    //Must perform the roll in the constructor
    request = rr;
    target = a;
    rollRaw = a.roll(rr.skillIndex);
    rollShifts = rollRaw - rr.threshold;
    
    //TODO:
    complications = new ArrayList<NarrativeElement>(); //TODO: fetch all potentially applicable NEs
    alteredMinimumShifts = rollShifts;
    alteredMaximumShifts = rollShifts;
    for (NarrativeElement ne : complications) {
      if (ne.value < 0) alteredMinimumShifts += ne.value;
      if (ne.value > 0) alteredMaximumShifts += ne.value;
    }
  }
  
  
  Boolean isOutstanding() {
    if (rollShifts > 0 && alteredMinimumShifts <= 0) return true;
    if (rollShifts <= 0 && alteredMaximumShifts < 0) return true;
    return false;
  }
  
  

  
}
















