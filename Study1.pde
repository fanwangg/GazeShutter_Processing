import java.util.Collections;
import java.util.Random;


public class Study1 extends UserTester{
  public Study1(){
    super();
    TARGET_ROW_NUM = 4;
    TARGET_COL_NUM = 3;
    TRAIL_PER_TARGET = 3;
    init();
    updateDisplayDimension(this);
  }

  void init(){
    PilotStudy.mDesign = getCounterBalancedDesign();
    trailNum = 0;
    trailTarget = new ArrayList<Integer>();
    for(int r=0; r<TARGET_ROW_NUM; r++){
      for(int c=0; c<TARGET_COL_NUM; c++){
        for(int t=0; t<TRAIL_PER_TARGET; t++){ 
          trailTarget.add(r*TARGET_COL_NUM+c);
        }
      }
    }
    Collections.shuffle(trailTarget);
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
      lastTriggerTargetTTL = HALO_BTN_DELAY_TIME;
    }

//    println("lastTriggerTargetTTL:"+lastTriggerTargetTTL);
    lastTriggerTimestamp = millis();
  }
}