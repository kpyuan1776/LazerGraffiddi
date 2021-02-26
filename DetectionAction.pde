import blobDetection.*;


class DetectionAction {
  
  private int _detWidth;
  private int _detHeight;
  
  private float _currentX;
  private float _currentY;
  private float _prevX;
  private float _prevY;
  private int _counter;
  
  private boolean _blobOn;
  //private Blob[] _oldBlob = new Blob[CanvasOnScreen.availLaser];
  private boolean[] _oldBlobSet = new boolean[CanvasOnScreen.availLaser];
  private int[] _oldBlobResetTimer = new int[CanvasOnScreen.availLaser];
  private float[] _oldBlobX = new float[CanvasOnScreen.availLaser];
  private float[] _oldBlobY = new float[CanvasOnScreen.availLaser];
  private float _oldBlobScaleFactor;
  
  private int _lastBlobCount;
  
  
  PImage _brushImage;
  
  private Brushes brushes;
  
  public float thresh = 0.15; // Threshold of Blob Detection 0.17
  public int blurVal = 1; // Default Blur Amount
    // GUI Variables for Controlling Export Options
  public boolean detect = true;
  public boolean drawPoints = true;
    // An Array of Blobs that we can turn off
    public final int totalBlobNumber = 144;
  public boolean[] blbs = {true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true,
                    true,true,true,true,true,true,true,true,true,true,true,true};
                    
  private BlobDetection theBlobDetection;
  
  private StyleInterface styleInterface;
  
  
  
  
  //Getter/Setter methods
  //*****************************************************************
  
  public float getCurrentX(){
    return _currentX;
  }
  public float getCurrentY(){
    return _currentY;
  }
  public float getPrevX(){
   return _prevX;
  }
  public float getPrevY(){
    return _prevY;
  }
  
  public void setStartValues(){
    _currentX = -5000;
    _currentY = -5000;
    _prevX = -5000;
    _prevY = -5000;
    _counter = 0;
  }
  
  public void setPrevValues(float setX, float setY){
    _prevX = setX;
    _prevY = setY;
  }
  
  public void invalidateOldBlob(int i){
    if (i < _oldBlobSet.length)
    {
      _oldBlobSet[i] = false;
    }
  }
  
  public int getOldBolbTime(int i){
    return _oldBlobResetTimer[i];
  }
  
  //Constructor
  //******************************************************************
  public DetectionAction(int imageWidth, int imageHeight){
    //BlobDetection
    theBlobDetection = new BlobDetection(img.width, img.height);
    theBlobDetection.setPosDiscrimination(true);
    theBlobDetection.setThreshold(thresh);
    setStartValues();
    
    brushes = new Brushes();
    //PImage brushImage = createImage(200, 200, ARGB);
    //background(0);
    //_brushImage = CreateBrush(50, 50, 100, 7);
    
      //println("saving image: " + _brushImage.width + ", " + _brushImage.height + " from " + 100 + " radius, " + 50 + " x ");
      //imageMode(CENTER);
     //image(_brushImage, 50, 150);
     //image(_brushImage, 250, 250); 
     //image(_brushImage, 200, 400);
  }
  
  public void detectBlobs(PImage img){
    //fastblur(img, blurVal); // apply blur to soften the image
    //img = lowPassBlur(img);
    theBlobDetection.computeBlobs(img.pixels); // compute the blobs
  }
  
