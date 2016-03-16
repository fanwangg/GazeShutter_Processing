import java.util.Collections;
import java.util.Random;

public class UserTester{
  int userID=0;
  int trailNum = 0;
  Trail currentTrail;
  ArrayList<Integer> trailTarget = new ArrayList<Integer>();
  
  boolean isFinished = false;
  boolean isGazing = false;
  
  public UserTester(){
    for(int r=0; r<TARGET_ROW_NUM; r++){
      for(int c=0; c<TARGET_COL_NUM; c++){
        for(int t=0; t<TRAIL_PER_TARGET; t++){ 
          trailTarget.add(r*TARGET_COL_NUM+c);
        }
      }
    }
    Collections.shuffle(trailTarget);
  }
  
  void switchGazeState(){
    if(isFinished)
      return;

     isGazing = !isGazing;
     
     if(isGazing){
      //starting of new trail
      currentTrail = new Trail(userID, trailNum, trailTarget.get(trailNum));
     }
     else{
      //just in case
      if(currentTrail!=null)
        currentTrail.output();
       
       trailNum++;
       if(trailNum == TOTAL_TRAIL_NUM){
         finish();
       }
     }
  }
  
  void finish(){
    noLoop();
    isFinished = true;
  }
  
  void trackGazeGesture(){
    if(isGazing && currentTrail!=null){
       currentTrail.update();
    }
  }
  
  /*
   *  The main functions of processing 
   */
   
  void keyPressed(){
    if(key ==' '){
      switchGazeState();
    }
  }
  
  void draw(){
    background(COLOR_WHITE);
    drawWireframe();
    drawHomePosition();
    drawHaloButton();
    drawTestingInfo();
    
    //saving trail data
    trackGazeGesture();
  }
}