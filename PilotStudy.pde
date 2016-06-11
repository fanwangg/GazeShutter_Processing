import controlP5.*;

final boolean DEBUG=false;
public enum DESIGN{
  LEFT, UP, RIGHT, DOWN, DYNAMIC_4_POINT, DYNAMIC_1_POINT, STATIC;
}
public enum MODE{
  STATIC, SHORTEST, LONGEST, RANDOM, NONE;
}

public enum SHOWING_TARGET{
  ONE, EVEN, ALL, NONE;
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
static SHOWING_TARGET mShowingTarget = SHOWING_TARGET.ONE;
static ControlP5 mCP5;
static UserTester mUserTester;
static Visualizer mVisualizer;
static Evaluation mEvaluation;


void keyPressed(){
  if(key==TAB){
    mContent = mContent.next();
    updateContent();
  }
  if(mContent==CONTENT.USER_TESTING || mContent==CONTENT.USER_TESTING2)
    mUserTester.keyPressed();
  else if(mContent==CONTENT.VISUALIZING)
    mVisualizer.keyPressed();
  else if(mContent==CONTENT.EVALUATION)
    mEvaluation.keyPressed();
}

void setup() {
   fullScreen(2);
   smooth();
   //frameRate(30);
   
   mContent = CONTENT.USER_TESTING;
   mDesign = DESIGN.RIGHT;
   mMode = MODE.NONE;
   
   mUserTester = new Study1();//polymorphism
   mVisualizer = new Visualizer();
   mEvaluation = new Evaluation();
   mCP5 = new ControlP5(this);
   setupPanel();
}

void draw(){
  if(mContent == CONTENT.USER_TESTING || mContent == CONTENT.USER_TESTING2)
    mUserTester.draw();
  else if(mContent == CONTENT.VISUALIZING)
    mVisualizer.draw();
  else if(mContent == CONTENT.EVALUATION)
    mEvaluation.draw();

  drawContentInfo();
}

void updateContent(){
  if(mContent==CONTENT.USER_TESTING){
    mUserTester = new Study1();
    mMode = MODE.NONE;
    mShowingTarget = SHOWING_TARGET.ONE;
  }else{
    mUserTester = new Study2();
    mShowingTarget = SHOWING_TARGET.EVEN;
  }

}