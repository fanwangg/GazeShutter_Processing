final int TARGET_ROW_NUM = 5;
final int TARGET_COL_NUM = 4;
final int TRAIL_PER_TARGET = 3;
final int TOTAL_TRAIL_NUM = TARGET_ROW_NUM * TARGET_COL_NUM * TRAIL_PER_TARGET;
final String outputPath = new String("data/");

//GUI const
final color COLOR_WHITE = color(255,255,255);
final color COLOR_BLACK = color(0,0,0);
final color COLOR_RED = color(255,0,0);
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
final int HALO_BTN_DIST_THRESHOLD = 30;
final int INFO_MARGIN = 300;

final int targetWidth = WIREFRAME_WIDTH / TARGET_COL_NUM;
final int targetHeight = WIREFRAME_HEIGHT / TARGET_ROW_NUM;
final int CROSS_SIZE = 16;


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


void drawTargets(){
  int target=0;

  if(mMode == MODE.VISUALIZING)
    target = mVisualizer.currentTarget;
  else if(mUserTester.isGazing)
    target = mUserTester.trailTarget.get(mUserTester.trailNum);
  else
    target = -1;
  
  for(int r=0; r<TARGET_ROW_NUM; r++){
    for(int c=0; c<TARGET_COL_NUM; c++){
      if(r*TARGET_COL_NUM + c == target){
        strokeWeight(STROKE_WEIGHT*2);
        stroke(COLOR_RED);
      }
      else{
        strokeWeight(STROKE_WEIGHT);
        stroke(COLOR_BLACK);
      }
      drawCross(int((c+0.5)*targetWidth), int((r+0.5)*targetHeight));  
    }
  }
}

void drawCross(int x, int y){
  line(x-CROSS_SIZE, y, x+CROSS_SIZE, y);
  line(x, y-CROSS_SIZE, x, y+CROSS_SIZE);
}

void drawHaloButton(){
  if(mouseX<WIREFRAME_UL_X || mouseX>WIREFRAME_UL_X+WIREFRAME_WIDTH || mouseY<WIREFRAME_UL_Y || mouseY>WIREFRAME_UL_Y+WIREFRAME_HEIGHT)
    return;
    
  int r = (mouseY - WIREFRAME_UL_Y)/targetHeight;
  int c = (mouseX - WIREFRAME_UL_X)/targetWidth;
   
  int dx = mouseX - WIREFRAME_UL_X - int((c+0.5)*targetWidth);
  int dy = mouseY - WIREFRAME_UL_Y - int((r+0.5)*targetHeight);
  double distance = sqrt(dx*dx + dy*dy);
  int margin = HALO_BTN_RADIUS/2;
  
  if(distance < HALO_BTN_DIST_THRESHOLD && mUserTester.isGazing){
    pushMatrix();
    translate(WIREFRAME_UL_X, WIREFRAME_UL_Y);
    fill(COLOR_HALOBTN);
    
    
    switch(mDesign){
      case DYNAMIC_4_POINT:
        //UP
        arc(int((c+0.5)*targetWidth), -margin, 
            HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
            PI/6, PI*5/6, CHORD);
            
        //RIGHT
        arc(WIREFRAME_WIDTH+margin, int((r+0.5)*targetHeight), 
            HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
            PI*4/6, PI*8/6, CHORD);
            
        //DOWN
        arc(int((c+0.5)*targetWidth), WIREFRAME_HEIGHT+margin, 
            HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
            -PI*5/6, -PI*1/6, CHORD);
            
        //LEFT
        arc(-margin, int((r+0.5)*targetHeight), 
            HALO_BTN_DIAMETER, HALO_BTN_DIAMETER, 
            -PI*2/6, PI*2/6, CHORD);
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

void drawTestingInfo(){
  if(DEBUG){
    println("frameRate:"+frameRate);
  }
  
  textSize(32);
  fill(COLOR_BLACK);
  pushMatrix();
  translate(WIREFRAME_UL_X+WIREFRAME_WIDTH+INFO_MARGIN, WIREFRAME_UL_Y);
  
  text("Trails:"+mUserTester.trailNum+"/"+TOTAL_TRAIL_NUM, 10, 10);
   
  popMatrix();
}

void drawVisInfo(){
  textSize(32);
  fill(COLOR_BLACK);
  pushMatrix();
  translate(WIREFRAME_UL_X+WIREFRAME_WIDTH+INFO_MARGIN, WIREFRAME_UL_Y);
  
  text("User:"+mVisualizer.currentUserId, 10, 0);
  text("Trail:"+mVisualizer.currentTrailId, 10, 50);
  text("Task:("+mVisualizer.currentTarget/TARGET_COL_NUM+","+mVisualizer.currentTarget%TARGET_COL_NUM+")", 10, 100);
   
  popMatrix();
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