public abstract class CommanderObject {
  private CommanderDocument document;
  
  CommanderObject(CommanderDocument d) {
    document = d;
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
  
}
