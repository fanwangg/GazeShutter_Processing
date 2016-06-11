import java.util.Collections;
import java.util.Random;  

public class Evaluation extends UserTester{
  final int DWELL_TIME_SHORT = 500;
  final int DWELL_TIME_LONG = 1000;
  public Evaluation(){
    super();
    TARGET_ROW_NUM = 3;
    TARGET_COL_NUM = 3;
    TRAIL_PER_TARGET = 8;
    init();
    updateDisplayDimension(this);
  }

  void init(){
    PilotStudy.mEvalMode = getCounterBalancedEvalDesign();

    trailTarget = new ArrayList<Integer>();
    for(int r=0; r<TARGET_ROW_NUM; r++){
      for(int c=0; c<TARGET_COL_NUM; c++){
        if((r+c)%2==1){
          for(int t=0; t<TRAIL_PER_TARGET; t++){ 
            trailTarget.add(r*TARGET_COL_NUM+c);
          }
        }
      }
    }
    Collections.shuffle(trailTarget);
  }

  void switchAmbientMode(){
    mAmbientMode = !mAmbientMode;
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

  EVALUATION_MODE getCounterBalancedEvalDesign(){
    if(userID==-1)
      return EVALUATION_MODE.NONE;
    
    EVALUATION_MODE design = EVALUATION_MODE.values()[LatinSquare3[userID%6][mSession%6]];
    if(design == EVALUATION_MODE.DWELL_SHORT)
      DWELL_TIME = DWELL_TIME_SHORT;
    else if(design == EVALUATION_MODE.DWELL_LONG)
      DWELL_TIME = DWELL_TIME_LONG;

  
    return design;
  }

  DESIGN getDesignByMode(){
    if(PilotStudy.mMode==null)
      return DESIGN.RIGHT;
    
    DESIGN  design;
    if(PilotStudy.mMode == MODE.STATIC){
      design = DESIGN.STATIC;
    }else if(PilotStudy.mMode == MODE.RANDOM){
      design = DESIGN.values()[int(random(4))];//  LEFT, UP, RIGHT, DOWN
    }else if(PilotStudy.mMode == MODE.SHORTEST){
      if(currentTrail.getRow()==0)
        design = DESIGN.UP;
      else if(currentTrail.getRow()==2)
        design = DESIGN.DOWN;
      else if(currentTrail.getRow()==1 && currentTrail.getCol()==2)
        design = DESIGN.RIGHT;
      else if(currentTrail.getRow()==1 && currentTrail.getCol()==0)
        design = DESIGN.LEFT;
      else
        design = DESIGN.STATIC;
    }else if(PilotStudy.mMode == MODE.LONGEST){
      if(currentTrail.getRow()==0)
        design = DESIGN.DOWN;
      else if(currentTrail.getRow()==2)
        design = DESIGN.UP;
      else if(currentTrail.getRow()==1 && currentTrail.getCol()==2)
        design = DESIGN.LEFT;
      else if(currentTrail.getRow()==1 && currentTrail.getCol()==0)
        design = DESIGN.RIGHT;
      else
        design = DESIGN.STATIC;
    }else{
      design = DESIGN.STATIC;
      println("something went wrong in mMode");
    }

    return design;
  }

  //update
  void trackGazeGesture(){
    if(!isGazing){
      return;
    }
    if(mEvalMode==EVALUATION_MODE.GAZESHUTTER){
      currentTrail.update();  
      return;
    }

    int tmpTriggerTarget = withinTarget(currentTrail);
    //not dwelling
    if(tmpTriggerTarget == -1){
      lastTriggerTarget = -1;
      lastTriggerTargetTTL = -1;
    }
    //start dwelling
    else if(tmpTriggerTarget == lastTriggerTarget){
      lastTriggerTarget = tmpTriggerTarget;
      lastTriggerTargetTTL -= (millis()-lastTriggerTimestamp);
      if(lastTriggerTargetTTL>-0){
        drawDwellProgress(lastTriggerTarget,(DWELL_TIME-lastTriggerTargetTTL)/DWELL_TIME);
      }else{
        currentTrail.updateStage(STAGE.STAGE_5);
      }
    }
    else{
      lastTriggerTarget = tmpTriggerTarget;
      lastTriggerTargetTTL = (int)DWELL_TIME; 
      currentTrail.updateStage(STAGE.STAGE_1);
    }

    println("lastTriggerTargetTTL:"+lastTriggerTargetTTL);
//    println("lastTriggerTargetTTL:"+lastTriggerTargetTTL);
    lastTriggerTimestamp = millis();
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

   void switchGazeState(){
     isGazing = !isGazing;

     if(isGazing){
      //starting of new trail
      currentTrail = new Trail(userID, trailNum, trailTarget.get(trailNum));
      PilotStudy.mDesign = getDesignByMode();
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
}