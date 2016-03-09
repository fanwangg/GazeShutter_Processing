final boolean DEBUG=false;
public enum DESIGN{
  DYNAMIC_4_POINT, DYNAMIC_1_POINT, STATIC;
}
public enum MODE{
  USER_TESTING, VISUALIZING;
  private static MODE[] modes = values();
  public MODE next(){
    return modes[(this.ordinal()+1) % modes.length];
  }
}

MODE mMode;
DESIGN mDesign;
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
   mDesign = DESIGN.DYNAMIC_1_POINT;
   
   mUserTester = new UserTester();
   mVisualizer = new Visualizer();
}

void draw(){
  if(mMode == MODE.USER_TESTING)
    mUserTester.draw();     
  else if(mMode == MODE.VISUALIZING)
    mVisualizer.draw();
}