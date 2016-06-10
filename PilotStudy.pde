import controlP5.*;

final boolean DEBUG=false;
public enum DESIGN{
  LEFT, UP, RIGHT, DOWN, DYNAMIC_4_POINT, DYNAMIC_1_POINT, STATIC;
}
public enum MODE{
  STATIC, SHORTEST, LONGEST, RANDOM;
}

public enum CONTENT{
  USER_TESTING, USER_TESTING2, VISUALIZING, EVALUATION;
  private static CONTENT[] modes = values();
  public CONTENT next(){
    return modes[(this.ordinal()+1) % modes.length];
  }
}

public enum DISTANCE{
  S, M, L, XL, ERR;
}

static CONTENT mContent;
static DESIGN mDesign;
static MODE mMode;
static ControlP5 mCP5;
UserTester mUserTester;
UserTester2 mUserTester2;
Visualizer mVisualizer;
Evaluation mEvaluation;


void keyPressed(){
  if(key==TAB){
    mContent = mContent.next();
    if(DEBUG)
      println(mContent);
  }
  
  if(mContent == CONTENT.USER_TESTING)
    mUserTester.keyPressed();
  else if(mContent == CONTENT.USER_TESTING2)
    mUserTester2.keyPressed();
  else if(mContent == CONTENT.VISUALIZING)
    mVisualizer.keyPressed();
  else if(mContent == CONTENT.EVALUATION)
    mEvaluation.keyPressed();
}

void setup() {
   fullScreen();
   smooth();
   //frameRate(30);
   

   mContent = CONTENT.USER_TESTING;
   mDesign = DESIGN.RIGHT;
   mMode = MODE.STATIC;
   
   mUserTester = new UserTester();
   mUserTester2 = new UserTester2();
   mVisualizer = new Visualizer();
   mEvaluation = new Evaluation();
   mCP5 = new ControlP5(this);
   setupPanel();
}

void draw(){
  if(mContent == CONTENT.USER_TESTING)
    mUserTester.draw();     
  else if(mContent == CONTENT.USER_TESTING2)
    mUserTester2.draw();
  else if(mContent == CONTENT.VISUALIZING)
    mVisualizer.draw();
  else if(mContent == CONTENT.EVALUATION)
    mEvaluation.draw();

  drawContentInfo();

  //add evaluation mode here
}