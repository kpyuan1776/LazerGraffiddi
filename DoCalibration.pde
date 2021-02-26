class DoCalibration{
  
  //warps coordinates from cam to screen, needs calibration:
  public Warp9 warping;
  public float[] wpmat;
  private float[] destCoordX;
  private float[] destCoordY;
  int counter = 1;
  private float[] srcCoordX;
  private float[] srcCoordY;
  private boolean _calFinished;
  private boolean _isSet;
  
  public void setIsSet(boolean s){
    _isSet = s;
  }
  
  public void setSrc(float[] srcX, float[] srcY){
    srcCoordX = srcX;
    srcCoordY = srcY;
    _isSet = true;
    _calFinished = true; 
    for (int i = 0; i < srcX.length; i++)
      println("srcX" + i + ": "+ srcX[i]);
  }
  
  public float[] getSrcX(){
    return srcCoordX;
  }
  
  public float[] getSrcY(){
    return srcCoordY;
  }
  
  public boolean getCalState(){
    if(_calFinished) {
    return false;
    } else {
      return true;
    }
  }
  
  /*public Warp9 getWarp(){
    return warping;
  }
  
  public float[] getWarpMatrix(){
    return wpmat;
  }*/
  
 // Constructor initializes Calibration parameter
  public DoCalibration(){
   destCoordX = new float[4];
   destCoordY = new float[4];
   initializeDestination(destCoordX, destCoordY);

   srcCoordX = new float[4];
   srcCoordY = new float[4];
   //setDefaultSrc();
   warping = new Warp9();
   wpmat = new float[16];
   calibrateIt();
   
   _calFinished = false;
   _isSet = false;
  }
  
  
  public void calibrateView(){
      int calfieldSize = 20;
      fill(255);
      strokeWeight(2);
      stroke(255, 25, 0);
      arc(calfieldSize, calfieldSize, calfieldSize, calfieldSize, 0, 2*PI);
      arc(CanvasOnScreen.canvasWidth-calfieldSize, calfieldSize, calfieldSize, calfieldSize, 0, 2*PI);
      arc(CanvasOnScreen.canvasWidth-calfieldSize,CanvasOnScreen.canvasHeight-calfieldSize, calfieldSize, calfieldSize, 0, 2*PI);
      arc(calfieldSize,CanvasOnScreen.canvasHeight-calfieldSize, calfieldSize, calfieldSize, 0, 2*PI);
  }
  
  public void calibrateIt(){
      
      //catchCalCoords(srcCoordX,srcCoordY,currentX,currentY,counter);
      if(_isSet) {
        warping.setSource(srcCoordX[0],srcCoordY[0],srcCoordX[1],srcCoordY[1],srcCoordX[2],srcCoordY[2],
                                    srcCoordX[3],srcCoordY[3]);
        warping.setDestination(destCoordX[0],destCoordY[0],destCoordX[1],destCoordY[1],destCoordX[2],destCoordY[2],
                                    destCoordX[3],destCoordY[3]);
        warping.computeWarpMatrix();                        
      }
      
  }
  
  public void calibrateClear(boolean finished){
    if(finished){
    background(CanvasOnScreen.backcolor);
    println("Calibration Finished!");
    }
  }
  
  
  public void catchCalCoords(float cX, float cY, int counter){
  
            switch(counter){
            case 0:
            { print("."); srcX[0] = cX; srcY[0] = cY; break;
            }
            case 1:
            {  srcX[1] = cX; srcY[1] = cY; println("state 1"); println(srcX[0] + "   " + srcY[0]); break;
            }
            case 2:
            {  srcX[2] = cX; srcY[2] = cY; println("state 2"); println(srcX[1] + "   " + srcY[1]); break;
            }
            case 3:
            {  srcX[3] = cX; srcY[3] = cY; println("state 3"); println(srcX[2] + "   " + srcY[2]); break;
            }
            case 4:
            {   println("state 4"); 
                println(srcX[0] + "   " + srcY[0]);
                println(srcX[1] + "   " + srcY[1]);
                println(srcX[2] + "   " + srcY[2]);
                println(srcX[3] + "   " + srcY[3]);
                break;
            }
          }
  }
  
  
 public void setDefaultSrc(SaveToXml saveit){
   float[] sX = new float[4];
   float[] sY = new float[4];
   //extract String values for corner coordinates from settings.xml
   sX = saveit.getSaved_X();
   sY = saveit.getSaved_Y();
   setSrc(sX,sY);
   
   calibrateIt();
 }

 

  
  
  
  public void initializeDestination(float[] destCoordX, float[] destCoordY){
    destCoordX[0] = 10;  destCoordY[0] = 10;
    destCoordX[1] = CanvasOnScreen.canvasWidth-10;  destCoordY[1] = 10;
    destCoordX[2] = CanvasOnScreen.canvasWidth-10;  destCoordY[2] = CanvasOnScreen.canvasHeight-10;
    destCoordX[3] = 10;                             destCoordY[3] = CanvasOnScreen.canvasHeight-10;
  }
  
  
  
  
}
