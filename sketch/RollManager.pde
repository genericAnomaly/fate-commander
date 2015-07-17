public class RollManager {
  
  
  
  
  
  
  
}


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

public class RollResult {
  
  //All rolls
  RollRequest request;      //RollRequest defining roll
  Actor target;             //Actor roll applied to
  int rollRaw;              //The raw result of target's roll
  int rollShifts;           //The number of shifts when the roll is compared to the success threshold
  
  //Outstanding rolls only
  ArrayList<NarrativeElement> complications;     //All NarrativeElements with matching skills or keywords 
  int alteredMinimum;                            //The minimum altered value of this roll if all potentially applicable negative NEs are applied
  int alteredMaximum;                            //The maximum altered value of this roll if all potentially applicable positive NEs are applied
  
}
