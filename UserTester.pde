import java.util.Collections;
import java.util.Random;

public abstract class UserTester{
  int[][] LatinSquare4 = {
    {0,1,3,2},
    {1,2,0,3},
    {2,3,1,0},
    {3,0,2,1}};

  int[][] LatinSquare3 = {
    {0,1,2},
    {1,2,0},
    {2,1,0},
    {0,2,1},
    {1,0,2},
    {2,0,1}};

  int userID=-1;
  String userName = "";
  int trailNum;
  int lastTriggerTimestamp = -1;
  int lastTriggerTarget = -1;
  int lastTriggerTargetTTL = -1;
  boolean mAmbientMode = false;
  Trail currentTrail = null;
  int startTime = millis();
  int mSession = 0;

  ArrayList<Integer> trailTarget = new ArrayList<Integer>();
  
  boolean isGazing = false;
  
  public UserTester(){
    trailNum = 0;
    lastTriggerTimestamp = -1;
    lastTriggerTarget = -1;
    lastTriggerTargetTTL = -1;
    isGazing = false;
  }

  abstract void init();

  void switchAmbientMode(){
    mAmbientMode = !mAmbientMode;
  }
  
  void switchGazeState(){
     isGazing = !isGazing;
     
     if(isGazing){
      //starting of new trail
      currentTrail = new Trail(userID, trailNum, trailTarget.get(trailNum));
     }
     else{
      //just in case
      if(currentTrail!=null){
        currentTrail.output();
        currentTrail = null;
      }
       
       trailNum++;
       if(trailNum == TOTAL_TRAIL_NUM){
         finish();
       }
     }
  }

  void redoTrail(){
    if(isGazing){
      //starting of new trail
      currentTrail = new Trail(userID, trailNum, trailTarget.get(trailNum));
     }else if(trailNum>0){
       trailNum--;
     }
     isGazing = false;
  }

  void finish(){
    javax.swing.JOptionPane.showMessageDialog(null, "Finished",
      "Info", javax.swing.JOptionPane.INFORMATION_MESSAGE); 
    mSession++;
    init();
  }

  DESIGN getCounterBalancedDesign(){
    if(userID==-1)
      return DESIGN.LEFT;
    
    DESIGN design = DESIGN.values()[LatinSquare4[userID%4][mSession%4]];
    println(design);
    return design;
  }
  
  //update
  void trackGazeGesture(){
    if(!isGazing){
      return;
    }

    currentTrail.update();  
    int tmpTriggerTarget = withinTarget(currentTrail);
    
    if(tmpTriggerTarget == -1){
      lastTriggerTargetTTL -= (millis()-lastTriggerTimestamp);
      if(lastTriggerTargetTTL<0){
        lastTriggerTarget = -1;
      }
    }
    else{
      lastTriggerTarget = tmpTriggerTarget;
      lastTriggerTargetTTL = int(DWELL_TIME);
    }

    lastTriggerTimestamp = millis();
  }
  

  /*
   *  The main functions of processing 
   */
  void keyPressed(){
    if(key==' '){
      switchGazeState();
    }
    else if(key=='`'){
      switchAmbientMode();
    }
    else if(key=='r'){
      redoTrail();
    }
  }
  
  void draw(){
    background(COLOR_WHITE);
    drawWireframe();
    drawHomePosition();
    drawHaloButton(currentTrail);
    drawTestingInfo(mAmbientMode);
    
    //saving trail data
    trackGazeGesture();
  }

  int getCurrentTarget(){
    if(trailNum < trailTarget.size())
      return trailTarget.get(trailNum);
    else
      return -1;
  }
}