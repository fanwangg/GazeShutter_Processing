public enum STAGE{
  STAGE_0, STAGE_1, STAGE_2, STAGE_3, STAGE_4, STAGE_5, STAGE_6;

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
  static final String DESIGN_KEY = "design";
  static final String DURATION_KEY = "duration";

  
  int trailID;
  int userID;
  int target;
  int startTime;
  int duration;
  DESIGN design;
  STAGE stage;
  STAGE prevStage;
  ArrayList<Point> path;
  
  Trail(int user, int trail, int target){
    this.startTime = millis();
    this.userID = user;
    this.trailID = trail;
    this.target = target; 
    this.stage = STAGE.STAGE_0;
    this.prevStage = STAGE.STAGE_0;
    this.design = PilotStudy.mDesign;

    this.path = new ArrayList<Point>();
  }

  Trail(JSONObject trailJSON){
    this.userID = trailJSON.getInt(Trail.USER_KEY);
    this.trailID = trailJSON.getInt(Trail.TRAIL_KEY);;
    this.target = trailJSON.getInt(Trail.TARGET_KEY);
    this.design = DESIGN.valueOf(trailJSON.getString(Trail.DESIGN_KEY));
    this.path = loadPathFromJson(trailJSON);
  }


  public void update(){
    int x = (mouseX - WIREFRAME_UL_X);
    int y = (mouseY - WIREFRAME_UL_Y);
    int elapsedTime = millis() - startTime;
    updateStage();
    updateDuration(elapsedTime);
    path.add(new Point(x, y, elapsedTime, this.stage.ordinal()));
  }
  
  public void output(){
    JSONObject json = new JSONObject();
    json.setInt(USER_KEY,  userID);
    json.setInt(TRAIL_KEY, trailID);
    json.setInt(TARGET_KEY, target);
    json.setInt(DURATION_KEY, duration);
    json.setString(DESIGN_KEY, design.name());
  
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
    
    String fileName = new String(userID+"/"+mDesign+"_"+trailID+"_"+target+".json");
    saveJSONObject(json, outputPath+fileName);
  }

  void updateStage(){
    if(stage==STAGE.STAGE_0 && isWithinTarget(this))
      stage = STAGE.STAGE_1;
    else if(stage==STAGE.STAGE_1 && !isWithinTarget(this))
      stage = STAGE.STAGE_2;
    else if(stage==STAGE.STAGE_2 && isWithinHaloButton(this))
      stage = STAGE.STAGE_3;
    else if(stage==STAGE.STAGE_3 && !isWithinHaloButton(this))
      stage=STAGE.STAGE_4;
    else if(stage==STAGE.STAGE_4 && isWithinTarget(this))
      stage=STAGE.STAGE_5;
    else if(stage==STAGE.STAGE_5 && !isWithinTarget(this))
      stage=STAGE.STAGE_6;
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

  int getLastTimestamp(){
    return path.get(path.size()-1).t;
  }

  int getDuration(){
    return duration;
  }

  ArrayList<Point> loadPathFromJson(JSONObject trailJSON){
    ArrayList<Point> path = new ArrayList<Point>();

    JSONArray pathJSON = trailJSON.getJSONArray(Trail.PATH_KEY);
    for (int j=0; j<pathJSON.size(); j++) {
      JSONObject point = pathJSON.getJSONObject(j);
      int x = point.getInt(Point.POINT_X_KEY);
      int y = point.getInt(Point.POINT_Y_KEY);
      int t = point.getInt(Point.POINT_T_KEY);
      int s = point.getInt(Point.POINT_STAGE_KEY);
      path.add(new Point(x, y, t, s));
    }

    return path;
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