  public void setNewBlobsxy(boolean drawPoints, int blobNumber, boolean draw_it)
  {
    if (detect == true) 
    {
        Blob b;
        if (_lastBlobCount != theBlobDetection.getBlobNb())
        {
          _lastBlobCount = theBlobDetection.getBlobNb();
          //println("numblob: " + _lastBlobCount);
        }
//        if (theBlobDetection.getBlobNb() == 1)
//        {
//           b = theBlobDetection.getBlob(0);
//	   if (b!=null) 
//           {
//           }
//        }
      
        for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++)
        {
          //println("numblobs: " + theBlobDetection.getBlobNb());
            b = theBlobDetection.getBlob(n);
            if (b!=null) 
            {
              
              //_blobs.add(b);
              //println("blob: " + b.x + "," + b.y);
              
  	    if (drawPoints) 
            {    
                if (_counter==0) 
                {
                  _prevX = _currentX;
                  _prevY = _currentY;
                }
                  
                _currentX = b.x*CaptureTheCam.cameraWidth;
                _currentY = b.y*CaptureTheCam.cameraHeight;
                _counter +=1; _counter = _counter%10; 
            }
        }
      }//end n++
    }
  }
  
        
  
  public void DrawLine()
  {
    if (styleInterface != null)
      styleInterface.draw();
  }
  
  // Methode Mars Draw Events
  public boolean blobOn(Warp9 wrp)
  {
    //boolean blob_on = false;
    
    if (styleInterface == null)
      styleInterface = new StyleInterface();
    
    if (detect == true) 
    {
      
      if (_blobOn)
      {  
        if(theBlobDetection.getBlobNb()!=0)
        {         
                
          //styleInterface.OnDragged(getCurrentX(),getCurrentY(), getPrevX(),getPrevY()); 
          //println("dragged to: " + getCurrentX() + ", " + getCurrentY());
          _blobOn = true;
        }
        else
        {
          //released
          //styleInterface.OnReleased();
          //_oldBlob = null;
          //println("released.");
          _blobOn = false;
        }
      }
      else
      {
        if(theBlobDetection.getBlobNb()!=0)
        {
          //pressed
          //styleInterface.OnPressed();
          _blobOn = true;
        }
        else
        {
          _blobOn = false;
        }
      }
    } 
    return _blobOn;
  }
  
  void drawBlobpoints(boolean drawPoints, Warp9 wrp) {
    if (detect == true) {
      Blob b;
       for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++) {
	  b = theBlobDetection.getBlob(n);
	  if (b!=null) {
	    if (drawPoints) {
              fill(222,20);
              noStroke();
              arc(wrp.computeWarpedX(b.x*CaptureTheCam.cameraWidth,b.y*CaptureTheCam.cameraHeight),wrp.computeWarpedY(b.x*CaptureTheCam.cameraWidth,b.y*CaptureTheCam.cameraHeight), 20, 20, 0, 2*PI);
	      }        
          }
       }
    }
  }
  
  void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges, Warp9 wrp) {
	
  if (detect == true) {
    //noFill();
    Blob b;
    EdgeVertex eA,eB;
      for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++) {
	  b = theBlobDetection.getBlob(n);
	  if (b!=null) {
            // Edges
	    if (drawEdges) {
	      strokeWeight(2);
	      stroke(230, 20, 20, 60);
              fill(230, 20, 20, 255); 
              
              beginShape();
	       for (int m = 0; m < b.getEdgeNb(); m++) {
		 eA = b.getEdgeVertexA(m);
		 eB = b.getEdgeVertexB(m);
		   if (eA != null && eB != null) {
	             vertex(wrp.computeWarpedX(eA.x * CaptureTheCam.cameraWidth, eA.y * CaptureTheCam.cameraHeight), wrp.computeWarpedY(eA.x * CaptureTheCam.cameraWidth, eA.y * CaptureTheCam.cameraHeight));
		   }
               }
              endShape(CLOSE);    
              scale(2.5, 2.5, 1.0);
	    }          
	    // Blobs
	    if (drawBlobs) {
            //if (false) {
	     // N/A
	    }
	  }
      } // end n++
  } // detect  
} // end drawBlobs
  
  
  void drawBlobsAndEdges2(boolean drawBlobs, boolean drawEdges, Warp9 wrp) {
	
    float scaleFactor = 0.15;
    
  if (detect == true) {
    //noFill();
    Blob b;
    EdgeVertex eA,eB;
      for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++) {
	  b = theBlobDetection.getBlob(n);
	  if (b!=null) {
            // Edges
	    if (drawEdges) {
              for (int i = 0; i < 2; i++)
              {
                if (i == 0)
                {
      	        strokeWeight(2);
      	        stroke(230, 20, 20, 60);
                fill(230, 20, 20, 150); 
                scaleFactor = -0.7;
                }
                else if (i == 1)
                {
      	        strokeWeight(2);
      	        stroke(230, 20, 20, 60);
                fill(230, 20, 20, 255); 
                scaleFactor = -0.3;
                }
                //PImage shapeImage = get(0, 0, CanvasOnScreen.canvasWidth, CanvasOnScreen.canvasHeight);
                float x = wrp.computeWarpedX(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
                float y = wrp.computeWarpedY(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
                
                beginShape();
  	         for (int m = 0; m < b.getEdgeNb(); m++) {
  		 eA = b.getEdgeVertexA(m);
  		 eB = b.getEdgeVertexB(m);
  		  if (eA != null && eB != null) 
                    {
                      
                     float eAx = wrp.computeWarpedX(eA.x * CaptureTheCam.cameraWidth, eA.y * CaptureTheCam.cameraHeight);
                     float eAy = wrp.computeWarpedY(eA.x * CaptureTheCam.cameraWidth, eA.y * CaptureTheCam.cameraHeight);
                     float differenceX = eAx - x;
                     float differenceY = eAy - y;
                     
                     float eAxNew = eAx + scaleFactor * differenceX;
                     float eAyNew = eAy + scaleFactor * differenceY;
                   
                   //println("old eA: " + eAx + "," + eAy + " new eA: " + eAxNew + "," + eAyNew);
  
  	             //vertex(eAx, eAy);
  	             vertex(eAxNew, eAyNew);
  		   }
                 }
                endShape(CLOSE);    
              }
	    }          
	    // Blobs
	    if (drawBlobs) {
            //if (false) {
	     // N/A
	    }
	  }
      } // end n++
  } // detect  
} // end drawBlobs
  
   void drawBlobsAndEdges3(float brushSize, color brushColor, Warp9 wrp) {
    
    float scaleFactor = 0.15;
    
  if (detect == true) {
    //noFill();
    Blob b;
    EdgeVertex eA,eB;
      for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++) {
	  b = theBlobDetection.getBlob(n);
	  if (b!=null) {
              int maxSteps = 40;
              for (int i = 1; i <= maxSteps; i++)
              {
                //float alphaValue = (255/(maxSteps/(float)10)) * (float)(Math.pow(maxSteps - i, 2) / Math.pow((float)maxSteps, 2));
                //float alphaValue = ((maxSteps - i)/ (float)maxSteps)*(255/(maxSteps/(float)4));
                //float alphaValue = ((maxSteps - i)/ (float)maxSteps)*(255);
                float alphaValue = (255 * (float)(Math.pow(maxSteps - i, 2) / Math.pow(maxSteps, 2)));
                fill(brushColor, alphaValue); 
                //scaleFactor =  1 - (float)(Math.pow(maxSteps - i, 2)/ Math.pow((float)maxSteps, 2));
                scaleFactor =  1 - (float)(maxSteps - i)/ maxSteps;
                
                //println("scaleFactor, brushSize: " + scaleFactor + ", " + brushSize);
                //println("b.w, b.h: "+ b.w * 1280 + ", " + b.h * 960);
                
                
                //PImage shapeImage = get(0, 0, CanvasOnScreen.canvasWidth, CanvasOnScreen.canvasHeight);
                float x = wrp.computeWarpedX(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
                float y = wrp.computeWarpedY(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
                
                beginShape();
  	         for (int m = 0; m < b.getEdgeNb(); m++) {
  		 eA = b.getEdgeVertexA(m);
  		 eB = b.getEdgeVertexB(m);
  		  if (eA != null && eB != null) 
                    {
                      
                     float eAx = wrp.computeWarpedX(eA.x * CaptureTheCam.cameraWidth, eA.y * CaptureTheCam.cameraHeight);
                     float eAy = wrp.computeWarpedY(eA.x * CaptureTheCam.cameraWidth, eA.y * CaptureTheCam.cameraHeight);
                     float differenceX = eAx - x;
                     float differenceY = eAy - y;
                     
                     float eAxNew = x + scaleFactor * (differenceX * (brushSize / 10));
                     float eAyNew = y + scaleFactor * (differenceY * (brushSize / 10));
                   
                   //println("old eA: " + eAx + "," + eAy + " new eA: " + eAxNew + "," + eAyNew);
  
  	             //vertex(eAx, eAy);
  	             vertex(eAxNew, eAyNew);
  		   }
                 }
                endShape(CLOSE);    
              }
	  }
      } // end n++
  } // detect  
} // end drawBlobs
  
  
  void drawBlobsAndEdgesFade(float brushSize, color brushColor, float alphaFactor, Warp9 wrp) {
    
    float scaleFactor = 0.15;
    
  if (detect == true) {
    //noFill();
    Blob b;
    EdgeVertex eA,eB;
      for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++) {
	  b = theBlobDetection.getBlob(n);
	  if (b!=null) {
              int maxSteps = 40;
              for (int i = 1; i <= maxSteps; i++)
              {
                float alphaValue = (255/(maxSteps/alphaFactor)) * (float)(Math.pow(maxSteps - i, 2) / Math.pow((float)maxSteps, 2));
                fill(brushColor, alphaValue); 
                scaleFactor =  1 - (float)(Math.pow(maxSteps - i, 2)/ Math.pow((float)maxSteps, 2));
                
                //println("scaleFactor, brushSize: " + scaleFactor + ", " + brushSize);
                //println("b.w, b.h: "+ b.w * 1280 + ", " + b.h * 960);
                
                
                //PImage shapeImage = get(0, 0, CanvasOnScreen.canvasWidth, CanvasOnScreen.canvasHeight);
                float x = wrp.computeWarpedX(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
                float y = wrp.computeWarpedY(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
                
                beginShape();
  	         for (int m = 0; m < b.getEdgeNb(); m++) {
  		 eA = b.getEdgeVertexA(m);
  		 eB = b.getEdgeVertexB(m);
  		  if (eA != null && eB != null) 
                    {
                      
                     float eAx = wrp.computeWarpedX(eA.x * CaptureTheCam.cameraWidth, eA.y * CaptureTheCam.cameraHeight);
                     float eAy = wrp.computeWarpedY(eA.x * CaptureTheCam.cameraWidth, eA.y * CaptureTheCam.cameraHeight);
                     float differenceX = eAx - x;
                     float differenceY = eAy - y;
                     
                     float eAxNew = x + scaleFactor * (differenceX * (brushSize / 10));
                     float eAyNew = y + scaleFactor * (differenceY * (brushSize / 10));
                   
                   //println("old eA: " + eAx + "," + eAy + " new eA: " + eAxNew + "," + eAyNew);
  
  	             //vertex(eAx, eAy);
  	             vertex(eAxNew, eAyNew);
  		   }
                 }
                endShape(CLOSE);    
              }
	  }
      } // end n++
  } // detect  
} // end drawBlobs
  
void drawEllipses(float maxRadius, color brushColor, Warp9 wrp) {
  if (detect == true) {
    //noFill();
    Blob b;
    EdgeVertex eA,eB;
      for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++) {
	  b = theBlobDetection.getBlob(n);
	  if (b!=null) {
	    
                float x = wrp.computeWarpedX(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
                float y = wrp.computeWarpedY(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
                
                beginShape();
  	         brushes.EllipseBrush(x, y, maxRadius, brushColor);
                endShape(CLOSE);    
              }    
      } // end n++
  } // detect  
} // end drawBlobs
  
  
  public void drawGrafitti(float brushSize, color brushColor, boolean dynamicBrushSize, Warp9 wrp)
  {    
    
    //initialisation of "speed" variables
    float weight = 1;
    float scaleFactor = 0;
    
    if (detect == true) {
      Blob b;
        //loop all detected blobs
        
        for (int n = 0 ; n < theBlobDetection.getBlobNb() ; n++) {
          

	  b = theBlobDetection.getBlob(n);
	  if (b!=null) 
          {
            // compute current blob's warped coordinates
            float x = wrp.computeWarpedX(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
            float y = wrp.computeWarpedY(b.x * CaptureTheCam.cameraWidth, b.y * CaptureTheCam.cameraHeight);
            
            //exclude all blobs that are more than 150 pixels out of our drawing canvas (workaround!)
            //if (x < 0 - 150 || x > CanvasOnScreen.canvasWidth + 150 || y < 0  - 150 || x > CanvasOnScreen.canvasHeight + 150)
              //continue;
           
           int oldBlobIndex = n;
          
          
              //println("old blob index: " + oldBlobIndex + ", is set: " + _oldBlobSet[n]);
            if (_oldBlobSet[n] == false || (_oldBlobSet[n] == true && oldBlobIndex != GetNearestOldBlobIndex(x, y) && theBlobDetection.getBlobNb() != _lastBlobCount))
            {
              oldBlobIndex = GetNearestOldBlobIndex(x, y);
              
             // println("nearest old blob: " + oldBlobIndex);
            }
          
           if (oldBlobIndex != -1)
           {
               if (oldBlobIndex != n)
               {
                 SwapOldBlobs(oldBlobIndex, n);
                 oldBlobIndex = n;
               }
             
             // set old blob reset timer to current milliseconds
                _oldBlobResetTimer[oldBlobIndex] = millis();
             
              //private _oldblob was detected in previous draw loop
              if (_oldBlobSet[oldBlobIndex] == false)
              {
                //println("oldblob null");
                _oldBlobSet[oldBlobIndex] = true;
                _oldBlobX[oldBlobIndex] = x;
                _oldBlobY[oldBlobIndex] = y;
                _oldBlobScaleFactor = 0;
              }
              else
              {
                //continues for-loop when old and new blob are on 
                if (x == _oldBlobX[oldBlobIndex]  && y == _oldBlobY[oldBlobIndex])
                  continue;
              }
              
              
              // compute old blob's warped coordinates
              //float oldx = wrp.computeWarpedX(_oldBlobX * CaptureTheCam.cameraWidth, _oldBlobY * CaptureTheCam.cameraHeight);
              //float oldy = wrp.computeWarpedY(_oldBlobX * CaptureTheCam.cameraWidth, _oldBlobY * CaptureTheCam.cameraHeight);
              float oldx = _oldBlobX[oldBlobIndex];
              float oldy = _oldBlobY[oldBlobIndex];
              
              // compute distance between current and old blob
              double distance = GetDistance(x, y, oldx, oldy);
              
              
              if (dynamicBrushSize)
              {
                //only run this if we want the brushes thickness to adjust to "speed" of drawing
                
                scaleFactor = (float)distance;
              
                if (Math.abs(_oldBlobScaleFactor - scaleFactor) > CanvasOnScreen.SpeedChange && _oldBlobScaleFactor != 0)
  				scaleFactor = (float) (_oldBlobScaleFactor - CanvasOnScreen.SpeedChange * Math.signum(_oldBlobScaleFactor - scaleFactor));
  
  	      weight = (float)(CanvasOnScreen.MaxWidth - scaleFactor * CanvasOnScreen.SpeedInfluence);
  	      weight = (float) (weight < CanvasOnScreen.MinWidth ? CanvasOnScreen.MinWidth : weight);
  	      weight = (float) (weight > CanvasOnScreen.MaxWidth ? CanvasOnScreen.MaxWidth : weight);
              }
              
              //create a line between the last two blobs, paint a brush each pixel.
              int steps = (int)(distance);
              for (int i = 0; i <= steps; i++) {
                float t = i / float(steps);
                float paintx = GetCoordinatePointOnLine(x, oldx, t);
                float painty = GetCoordinatePointOnLine(y, oldy, t);
                brushes.EllipseBrush(paintx, painty, brushSize * weight, brushColor);
              }
              
              //set the new "old blob"
              _oldBlobSet[oldBlobIndex] = true;
              _oldBlobX[oldBlobIndex] = x;
              _oldBlobY[oldBlobIndex] = y;
              _oldBlobScaleFactor = scaleFactor;
           }
           else
           {
             //set the new "old blob"
              //println("adding old blob: " + n);
            _oldBlobSet[n] = true;
            _oldBlobX[n] = x;
            _oldBlobY[n] = y;
            _oldBlobScaleFactor = scaleFactor;
            _oldBlobResetTimer[n] = millis();
           }
           
            //draw a single brush to current location
            brushes.EllipseBrush(x, y, brushSize * weight, brushColor);
          }
        }
      }     
 }
 
 public float GetCoordinatePointOnLine(float x, float oldX, float scalar)
 {
   return (oldX + scalar * (x - oldX));
 }
 
 private double GetDistance(float x, float y, float oldx, float oldy)
 {
   return Math.sqrt((x-oldx)*(x-oldx)+(y-oldy)*(y-oldy));
 }
 
 private int GetNearestOldBlobIndex(float x, float y)
 {
   double maxDistance = 140;
   int index = -1;
   
   for (int i = 0; i < _oldBlobSet.length; i++)
   {
     if (_oldBlobSet[i])
     {
       double distance = GetDistance(x, y, _oldBlobX[i], _oldBlobY[i]);
       if (distance < maxDistance)
       {
         maxDistance = distance;
         index = i;
       }
     }
   }
   
   
  // println("found nearest old blob: " + index);
   
   return index;
 }
 
 private void SwapOldBlobs(int start, int end)
 {
   println("swapping blobs: " + start + ", " + end);
   boolean blobSet = _oldBlobSet[start];
   float x = _oldBlobX[start];
   float y = _oldBlobY[start];
   
   _oldBlobSet[start] = _oldBlobSet[end];
   _oldBlobX[start] = _oldBlobX[end];
   _oldBlobY[start] = _oldBlobY[end];
   
   
   _oldBlobSet[end] = blobSet;
   _oldBlobX[end] = x;
   _oldBlobY[end] = y;
 }
 
  public void drawBrush(float x, float y)
  {
    if (_brushImage != null)
    {
      println("drawing image: " + _brushImage.width + ", " + _brushImage.height + " to " + x + ", " + y);
      image(_brushImage, x, y);
    }
  }
  
PImage CreateBrush(float x, float y, int radius, int level)    
{
  
  float tt = 126 * level/6.0;
  //fill(tt, 40);
  fill((tt*5) % 255, (tt*2)%255, (tt*3)%255, 255);
  if (radius < 5)
   ellipse(x, y, radius*2, radius*2);      
  if(level > 1) {
    level = level - 1;
    int num = int(random(2, 6));
    for(int i=0; i<num; i++) {
      float a = random(0, TWO_PI);
      float nx = x + cos(a) * 6.0 * level;
      float ny = y + sin(a) * 6.0 * level;
      CreateBrush(nx, ny, radius/2, level);
    }
  }
  
  PImage bufferImage = null;
  
  try
  {
    bufferImage = get((int)(x - radius), (int)(y - radius), radius, radius);
  }
  catch(Exception ex)
  {
  }
  
  return bufferImage;
}
  
  void fastblur(PImage img,int radius){

  if (radius < 1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
     dv[i]=(i/div); 
  }
  
  yw=yi=0;
 
  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
   }
    for (x=0;x<w;x++){
    
      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
       } 
       p1=pix[yw+vmin[x]];
       p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }
  
  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      } 
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
      }
    }
  }
 
  private PImage lowPassBlur(PImage img)
  {
    float v = 1.0/9.0;
    float[][] kernel = { { v, v, v },
                         { v, v, v },
                         { v, v, v } };
    
    
    // Create an opaque image of the same size as the original
    PImage edgeImg = createImage(img.width, img.height, RGB);
    
    // Loop through every pixel in the image.
    for (int y = 1; y < img.height-1; y++) { // Skip top and bottom edges
      for (int x = 1; x < img.width-1; x++) { // Skip left and right edges
        float sum = 0; // Kernel sum for this pixel
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            // Calculate the adjacent pixel for this kernel point
            int pos = (y + ky)*img.width + (x + kx);
            // Image is grayscale, red/green/blue are identical
            float val = red(img.pixels[pos]);
            // Multiply adjacent pixels based on the kernel values
            sum += kernel[ky+1][kx+1] * val;
          }
        }
        // For this pixel in the new image, set the gray value
        // based on the sum from the kernel
        edgeImg.pixels[y*img.width + x] = color(sum);
      }
    }
    // State that there are changes to edgeImg.pixels[]
    edgeImg.updatePixels();
    //image(edgeImg, 100, 0); // Draw the new image
    return edgeImg;
  } 

}
