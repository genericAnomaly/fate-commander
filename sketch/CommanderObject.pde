public abstract class CommanderObject {
  //Todo: should this be private with a protected getter method / protected getters for different document members?
  CommanderDocument document;
  
  CommanderObject(CommanderDocument d) {
    document = d;
  }
}
