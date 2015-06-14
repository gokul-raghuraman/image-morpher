class FrameManager
{
  ArrayList<Frame> frames;
  FrameManager(ArrayList<Frame> fs)
  {
    frames = fs;
  }
  
  Frame getFrame(int index)
  {
    return frames.get(index);
  }
}

