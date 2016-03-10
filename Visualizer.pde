public class Visualizer{
  String[] users;
  String[] trails;
  int currentUserId;
  int currentTrailId;
  int currentTarget;
  Heatmap currentHM;
  boolean mDirtyFlag;
  
  public Visualizer(){
    users = listFileNames(dataPath(""));
    currentUserId = 0;
    currentTrailId = 0;
    mDirtyFlag = false;
  }
 
  void keyPressed(){
    //update user
   
    if(keyCode == UP){
      currentUserId = (currentUserId+users.length-1) % users.length;
    }
    else if(keyCode == DOWN){
      currentUserId = (currentUserId+1) % users.length;
    }
    trails = listFileNames(dataPath(users[currentUserId]));
    //update trail
    if(keyCode == LEFT){
      currentTrailId = (currentTrailId+trails.length-1) % trails.length;  
    }
    else if(keyCode == RIGHT){
      currentTrailId = (currentTrailId+1) % trails.length;
    }
    
    
    //update map
    mDirtyFlag = true;
    currentHM = new Heatmap(new ArrayList() );
    JSONObject trailJSON = loadJSONObject(dataPath(users[currentUserId]+"/"+trails[currentTrailId]));
    currentTarget = trailJSON.getInt(Trail.TARGET_KEY);
    JSONArray pathJSON = trailJSON.getJSONArray(Trail.PATH_KEY);
    for (int i = 0; i < pathJSON.size(); i++) {
      JSONObject point = pathJSON.getJSONObject(i);
      int x = point.getInt(Point.POINT_X_KEY);
      int y = point.getInt(Point.POINT_Y_KEY);
      int t = point.getInt(Point.POINT_T_KEY);
      currentHM.click(x,y);
    }
    
  }
  
  void draw(){
    if(!mDirtyFlag)
      return;
    mDirtyFlag = true;

    noStroke();
    pushMatrix();
    translate(WIREFRAME_UL_X, WIREFRAME_UL_Y);
    background(COLOR_WHITE);
    if(currentHM != null)
      currentHM.draw();
    popMatrix();
    
    drawWireframe();
    drawHomePosition();
    drawVisInfo();
  }
}