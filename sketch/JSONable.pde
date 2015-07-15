public interface JSONable <T extends JSONable> {  //All classes implementing JSONable MUST self-type it (i.e. Actor implements JSONable<Actor>)
  JSONObject toJSON();
  void loadJSON(JSONObject json);
  T construct(JSONObject json);
}
