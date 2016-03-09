public class Trail{
  static final String USER_KEY = "userID";
  static final String TRAIL_KEY = "trailID";
  static final String TARGET_KEY = "target";
  static final String PATH_KEY = "path";
  
  int trailID;
  int userID;
  int target;
  int startTime;
  ArrayList<Point> path;
  
  Trail(int user, int trail, int target){
    this.startTime = millis();
    this.userID = user;
    this.trailID = trail;
    this.target = target; 
    path = new ArrayList<Point>();
  }
  
  public void update(){
    int x = (mouseX - WIREFRAME_UL_X);
    int y = (mouseY - WIREFRAME_UL_Y);
    int elapsedTime = millis() - startTime;
    path.add(new Point(x, y, elapsedTime));
  }
  
  public void output(){
    JSONObject json = new JSONObject();
    json.setInt(USER_KEY,  userID);
    json.setInt(TRAIL_KEY, trailID);
    json.setInt(TARGET_KEY, target);
  
    JSONArray pathJSON = new JSONArray();
    for (int i = 0; i < path.size(); i++){
      JSONObject point = new JSONObject();
      point.setInt(Point.POINT_X_KEY, path.get(i).x);
      point.setInt(Point.POINT_Y_KEY, path.get(i).y);
      point.setInt(Point.POINT_T_KEY, path.get(i).t);
      pathJSON.setJSONObject(i, point);
    }
    json.setJSONArray(PATH_KEY, pathJSON);
    
    String fileName = new String(userID+"/"+trailID+"_"+target+".json");
    saveJSONObject(json, outputPath+fileName);
  }
}

public class Point{
  static final String POINT_X_KEY = "x";
  static final String POINT_Y_KEY = "y";
  static final String POINT_T_KEY = "t";
  
  //t for elapsed time in milles
  int t;  
  int x, y;
  
  Point(int x, int y, int t){
    this.x = x;
    this.y = y;
    this.t = t;  
  }
}