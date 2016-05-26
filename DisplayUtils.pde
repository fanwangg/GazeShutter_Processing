final int TARGET_ROW_NUM = 4;
final int TARGET_COL_NUM = 3;
final int TRAIL_PER_TARGET = 3;
final int TOTAL_TRAIL_NUM = TARGET_ROW_NUM * TARGET_COL_NUM * TRAIL_PER_TARGET;
final String outputPath = new String("data/");

//GUI const
final color COLOR_WHITE = color(255,255,255);
final color COLOR_BLACK = color(0,0,0);
final color COLOR_RED = color(255,0,0);
final color COLOR_GREEN = color(0,255,0);
final color COLOR_BLUE = color(0,0,255);
final color COLOR_LIGHTBLUE = color(30,177,237);
final color COLOR_HALOBTN = COLOR_LIGHTBLUE;

final int STROKE_WEIGHT = 2;
final int SCREEN_WIDTH = 1920;//deal with width/height init. problem
final int SCREEN_HEIGHT = 1080;
final int WIREFRAME_WIDTH  = 540;
final int WIREFRAME_HEIGHT = 960;
final int WIREFRAME_RADIUS = 18;
final int WIREFRAME_UL_X = (SCREEN_WIDTH - WIREFRAME_WIDTH)/2;
final int WIREFRAME_UL_Y = (SCREEN_HEIGHT - WIREFRAME_HEIGHT)/2;

final int HOMEPOSITION_WIDTH  = 60;
final int HOMEPOSITION_HEIGHT = 36;
final int HOMEPOSITION_MARGIN = 10;

final int HALO_BTN_RADIUS = 72;
final int HALO_BTN_DIAMETER = HALO_BTN_RADIUS*2;
final int HALO_BTN_DIST_THRESHOLD = 40;
final int HALO_BTN_DELAY_TIME = 300;//ms

final int INFO_MARGIN_X = 300;

final int targetWidth = WIREFRAME_WIDTH / TARGET_COL_NUM;
final int targetHeight = WIREFRAME_HEIGHT / TARGET_ROW_NUM;
final int CROSS_SIZE = 16;

final String USER_DESIGN = "USER_DESIGN";
final String USER_NAME   = "USER_NAME";

DropdownList mModeDropdown;
Textfield mUserIdText;

void drawWireframe(){
  noFill();
  pushMatrix();
  translate(WIREFRAME_UL_X, WIREFRAME_UL_Y);
  stroke(COLOR_BLACK);
  strokeWeight(STROKE_WEIGHT);
  
  rect(0, 0, WIREFRAME_WIDTH, WIREFRAME_HEIGHT, 
    WIREFRAME_RADIUS, WIREFRAME_RADIUS, WIREFRAME_RADIUS, WIREFRAME_RADIUS);
  drawTargets();
  popMatrix();
}

int getCurrentTarget(){
  int target;
  if(mMode == MODE.VISUALIZING)
    target = mVisualizer.currentTarget;
  else if(mUserTester.isGazing)
    target = mUserTester.trailTarget.get(mUserTester.trailNum);
  else
    target = -1;

  return target;
}


void drawTargets(){
  int target=getCurrentTarget();
  
  for(int r=0; r<TARGET_ROW_NUM; r++){
    for(int c=0; c<TARGET_COL_NUM; c++){
      if(r*TARGET_COL_NUM + c == target){
        strokeWeight(STROKE_WEIGHT*2);
        stroke(COLOR_RED);
        drawCross(int((c+0.5)*targetWidth), int((r+0.5)*targetHeight));  
      }
      else{
        strokeWeight(STROKE_WEIGHT);
        stroke(COLOR_BLACK);
      }
    }
  }
}

void drawCross(int x, int y){
  line(x-CROSS_SIZE, y, x+CROSS_SIZE, y);
  line(x, y-CROSS_SIZE, x, y+CROSS_SIZE);
}

void drawUP(int r, int c, int margin){
  arc(int((c+0.5)*targetWidth), -margin, 
            HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
            PI/6, PI*5/6, CHORD);
}


void drawRIGHT(int r, int c, int margin){
      arc(WIREFRAME_WIDTH+margin, int((r+0.5)*targetHeight), 
          HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
          PI*4/6, PI*8/6, CHORD);
}


void drawDOWN(int r, int c, int margin){
        arc(int((c+0.5)*targetWidth), WIREFRAME_HEIGHT+margin, 
            HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
            -PI*5/6, -PI*1/6, CHORD);
}

