public abstract class CommanderObject {
  private CommanderDocument document;
  private int id;
  
  CommanderObject(CommanderDocument d) {
    document = d;
  }
  
  CommanderObject(CommanderDocument d, JSONObject json) {
    document = d;
    id = json.getInt("id", -1);
  }
  
  protected CommanderDocument getDocument() {
    return document;
  }
  
  protected Settings getDocumentSettings() {
    return document.settings;
  }
  
  protected ArrayList<Actor> getDocumentActors() {
    return document.actorList;
  }
  
  protected ArrayList<Location> getDocumentLocations() {
    return document.locationList;
  }
  //I am not 100% sure about this access modifier scheme but it seems to make sense and if it's wrong it's a quick fix.
 
 protected void setID(int a) {
   id = a;
 }
 
 protected int getID() {
   //Something to check the validity of the IDs could go here (something like "if (document._List[ID] != this) document.setIDs();" would work, though it would need to check every subclass's list
   //I'd rather just have "run document.setIDs()" as a precondition to json exports and avoid losing a lot of time on checks
   return id;
 }
  
}
