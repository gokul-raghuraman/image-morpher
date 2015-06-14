void keyPressed()
{
  
  if (key == '')
  {
    //guiManager.deleteSelectedFeaturePoint(activeFrame);
  }
  
  if (key == '1')
  {
    activeFrame = 0;
    morphedFrameID = 1;
  }
  
  if (key == '2')
  {
    activeFrame = 1;
    morphedFrameID = 0;
  }
  
  if (key == '`')
  {
    showFeaturePoints = !showFeaturePoints;
  }
  
  if (key == 'c' || key == 'C')
  {
    guiManager.clearFeaturePointsForFrame(activeFrame);
  }
  
  if (key == 's' || key == 'S')
  {
    guiManager.saveFeaturePointsForFrame(activeFrame);
  }
  
  if (key == 'l' || key == 'L')
  {
    guiManager.loadFeaturePointsForFrame(activeFrame);
  }
  
  if (key == 'm' || key == 'M')
  {
    guiManager.processMorph();
    /*
    if (guiManager.morphedFrame1 == null || guiManager.morphedFrame2 == null)
      guiManager.morphBetweenFrames(0, 1);
    showMorphedFrame = !showMorphedFrame;
    */
  }
  
  if (key == '3')
  {
    showMorphedFrame = !showMorphedFrame;
    if (showMorphedFrame == false)
      activeFrame = 0;
  }
  
  if (key == '-' || key == '_')
  {
    if (morphedFrameID > 0)
    {
      morphedFrameID -= 1;
      activeFrame = morphedFrameID;
    }
  }
  
  if (key == '=' || key == '+')
  {
    if (morphedFrameID < guiManager.morpher.frames.size() - 1)
    {
      morphedFrameID += 1;
      activeFrame = morphedFrameID;
    }
  }
  
  if (key == 'r' || key == 'R')
  {
    guiManager.loadMorphedFrames();
  }
  
  if (key == 'w' || key == 'W')
  {
    guiManager.saveMorphedFrames();
  }
  
  if (key == 'p' || key == 'P')
  {
    guiManager.playing = !guiManager.playing;
    guiManager.resetPlay();
  }
}

void mouseClicked()
{
  if (mouseButton == LEFT)
  {
    if (guiManager._getSelectedFeaturePoint(activeFrame, mouseX, mouseY) > -1)
      guiManager.loadSelectedFeaturePoint(activeFrame, mouseX, mouseY);
    else
    {
      if (!guiManager.clicked)
        guiManager.registerFirstClick(mouseX, mouseY);
      else
      {
        guiManager.registerSecondClick(mouseX, mouseY);
        guiManager.addLineForFrame(activeFrame);
      }
    }
  }
}

void mousePressed()
{
  if (mouseButton == LEFT)
  { 
    if (guiManager._getSelectedLine(activeFrame, mouseX, mouseY) > -1)
    {
      guiManager.loadActiveFeaturePoint(activeFrame, mouseX, mouseY);
    }
  }
}

void mouseDragged()
{
  if (mouseButton == LEFT)
  {
    if (guiManager.lineDragged)
      guiManager.updateActiveFeaturePoint(activeFrame, mouseX, mouseY);
  }
}

void mouseReleased()
{
  if (mouseButton == LEFT)
  {
    if (guiManager.lineDragged)
      guiManager.releaseActiveFeaturePoint(activeFrame);
  }
}
