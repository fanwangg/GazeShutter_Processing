public class Visualizer{
  final int PATH_DOT_SIZE = 20;
  int currentUserId;
  int currentTrailId;
  int currentTarget;
  boolean mDirtyFlag;

  String[] userNames;
  String[] trailNames;
  ArrayList<Trail> trails;
  ArrayList<Point> currentPath;
  
  public Visualizer(){
    currentUserId = 0;
    currentTrailId = 0;
    mDirtyFlag = false;

    loadUsers();
    loadTrails();
  }
 
  void keyPressed(){
    //update user
    if(keyCode == UP){
      currentUserId = (currentUserId+userNames.length-1) % userNames.length;
      loadTrails();
    }
    else if(keyCode == DOWN){
      currentUserId = (currentUserId+1) % userNames.length;
      loadTrails();
    }
    else if(key=='r'){
      loadTrails();
    }

    if(keyCode == LEFT){
      currentTrailId = (currentTrailId+trailNames.length-1) % trailNames.length;  
      currentPath = trails.get(currentTrailId).path;
    }
    else if(keyCode == RIGHT){
      currentTrailId = (currentTrailId+1) % trailNames.length;
      currentPath = trails.get(currentTrailId).path;
    }

  }

  void loadUsers(){
    userNames = listFileNames(dataPath(""));
  }

  void loadTrails(){
    if(userNames==null || userNames.length==0){
      return; 
    }
    currentTrailId = 0;

    trailNames = listFileNames(dataPath(userNames[currentUserId]));
    trails = new ArrayList<Trail>();

    for(int i=0; i<trailNames.length; i++){
      JSONObject trailJSON = loadJSONObject(dataPath(userNames[currentUserId]+"/"+trailNames[i]));
      trails.add(new Trail(trailJSON));
    }
    currentPath = trails.get(0).path;
  }

  void drawPaths(int target){
    for(Trail t:trails){
      if(t.target == target){
        drawSinglePath(t.path);
      }
    }
    return;
  }

  void drawSinglePath(ArrayList<Point> path){
    for(Point p:path){
      if(p.stage != -1){
        fill(lerpColor(COLOR_BLUE, COLOR_RED, 1));//[TODO] add duration for lerp color
        ellipse(p.x, p.y, PATH_DOT_SIZE, PATH_DOT_SIZE);
      }
    }
    return;
  }
  
  void draw(){
    //if(!mDirtyFlag)
    //  return;
    if(userNames==null || userNames.length==0)
      return;
    
    mDirtyFlag = false;

    noStroke();
    pushMatrix();
    translate(WIREFRAME_UL_X, WIREFRAME_UL_Y);
    background(COLOR_WHITE);
    //if(currentHM != null)
    //  currentHM.draw();
    
    int tmpTriggerTarget = isWithinTarget();
    if(tmpTriggerTarget != -1){
      drawPaths(tmpTriggerTarget);
    }else{
      drawSinglePath(currentPath);
    }
  
    popMatrix();
  
    drawWireframe();
    drawHomePosition();
    drawVisInfo();
  }
}