void drawLEFT(int r, int c, int margin){

        arc(-margin, int((r+0.5)*targetHeight), 
            HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
            -PI*2/6, PI*2/6, CHORD); 
}
        



void drawHaloButton(){  
  //[TODO] using mUserTester.lastTriggerTarget
  //int r = (mouseY - WIREFRAME_UL_Y)/targetHeight;
  //int c = (mouseX - WIREFRAME_UL_X)/targetWidth;

  if(mUserTester.lastTriggerTarget!=-1 
    &&mUserTester.lastTriggerTarget==getCurrentTarget()
    &&mUserTester.isGazing){

    int r = mUserTester.lastTriggerTarget / TARGET_COL_NUM;
    int c = mUserTester.lastTriggerTarget % TARGET_COL_NUM;
    int margin = HALO_BTN_RADIUS/2;

    pushMatrix();
    translate(WIREFRAME_UL_X, WIREFRAME_UL_Y);
    fill(COLOR_HALOBTN);

    switch(mDesign){
      case DOWN:
        drawDOWN(r,c,margin);
        break;
        
      case RIGHT:
        drawRIGHT(r,c,margin);
        break;
        
      case LEFT:
        drawLEFT(r,c,margin);
        break;
      
      case UP:
        drawUP(r,c,margin);
        break;
      
      case DYNAMIC_4_POINT:
        drawUP(r,c,margin);
        drawRIGHT(r,c,margin);
        drawLEFT(r,c,margin);
        drawDOWN(r,c,margin);
        break;
      
      case DYNAMIC_1_POINT:
        //RIGHT
        arc(WIREFRAME_WIDTH+margin, int((r+0.5)*targetHeight), 
            HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
            PI*4/6, PI*8/6, CHORD);
        break;
      
      
      case STATIC:
        ellipse(3.5*targetWidth, 0, HALO_BTN_RADIUS/2, HALO_BTN_RADIUS/2);
        break;
    }
        
    popMatrix();
  }
}

void drawHomePosition(){
  int UL_X = width/2 - HOMEPOSITION_WIDTH/2;
  int UL_Y = height - HOMEPOSITION_HEIGHT - HOMEPOSITION_MARGIN;
  
  
  if(mMode == MODE.VISUALIZING || mUserTester.isGazing){
    stroke(COLOR_BLACK);
    strokeWeight(STROKE_WEIGHT);
  }
  else{
    stroke(COLOR_RED);
    strokeWeight(STROKE_WEIGHT*2);
  }
  
  
  
  rect(UL_X, UL_Y, HOMEPOSITION_WIDTH, HOMEPOSITION_HEIGHT);
}

void drawTestingInfo(boolean ambientMode){
  if(DEBUG){
    println("frameRate:"+frameRate);
  }
  
  if(ambientMode){
    mModeDropdown.hide();
    mUserIdText.hide();
    float process = float(mUserTester.trailNum)/TOTAL_TRAIL_NUM;


  }else{
    mModeDropdown.show();
    mUserIdText.show();

    textSize(32);
    fill(COLOR_BLACK);
    pushMatrix();
    translate(WIREFRAME_UL_X+WIREFRAME_WIDTH+INFO_MARGIN_X, WIREFRAME_UL_Y);
    
    text("User:"+mUserTester.userID, 10, 0);
    text("Trails:"+mUserTester.trailNum+"/"+TOTAL_TRAIL_NUM, 10, 40);
     
    popMatrix();
  }
}



void drawVisInfo(){
  textSize(32);
  fill(COLOR_BLACK);
  pushMatrix();
  translate(WIREFRAME_UL_X+WIREFRAME_WIDTH+INFO_MARGIN_X, WIREFRAME_UL_Y);
  
  text("User:"+mVisualizer.userNames[mVisualizer.currentUserId], 10, 0);
  text("Trail:"+mVisualizer.currentTrailId, 10, 50);
  text("Task:("+mVisualizer.currentTarget/TARGET_COL_NUM+","+mVisualizer.currentTarget%TARGET_COL_NUM+")", 10, 100);
   
  popMatrix();
}

void setupPanel(){

  mModeDropdown = PilotStudy.mCP5.addDropdownList(USER_DESIGN)
                    .setPosition(100, 100)
                    .setSize(100,100);
  customize(mModeDropdown);   

  mUserIdText = PilotStudy.mCP5.addTextfield(USER_NAME)
                    .setPosition(100, 200)
                    .setSize(100, 20)
                    .setFocus(true);


}

