import processing.video.*;
import processing.opengl.*;
import blobDetection.*;
import cl.eye.*;


//Capture camCapture;
CLCamera clCamCapture;

PImage img; // Detected Blobs
PImage img_buffer; //detectedblob buffer
PImage img_background; // background buffer
boolean newFrame = true;
boolean to_calib;
int calibCounter;
float[] srcX;
float[] srcY;


  
float BrushSize = 20;
color BrushColor = color(255, 0, 0); 
int redColor = 255;
int greenColor = 0;
int blueColor = 0;

ColorChord[] colorChords;
int currentChord;


DetectionAction detCam;
DoCalibration calibration;

//xml-calibration file access
//XMLElement xmlsettings;
SaveToXml getNSave;

void setup() 
{
		// Library loading via native interface (JNI)
		// If you see "UnsatisfiedLinkError" then target the library path
		// otherwise leave it commented out.
		//CLCamera.loadLibrary("C://Windows//System32//CLEyeMulticam.dll");
    //System.load("C:/Windows/System32/CLEyeMulticam.dll");
    
   CLCamera.loadLibrary("C:/CLEyeMulticam.dll");
//   System.loadLibrary("CLEyeMulticam");
  
    // Screen stuff
    //String[] devices = Capture.list();
    //println(devices);
    size(CanvasOnScreen.canvasWidth,CanvasOnScreen.canvasHeight,OPENGL);
    background(CanvasOnScreen.backcolor);
    frameRate(CaptureTheCam.cap_fps);
 
     to_calib = false;
     getNSave= new SaveToXml(this); // load our settings!
    //xmlsettings = new XMLElement(this, "settings/settings.xml"); // load our settings
 
   img = new PImage(320,240);
   //img = new PImage(640,480);
   
   img_background = new PImage(CanvasOnScreen.canvasWidth,CanvasOnScreen.canvasHeight);
   //camCapture = new Capture(this, CaptureTheCam.cameraWidth, CaptureTheCam.cameraHeight, devices[CaptureTheCam.usedID],CaptureTheCam.cap_fps); // device id will change per machine
  // Checks available cameras
  int numCams = CLCamera.cameraCount();
  println("number of cl cams: " + numCams);
  clCamCapture = new CLCamera(this);
    // ----------------------(i, CLEYE_GRAYSCALE/COLOR, CLEYE_QVGA/VGA, Framerate)
    //clCamCapture.createCamera(0, CLCamera.CLEYE_COLOR, CLCamera.CLEYE_VGA, 125);
    clCamCapture.createCamera(0, 0, 0, CaptureTheCam.cap_fps);
    // Starts camera captures
    clCamCapture.startCamera();
    //img = createImage(CaptureTheCam.cameraWidth, CaptureTheCam.cameraHeight, RGB); 
    img = createImage(320, 240, RGB);

    // This code will try to use the camera used
    //img_buffer = new PImage(640,480);
    
    detCam = new DetectionAction(img.width, img.height);
    calibration = new DoCalibration();
    calibration.setDefaultSrc(getNSave);
    calibCounter = 0;
    srcX = new float[4];
    srcY = new float[4];
    
       
    //sets Location of the fullscreen application
    frame.setLocation(CanvasOnScreen.mainScreenResolutionX + CanvasOnScreen.canvasPositionX,0 + CanvasOnScreen.canvasPositionY);
    //frame.setLocation(-1280, 0);
    
    InitializeColorChords();

}

void captureEvent(Capture myCapture) {
  myCapture.read();
  newFrame = true;
}


void init()
{
  frame.removeNotify();
  frame.setUndecorated(true); // works.

  // call PApplet.init() to take care of business
  super.init();
}


