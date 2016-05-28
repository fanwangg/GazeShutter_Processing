import controlP5.*;

final boolean DEBUG=false;
public enum DESIGN{
  LEFT, UP, RIGHT, DOWN, DYNAMIC_4_POINT, DYNAMIC_1_POINT, STATIC;
}
public enum MODE{
  USER_TESTING, VISUALIZING;
  private static MODE[] modes = values();
  public MODE next(){
    return modes[(this.ordinal()+1) % modes.length];
  }
}

static MODE mMode;
static DESIGN mDesign;
static ControlP5 mCP5;
UserTester mUserTester;
Visualizer mVisualizer;


void keyPressed(){
  if(key==TAB){
    mMode = mMode.next();
    if(DEBUG)
      println(mMode);
  }
  
  if(mMode == MODE.USER_TESTING)
    mUserTester.keyPressed();
  else if(mMode == MODE.VISUALIZING)
    mVisualizer.keyPressed();
}

void setup() {
   fullScreen();
   smooth();
   //frameRate(30);
   
   mMode = MODE.USER_TESTING;
   mDesign = DESIGN.RIGHT;
   
   mUserTester = new UserTester();
   mVisualizer = new Visualizer();
   mCP5 = new ControlP5(this);
   setupPanel();
}

void draw(){
  if(mMode == MODE.USER_TESTING)
    mUserTester.draw();     
  else if(mMode == MODE.VISUALIZING)
    mVisualizer.draw();

  //add evaluation mode here
}