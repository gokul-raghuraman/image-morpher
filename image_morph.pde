
int WIDTH = 320;
int HEIGHT = 400;
Frame frame1, frame2;
FrameManager frameManager;
GUIManager guiManager;

int activeFrame = 0;
boolean showFeaturePoints = true;

boolean showMorphedFrame = false;
int morphedFrameID = 0;

void setup()
{
  size(600, 600);
  frame1 = new Frame("images/face1.jpg", "face1", WIDTH, HEIGHT);
  frame2 = new Frame("images/face2.jpg", "face2", WIDTH, HEIGHT);
  
  ArrayList<Frame> frames = new ArrayList<Frame>();
  frames.add(frame1);
  frames.add(frame2);
  
  frameManager = new FrameManager(frames);
  guiManager = new GUIManager(frameManager);
  
  frameRate(20);
  
}

void draw()
{ 
  background(white);
  if (!showMorphedFrame)
    guiManager.showFrame(activeFrame);
  
  else
    guiManager.showMorphedFrame(morphedFrameID);
  
  if (guiManager.playing)
  {
    guiManager.playMorph();
  }
  
  if (showFeaturePoints)
  {
    guiManager.showLinesForFrame(activeFrame);
    guiManager.showActiveLine();
    //guiManager.showFeaturePointsForFrame(activeFrame);
  }
  
  
}
