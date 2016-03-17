public enum STAGE{
  STAGE_0, STAGE_1, STAGE_2, STAGE_3;

  private static STAGE[] stages = values();
  public STAGE next(){  
    if(this.ordinal()+1 != stages.length)
      return stages[(this.ordinal()+1) % stages.length];
    else
      return this;
  }
}


public class Trail{
  static final String USER_KEY = "userID";
  static final String TRAIL_KEY = "trailID";
  static final String TARGET_KEY = "target";
  static final String PATH_KEY = "path";
  
  int trailID;
  int userID;
  int target;
  int startTime;
  int duration;
  STAGE curStage;
  ArrayList<Point> path;
  
  Trail(int user, int trail, int target){
    this.startTime = millis();
    this.userID = user;
    this.trailID = trail;
    this.target = target; 
    this.curStage = STAGE.STAGE_0;
    path = new ArrayList<Point>();
  }
  
  public void update(){
    int x = (mouseX - WIREFRAME_UL_X);
    int y = (mouseY - WIREFRAME_UL_Y);
    int elapsedTime = millis() - startTime;
    updateCurStage();
    updateDuration(elapsedTime);
    path.add(new Point(x, y, elapsedTime, this.curStage.ordinal()));
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
      point.setInt(Point.POINT_STAGE_KEY, path.get(i).stage);
      pathJSON.setJSONObject(i, point);
    }
    json.setJSONArray(PATH_KEY, pathJSON);
    
    String fileName = new String(userID+"/"+trailID+"_"+target+".json");
    saveJSONObject(json, outputPath+fileName);
  }

  void updateCurStage(){
    if(curStage==STAGE.STAGE_0 && isWithinTarget(this))
      curStage=STAGE.STAGE_1;
    else if(curStage==STAGE.STAGE_1 && isWithinHaloButton(this))
      curStage=STAGE.STAGE_2;
    else if(curStage==STAGE.STAGE_2 && isWithinTarget(this))
      curStage=STAGE.STAGE_3;
  }

  int getRow(){
    return target/TARGET_COL_NUM;
  }

  int getCol(){
    return target%TARGET_COL_NUM;
  }

  void updateDuration(int elapsedTime){
    if(elapsedTime > this.duration)
      duration = elapsedTime;
    return;
  }
}

public class Point{
  static final String POINT_X_KEY = "x";
  static final String POINT_Y_KEY = "y";
  static final String POINT_T_KEY = "t";
  static final String POINT_STAGE_KEY = "s";

  //t for elapsed time in milles
  int t;  
  int x, y;
  int stage;
  
  Point(int x, int y, int t, int s){
    this.x = x;
    this.y = y;
    this.t = t;  
    this.stage = s;
  }
}