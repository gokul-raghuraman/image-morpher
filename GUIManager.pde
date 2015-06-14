class GUIManager
{
  
  boolean featurePointDragged;
  int draggedFeaturePointIndex;
  
  boolean lineDragged;
  int draggedLineIndex;
  int draggedFeaturePointIndicator;
  
  Pixel clickA, clickB;
  boolean clicked = false;
  
  FrameManager frameManager;
  
  Morpher morpher;
  
  //The two morphed frames
  Frame morphedFrame1, morphedFrame2;
  
  //For playback on/off
  boolean playing = false;
  
  GUIManager(FrameManager f)
  {
    frameManager = f;
    featurePointDragged = false;
    draggedFeaturePointIndex = -1;
    
    
    lineDragged = false;
    draggedLineIndex = -1;
    draggedFeaturePointIndex = -1;
    
    clickA = new Pixel(-1, -1);
    clickB = new Pixel(-1, -1);
    
    morpher = new Morpher(frameManager.getFrame(0), frameManager.getFrame(1));
  }
  
  void showFrame(int frameID)
  {
    Frame frame = frameManager.getFrame(frameID);
    frame.show();
  }
  
  void clearFeaturePointsForFrame(int frameID)
  {
    Frame frame = frameManager.getFrame(frameID);
    frame._clearFeaturePoints();
  }
  
  void loadActiveFeaturePoint(int frameID, int x, int y)
  {
    lineDragged = true;
    draggedLineIndex = _getSelectedLine(frameID, x, y);
    draggedFeaturePointIndicator = _getSelectedPoint(frameID, draggedLineIndex, x, y);
  }
  
  void updateActiveFeaturePoint(int frameID, int x, int y)
  {
    Frame frame = frameManager.getFrame(frameID);
    Line selectedLine = frame.lines.get(draggedLineIndex);
    Pixel selectedFeaturePoint = selectedLine.A;
    if (draggedFeaturePointIndicator == 1)
      selectedFeaturePoint = selectedLine.B;
    selectedFeaturePoint.x = x;
    selectedFeaturePoint.y = y;
  }
  
  void releaseActiveFeaturePoint(int frameID)
  {
    lineDragged = false;
    draggedLineIndex = -1;
    draggedFeaturePointIndex = -1;
  }
  
  //#################
  
  void registerFirstClick(int x, int y)
  {
    clicked = true;
    clickA = new Pixel(x, y);
  }
  
  void registerSecondClick(int x, int y)
  {
    clicked = false;
    clickB = new Pixel(x, y);
  }
  
  void addLineForFrame(int frameID)
  {
    Frame frame = frameManager.getFrame(frameID);
    frame._addLine(clickA, clickB);
    clickA = new Pixel(-1, -1);
    clickB = new Pixel(-1, -1);
  }
  
  void showLinesForFrame(int frameID)
  {
    Frame frame;
    if (!showMorphedFrame || morpher.frames.size() == 0)
      frame = frameManager.getFrame(frameID);
    else
    {
      frame = morpher.frames.get(frameID); 
    }
    frame.showLines();
  }
  
  void showActiveLine()
  {
    if (clickA.x != -1 && clickA.y != -1)
    {
      Line activeLine = new Line(clickA, new Pixel(mouseX, mouseY));
      activeLine.show();
    }
  }
  
  //#################
  
  int _getSelectedFeaturePoint(int frameID, int x, int y)
  {
    return -1;
  }
  
  boolean featurePointSelected(int frameID, int x, int y)
  {
    
    
    return false;
  }
  
  void loadSelectedFeaturePoint(int frameID, int x, int y)
  {
    
  }
  
  int _getSelectedPoint(int frameID, int lineID, int x, int y)
  {
    Frame frame = frameManager.getFrame(frameID);
    Line line = frame.lines.get(lineID);
    float dist1 = pow(line.A.x - x, 2) + pow(line.A.y - y, 2);
    float dist2 = pow(line.B.x - x, 2) + pow(line.B.y - y, 2);
    int selectedPoint = 0;
    if (dist2 < dist1)
      selectedPoint = 1;
    return selectedPoint;
  }
  
  int _getSelectedLine(int frameID, int x, int y)
  {
    Frame frame = frameManager.getFrame(frameID);
    
    for (int i = 0; i < frame.lines.size(); i++)
    {
      Line l = frame.lines.get(i);
      Pixel p1 = l.A;
      Pixel p2 = l.B;
      float dist1 = pow(p1.x - x, 2) + pow(p1.y - y, 2);
      float dist2 = pow(p2.x - x, 2) + pow(p2.y - y, 2);
      float dist = min(dist1, dist2);
      
      if (dist < 64)
        return i;
    }
    return -1;
  }
  
  void loadFeaturePointsForFrame(int frameID)
  {
    Frame frame = frameManager.getFrame(frameID);
    frame.loadFeatures();
  }
  
  void saveFeaturePointsForFrame(int frameID)
  {
    Frame frame = frameManager.getFrame(frameID);
    frame.saveFeatures();
  }
  
  void processMorph()
  {
    morpher.makeFrames(30);
    morpher.buildWarpedImages();
    morpher.buildMorphedImages();
    print("\nDone Processing Morph.");
  }
  
  void morphBetweenFrames(int sourceFrameID, int destFrameID)
  {
    Frame startFrame = frameManager.getFrame(sourceFrameID);
    Frame endFrame = frameManager.getFrame(destFrameID);
    
    morphedFrame1 = morpher.getMorphedFrame(startFrame, endFrame);
    morphedFrame2 = morpher.getMorphedFrame(endFrame, startFrame);
  }
  
  //******MORPHING******
  void showMorphedFrame(int frameID)
  {
    if (morpher.frames.size() == 0)
      return;
    print("\nShowing morphed frame : " + frameID);
    Frame morphedFrame = morpher.frames.get(frameID);
    morphedFrame.show();
  }
  
  void loadMorphedFrames()
  {
    morpher.loadFrames();
  }
  
  void saveMorphedFrames()
  {
    morpher.saveFrames();
  }
  
  void playMorph()
  {
    morpher.play();
    morpher.curPlayingFrame.show();
  }
  
  void resetPlay()
  {
    morpher.curPlayingFrame = morpher.frame1;
    morpher.playDirection = 1;
  }
  
  
}