void draw() {

  //background(CanvasOnScreen.backcolor);

  
  //img.copy(camCapture, 0, 0, camCapture.width, camCapture.height, 0,0, img.width, img.height); // Output
    
    clCamCapture.getCameraFrame(img.pixels, 0);
    img.updatePixels();
    //image(img, cameraWidth , 0);
    // draw stuff	
    if(true){
      newFrame = false;
      

        detCam.detectBlobs(img);
        detCam.setNewBlobsxy(true,0,true);
        
        if(to_calib){
          calibration.calibrateView();
          println(detCam.getCurrentX() + "  " + detCam.getCurrentY());
          calibration.catchCalCoords(detCam.getCurrentX(),detCam.getCurrentY(),calibCounter);
          image(img, CanvasOnScreen.canvasPositionX + (CanvasOnScreen.canvasWidth - CaptureTheCam.cameraWidth) / 2, CanvasOnScreen.canvasPositionY + (CanvasOnScreen.canvasHeight - CaptureTheCam.cameraHeight) / 2, img.width, img.height);
          //image(img, CanvasOnScreen.canvasPositionX, CanvasOnScreen.canvasPositionY);
          
          if(calibCounter==4){
          calibration.setSrc(srcX,srcY);
          calibration.calibrateIt();
          calibration.calibrateClear(calibration.getCalState());
          to_calib = calibration.getCalState();
          background(CanvasOnScreen.backcolor);
          getNSave.saveXml(srcX,srcY);//(calibration.getSrcX(),calibration.getSrcY());
          }
        }
        else {
          //if drawing time invalidates, invalidate oldBlob->no connection between blobs
          for (int j = 0; j < CanvasOnScreen.availLaser; j++)
          {
            if(checkResetTimer(j)){
             detCam.invalidateOldBlob(j);
            }
          }
          //testapplication();
          
          
        //image(img, CanvasOnScreen.canvasPositionX + (CanvasOnScreen.canvasWidth - CaptureTheCam.cameraWidth) / 2, CanvasOnScreen.canvasPositionY + (CanvasOnScreen.canvasHeight - CaptureTheCam.cameraHeight) / 2, img.width, img.height);
        
        	// offset from corner
        //image(img_buffer,0,0,640,480);
        noStroke();
        //image(img_background,0,0);
        
        //detCam.drawBlobpoints(true);
        //detCam.drawBlobsAndEdges2(false ,true, calibration.warping); 
        
        detCam.drawBlobsAndEdges3(BrushSize, BrushColor, calibration.warping);
        //detCam.drawBlobsAndEdgesFade(BrushSize, BrushColor, 10, calibration.warping);
        //detCam.blobOn(calibration.warping);
        //detCam.DrawLine();
        //detCam.drawEllipses(BrushSize, BrushColor, calibration.warping);
        
        //detCam.drawGrafitti(BrushSize, BrushColor, false, calibration.warping);
        
        //detCam.setNewBlobxy(true,0,true);
        //img_background = get(0, 0, CanvasOnScreen.canvasWidth, CanvasOnScreen.canvasHeight);
		//fill(255);
		//textSize(18);
        //println("current frame rate: " + round(frameRate));
	//text("current frame rate: " + round(frameRate), 5, height - 30);
        //drawInfo();
        
        fill(255,0,0,80);
       
        //arc(detCam.getCurrentX(),detCam.getCurrentY(), 8, 8, 0, 2*PI);
        //image(img_buffer,0,0,640,480);
       
        //img_buffer = get(50,50,640,480);//funktioniert einfach nicht
        
    }
    
  }
  
}


