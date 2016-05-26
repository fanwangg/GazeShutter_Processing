public class Visualizer{
  final int PATH_DOT_SIZE = 20;
  int currentUserId;
  int currentTrailId;
  int currentTarget;
  boolean mDirtyFlag;

  String[] users;
  String[] trails;
  ArrayList<Point> currentPath;
  
  public Visualizer(){
    currentUserId = 0;
    currentTrailId = 0;
    mDirtyFlag = false;
  }
 
  void keyPressed(){
    users = listFileNames(dataPath(""));
    if(users==null || users.length==0)
      return;

    //update user
    if(keyCode == UP){
      currentUserId = (currentUserId+users.length-1) % users.length;
      currentTrailId = 0;
    }
    else if(keyCode == DOWN){
      currentUserId = (currentUserId+1) % users.length;
      currentTrailId = 0;
    }
    trails = listFileNames(dataPath(users[currentUserId]));
    if(trails==null || trails.length==0)
        return;
      //update trail
    if(keyCode == LEFT){
      currentTrailId = (currentTrailId+trails.length-1) % trails.length;  
    }
    else if(keyCode == RIGHT){
      currentTrailId = (currentTrailId+1) % trails.length;
    }
    
    
    //update map
    mDirtyFlag = true;
    //currentHM = new Heatmap(new ArrayList() );
    currentPath = new ArrayList<Point>();
    JSONObject trailJSON = loadJSONObject(dataPath(users[currentUserId]+"/"+trails[currentTrailId]));
    currentTarget = trailJSON.getInt(Trail.TARGET_KEY);
    JSONArray pathJSON = trailJSON.getJSONArray(Trail.PATH_KEY);
    for (int i = 0; i < pathJSON.size(); i++) {
      JSONObject point = pathJSON.getJSONObject(i);
      int x = point.getInt(Point.POINT_X_KEY);
      int y = point.getInt(Point.POINT_Y_KEY);
      int t = point.getInt(Point.POINT_T_KEY);
      int s = point.getInt(Point.POINT_STAGE_KEY);
      currentPath.add(new Point(x, y, t, s));
    }
    
  }
  
  void draw(){
    if(!mDirtyFlag)
      return;
    
    mDirtyFlag = false;

    noStroke();
    pushMatrix();
    translate(WIREFRAME_UL_X, WIREFRAME_UL_Y);
    background(COLOR_WHITE);
    //if(currentHM != null)
    //  currentHM.draw();

    int duration = currentPath.get(currentPath.size()-1).t;
    for(Point p:currentPath){
      if(p.stage != -1){
        fill(lerpColor(COLOR_BLUE, COLOR_RED, float(p.t)/duration));
        ellipse(p.x, p.y, PATH_DOT_SIZE, PATH_DOT_SIZE);
      }
    }

    popMatrix();
    
    drawWireframe();
    drawHomePosition();
    drawVisInfo();
  }
}