void customize(DropdownList dl) {
  // a convenience function to customize a DropdownList
  dl.setBackgroundColor(color(190));
  dl.setItemHeight(30);
  dl.setBarHeight(30);
  for (DESIGN d:DESIGN.values()) {
    dl.addItem(d.name(), ""+d.ordinal());
  }
  //ddl.scroll(0);
  dl.setColorBackground(color(0,0,0));
  dl.setColorActive(color(255, 128));
}

boolean isWithinHomeBtn(int x, int y){
  int UL_X = width/2 - HOMEPOSITION_WIDTH/2;
  int UL_Y = height - HOMEPOSITION_HEIGHT - HOMEPOSITION_MARGIN;
  if(x<UL_X || UL_X+HOMEPOSITION_WIDTH<x)
    return false;
  if(y<UL_Y || UL_Y+HOMEPOSITION_HEIGHT<y)
    return false;
  return true;
}


/*
 *  return val targetID, or -1 if none
 */
int isWithinTarget(){
  int r = (mouseY - WIREFRAME_UL_Y)/targetHeight;
  int c = (mouseX - WIREFRAME_UL_X)/targetWidth;

  if(mouseX<WIREFRAME_UL_X || mouseX>WIREFRAME_UL_X+WIREFRAME_WIDTH || mouseY<WIREFRAME_UL_Y || mouseY>WIREFRAME_UL_Y+WIREFRAME_HEIGHT)
    return -1;
     
  int dx = mouseX - WIREFRAME_UL_X - int((c+0.5)*targetWidth);
  int dy = mouseY - WIREFRAME_UL_Y - int((r+0.5)*targetHeight);
  double distance = sqrt(dx*dx + dy*dy);

  if(distance < HALO_BTN_DIST_THRESHOLD)
    return r*TARGET_COL_NUM + c;
  else
    return -1;
}

boolean isWithinTarget(Trail trail){
  int r = trail.getRow();
  int c = trail.getCol();

  if(mouseX<WIREFRAME_UL_X || mouseX>WIREFRAME_UL_X+WIREFRAME_WIDTH || mouseY<WIREFRAME_UL_Y || mouseY>WIREFRAME_UL_Y+WIREFRAME_HEIGHT)
    return false;
     
  int dx = mouseX - WIREFRAME_UL_X - int((c+0.5)*targetWidth);
  int dy = mouseY - WIREFRAME_UL_Y - int((r+0.5)*targetHeight);
  double distance = sqrt(dx*dx + dy*dy);

  return distance < HALO_BTN_DIST_THRESHOLD;
}

boolean isWithinHaloButton(Trail trail){
  int r = trail.getRow();
  int c = trail.getCol();

  int dx, dy;
  int mx = mouseX - WIREFRAME_UL_X;
  int my = mouseY - WIREFRAME_UL_Y;
  int margin = HALO_BTN_RADIUS/2;
  double distance;
  switch(mDesign){
    case DYNAMIC_4_POINT:
      //UP
      dx = mx - int((c+0.5)*targetWidth);
      dy = my - (-margin);
      distance = sqrt(dx*dx + dy*dy);
      if(distance<HALO_BTN_DIAMETER && my>0){
        return true;
      }

      //RIGHT
      dx = mx - (WIREFRAME_WIDTH+margin);
      dy = my - int((r+0.5)*targetHeight);
      distance = sqrt(dx*dx + dy*dy);
      if(distance<HALO_BTN_DIAMETER && mx<WIREFRAME_WIDTH){
        return true;
      }

      //DOWN
      dx = mx - int((c+0.5)*targetWidth);
      dy = my - (WIREFRAME_HEIGHT+margin);
      distance = sqrt(dx*dx + dy*dy);
      if(distance<HALO_BTN_DIAMETER && my<WIREFRAME_HEIGHT){
        return true;
      }
          
      //LEFT
      dx = mx - (-margin);
      dy = my - int((r+0.5)*targetHeight);
      distance = sqrt(dx*dx + dy*dy);
      if(distance<HALO_BTN_DIAMETER && mx>0){
        return true;
      }
 
      break;
  }
  return false;
}

// DropdownList is of type ControlGroup.
void controlEvent(ControlEvent event) {
  if(event.isAssignableFrom(Textfield.class)){
    Textfield t = (Textfield)event.getController();
    mUserTester.userID = int(t.getText());//[TODO] check if not int
    println(t.getText());
  }
  else if(event.isAssignableFrom(DropdownList.class)){
    mDesign = DESIGN.values()[int(event.getController().getValue())];
    println(event.getController()+":"+event.getController().getValue());
  }
  else if (event.isGroup()) {
    println(event.getGroup()+":"+event.getGroup().getValue());
  } 
}