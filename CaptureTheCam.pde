import processing.video.*;

//responsible for capturing a webcam image
public static class CaptureTheCam
{
  
  static int cameraWidth = 640;
  static int cameraHeight = 480;
  static int usedID = 0;
  static int cap_fps = 100;
  
//  // camera resolution
//typedef enum
//{
//    CLEYE_QVGA,                 // Allowed frame rates: 15, 30, 60, 75, 100, 125
//    CLEYE_VGA                   // Allowed frame rates: 15, 30, 40, 50, 60, 75
//}CLEyeCameraResolution;

  
  private int imgWidth = 320;
  private int imgHeight = 240;
  
  /*public static PImage getCamImage(Capture _capPic) {
    PImage img;
    img = new PImage(320,240);
    img.copy(_capPic, 0, 0, _capPic.width, _capPic.height, 0,0, img.width, img.height);
    return img;
  }*/

}
  /*private int _cameraID;
  private Capture _capPic;
  private int _fps;
  //public String[] devices;
  public final int imgWidth = 640;
  public final int imgHeight = 480;
  
  //constructor
  public CaptureTheCam(int camID, int frame, Capture camCapture, PImage camImage)
  {
    _fps = frame;
    _cameraID = camID;
    //nochmal überlegen:
    //Capture camCapture;
    //devices = Capture.list();
    //println(devices);
    _capPic = camCapture;
    //camImage = getCamImage();
  }
  
  public String[] printDevices(){
    String[] devices;
    devices = Capture.list();
    println(devices);
    return devices;
  }
  
  public void camOnScreen(int setPosX, int setPosY, Capture _capPic){
      image(_capPic,setPosX,setPosY,imgWidth,imgHeight);
  }
  
  public void getCamImage(PImage img) {
    //PImage img;
    img = new PImage(320,240);
    img.copy(_capPic, 0, 0, _capPic.width, _capPic.height, 0,0, img.width, img.height);
    //return img;
  }
  
}*/