public void testapplication(){
           fill(255,0,0);
          //calibration.warping.warpCoordinates(mouseX,mouseY);
          arc(calibration.warping.computeWarpedX(detCam.getCurrentX(),detCam.getCurrentY()),calibration.warping.computeWarpedY(detCam.getCurrentX(),detCam.getCurrentY()), 20, 20, 0, 2*PI);
          //println(calibration.warping.getWarpedX() + " " + calibration.warping.getWarpedY());
}


    	public void keyPressed()
	{
            switch(key){
		case ESC: 
		{
			exit();
		}
		case ' ':
		{ //print("space pressed");
                  if(to_calib) { 
                    calibCounter += 1;
                    calibCounter%=5; //println("calibCounter now" + calibCounter);
                  } else {
                        String filename = millis() + ".png";
                        save(filename);
                        println("saved file " + filename);
                        background(CanvasOnScreen.backcolor);
			img_buffer = null;

                  }
                  break;
		}
                case 'c':
                {
                 to_calib = true; 
                 calibCounter = 0;
                 background(CanvasOnScreen.backcolor);
                 break;
                }
                case 'l':
                {
                  if (BrushSize < 75)
                  BrushSize *= 1.05;
                }
                break;
                case 'k':
                {
                  if (BrushSize > 10)
                    BrushSize *= 0.95;
                }
                break;
                case '1':
                {
                  BrushSize = 7;
                }
                break;
                case '2':
                {
                  BrushSize = 14;
                }
                break;
                case '3':
                {
                  BrushSize = 21;
                }
                break;
                case '4':
                {
                  BrushSize = 35;
                }
                break;
                case '5':
                {
                  BrushSize = 49;
                }
                break;
                case '6':
                {
                  BrushSize = 63;
                }
                break;
                case '7':
                {
                  BrushSize = 85;
                }
                break;
                case 'u':
                {
                  currentChord--;
                  if (currentChord < 0)
                    currentChord = colorChords.length - 1;
                    
                  BrushColor = colorChords[currentChord].GetColor(0);
                }
                break;
                case 'i':
                {
                  currentChord++;
                  if (currentChord > colorChords.length - 1)
                    currentChord = 0;
                    
                  BrushColor = colorChords[currentChord].GetColor(0);
                }
                break;
                case 'r':
                {
//                  redColor = 255;
//                  greenColor = 0;
//                  blueColor = 0;
//                  BrushColor = color(redColor,greenColor,blueColor);
                    BrushColor = colorChords[currentChord].GetColor(0);
                }
                break;
                case 'g':
                {
//                  redColor = 0;
//                  greenColor = 255;
//                  blueColor = 0;
//                  BrushColor = color(redColor,greenColor,blueColor);
                    BrushColor = colorChords[currentChord].GetColor(1);
                }
                break;
                case 'b':
                {
//                  redColor = 0;
//                  greenColor = 0;
//                  blueColor = 255;
//                  BrushColor = color(redColor,greenColor,blueColor);
                    BrushColor = colorChords[currentChord].GetColor(2);
                }
                break;
                case 'q':
                {
                  redColor -= 25;
                  if (redColor < 0)
                    redColor = 0;
                  BrushColor = color(redColor,greenColor,blueColor);
                }
                break;
                case 'w':
                {
                  redColor += 25;
                  if (redColor > 255)
                    redColor = 255;
                  BrushColor = color(redColor,greenColor,blueColor);
                }
                break;
                case 'a':
                {
                  greenColor -= 25;
                  if (greenColor < 0)
                    greenColor = 0;
                  BrushColor = color(redColor,greenColor,blueColor);
                }
                break;
                case 's':
                {
                  greenColor += 25;
                  if (greenColor > 255)
                    greenColor = 255;
                  BrushColor = color(redColor,greenColor,blueColor);
                }
                break;
                case 'y':
                {
                  blueColor -= 25;
                  if (blueColor < 0)
                    blueColor = 0;
                  BrushColor = color(redColor,greenColor,blueColor);
                }
                break;
                case 'x':
                {
                  blueColor += 25;
                  if (blueColor > 255)
                    blueColor = 255;
                  BrushColor = color(redColor,greenColor,blueColor);
                }
                break;
            }
	}


      public void drawInfo(){
        fill(0);
        rect(5,height -60,250,50);
        fill(0,255,0);
	text("current frame rate of draw loop: " + round(frameRate), 5, height - 30);
      }

      public boolean checkResetTimer(int blobIndex){
        if(millis()-detCam.getOldBolbTime(blobIndex)>50){
          return true;
        } else {
            return false; }
      }
      
      public void InitializeColorChords()
      {
        int chordAmount = 5;
        colorChords = new ColorChord[chordAmount];
        
        colorChords[0] = new ColorChord();
        colorChords[0].AddColor(color(178, 114, 21));
        colorChords[0].AddColor(color(145, 214, 188));
        colorChords[0].AddColor(color(117, 95, 49));
        colorChords[0].AddColor(color(118, 140, 106));
        colorChords[0].AddColor(color(255, 186, 75));
        
        colorChords[1] = new ColorChord();
        colorChords[1].AddColor(color(76, 27, 51));
        colorChords[1].AddColor(color(45, 105, 96));
        colorChords[1].AddColor(color(152, 169, 66));
        colorChords[1].AddColor(color(239, 230, 51));
        colorChords[1].AddColor(color(20, 29, 20));
        
        colorChords[2] = new ColorChord();
        colorChords[2].AddColor(color(161, 113, 108));
        colorChords[2].AddColor(color(67, 154, 171));
        colorChords[2].AddColor(color(114, 130, 150));
        colorChords[2].AddColor(color(255, 91, 0));
        colorChords[2].AddColor(color(0, 202, 189));
        
        colorChords[3] = new ColorChord();
        colorChords[3].AddColor(color(143, 63, 73));
        colorChords[3].AddColor(color(83, 122, 81));
        colorChords[3].AddColor(color(63, 48, 66));
        colorChords[3].AddColor(color(204, 195, 173));
        colorChords[3].AddColor(color(214, 108, 64));
        

        colorChords[4] = new ColorChord();
        colorChords[4].AddColor(color(170, 0, 0));
        colorChords[4].AddColor(color(0, 170, 0));
        colorChords[4].AddColor(color(0, 0, 170));
        
        currentChord = 0;
        
        BrushColor = colorChords[currentChord].GetNextColor();
      }
