public class Visualizer{
  final int PATH_DOT_SIZE = 10;
  int currentUserId;
  int currentTarget;
  boolean mDirtyFlag;

  String[] userNames;
  String[] trailNames;
  ArrayList<Trail> trails;
  ArrayList<Point> currentPath;
  
  public Visualizer(){
    currentUserId = 0;
    mDirtyFlag = false;
    currentPath = null;

    loadUsers();
  }
 
  void keyPressed(){
    //update user
    if(keyCode == UP){
      PilotStudy.mDesign = DESIGN.UP;
      loadTrails();
    }else if(keyCode == DOWN){
      PilotStudy.mDesign = DESIGN.DOWN;
      loadTrails();
    }else if(keyCode == LEFT){
      PilotStudy.mDesign = DESIGN.LEFT;
      loadTrails();
    }else if(keyCode == RIGHT){
      PilotStudy.mDesign = DESIGN.RIGHT;
      loadTrails();
    }else if(key==' '){
      currentUserId = (currentUserId+1) % userNames.length;
    }else if(key==BACKSPACE){
      currentUserId = (currentUserId+userNames.length-1) % userNames.length;
    }else if(key=='r'){
      loadUsers();
    }

    currentUserId = (currentUserId+userNames.length-1) % userNames.length;
  }

  void loadUsers(){
    userNames = listFileNames(dataPath(""));
    if(userNames==null || userNames.length==0){
      noDataPopout();
      return; 
    }
    loadTrails();
  }

  void loadTrails(){
    trailNames = listFileNames(dataPath(userNames[currentUserId]));

    if(trailNames==null || trailNames.length==0){
      noDataPopout();
      return; 
    }

    trails = new ArrayList<Trail>();
    for(int i=0; i<trailNames.length; i++){
      JSONObject trailJSON = loadJSONObject(dataPath(userNames[currentUserId]+"/"+trailNames[i]));
      Trail t = new Trail(trailJSON);
      if(t.design == PilotStudy.mDesign){
        trails.add(t);
      }
    }
  }
  void drawPaths(){
    for(Trail t:trails){
        drawSinglePath(t.path);
    }
    return;
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
  
    mDirtyFlag = false;
    noStroke();
    pushMatrix();
    translate(WIREFRAME_UL_X, WIREFRAME_UL_Y);
    background(COLOR_WHITE);
    //if(currentHM != null)
    //  currentHM.draw();
    
    //int tmpTriggerTarget = isWithinTarget();
    //if(tmpTriggerTarget != -1){
    //  drawPaths(tmpTriggerTarget);
    //}else if(currentPath!=null){
      drawPaths();
    //}
  
    popMatrix();
  
    drawWireframe();
    drawHomePosition();
    drawVisInfo();
  }
}