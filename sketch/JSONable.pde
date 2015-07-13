public interface JSONable <T extends JSONable> {  //All classes implementing JSONable MUST self-type it (i.e. Actor implements JSONable<Actor>)
  public JSONObject toJSON();
  public void loadJSON(JSONObject json);
  public T construct(JSONObject json);
}
