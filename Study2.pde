import java.util.Collections;
import java.util.Random;  

public class Study2 extends UserTester{
public Study2(){
    super();
    TARGET_ROW_NUM = 3;
    TARGET_COL_NUM = 3;
    TRAIL_PER_TARGET = 8;
    init();
    updateDisplayDimension(this);
  }

  void init(){
    PilotStudy.mMode = getCounterBalancedMode();

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

  MODE getCounterBalancedMode(){
    if(userID==-1)
      return MODE.STATIC;
  
    MODE mode = MODE.values()[LatinSquare4[userID%4][mSession%4]];
    return mode;
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
      lastTriggerTargetTTL = HALO_BTN_DELAY_TIME;
    }

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