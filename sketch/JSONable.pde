public interface JSONable {
  JSONObject toJSON();
  void loadJSON(JSONObject json);
}
