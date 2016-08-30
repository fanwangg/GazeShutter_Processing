import controlP5.*;

final boolean DEBUG=false;
public enum DESIGN{
  LEFT, UP, RIGHT, DOWN, DYNAMIC_4_POINT, DYNAMIC_1_POINT, STATIC;
}
public enum MODE{
  STATIC, SHORTEST, LONGEST, RANDOM, NONE, SEMI;
}

public enum SHOWING_TARGET{
  ONE, ALL, EVEN, NONE;
}

public enum EVALUATION_MODE{
  GAZESHUTTER, DWELL_SHORT, DWELL_LONG, NONE;
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
static EVALUATION_MODE mEvalMode;
static SHOWING_TARGET mShowingTarget = SHOWING_TARGET.ONE;
static ControlP5 mCP5;
static UserTester mUserTester;
static Visualizer mVisualizer;

void keyPressed(){
  if(key==TAB){
    mContent = mContent.next();
    updateContent();
  }
  if(mContent==CONTENT.USER_TESTING || mContent==CONTENT.USER_TESTING2 || mContent==CONTENT.EVALUATION)
    mUserTester.keyPressed();
  else if(mContent==CONTENT.VISUALIZING)
    mVisualizer.keyPressed();
}

void setup() {
   fullScreen(1);
   smooth();
   //frameRate(30);
   
   mContent = CONTENT.USER_TESTING;
   mDesign = DESIGN.RIGHT;
   mMode = MODE.NONE;
   mEvalMode = EVALUATION_MODE.NONE;
   
   mUserTester = new Study1();//polymorphism
   mVisualizer = new Visualizer();
   mCP5 = new ControlP5(this);
   setupPanel();
}

void draw(){
  if(mContent == CONTENT.USER_TESTING || mContent == CONTENT.USER_TESTING2 || mContent == CONTENT.EVALUATION)
    mUserTester.draw();
  else if(mContent == CONTENT.VISUALIZING)
    mVisualizer.draw();

  drawContentInfo();
}

void updateContent(){
  if(mContent==CONTENT.USER_TESTING){
    mUserTester = new Study1();
    mMode = MODE.NONE;
    mShowingTarget = SHOWING_TARGET.ONE;
    mEvalMode = EVALUATION_MODE.NONE;
  }else if(mContent==CONTENT.USER_TESTING2){
    mUserTester = new Study2();
    mShowingTarget = SHOWING_TARGET.EVEN;
    mEvalMode = EVALUATION_MODE.NONE;
  }else if(mContent==CONTENT.EVALUATION){
    mUserTester = new Evaluation2();
    mMode = MODE.SHORTEST;
    mShowingTarget = SHOWING_TARGET.NONE;
  }
} 
