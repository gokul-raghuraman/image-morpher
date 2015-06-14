class Morpher
{
  Frame frame1, frame2;
  ArrayList<Frame> forwardFrames;
  ArrayList<Frame> backwardFrames;
  ArrayList<Frame> frames;
  
  //Morphing params
  float a = 5;
  float b = 1.5;      //[0.5, 2]
  float p = 0.5;      //[0, 1]
  
  //Playback
  int playDirection = 1;
  int curPlayingFrameIndex = 0;
  Frame curPlayingFrame;
  
  Morpher(Frame f1, Frame f2)
  {
    frame1 = f1;
    frame2 = f2;
    frames = new ArrayList<Frame>();
    forwardFrames = new ArrayList<Frame>();
    backwardFrames = new ArrayList<Frame>();
    
    curPlayingFrame = frame1;
  }
  
  void makeFrames(int numFrames)
  {
    frames = new ArrayList<Frame>();
    //Function that generates interpolating frames between frame1 and frame2. 
    //This function interpolates and stores the feature lines for each frame.
    //Note: It does NOT generate the morphed image for each frame.
  
    for (int i = 0; i < numFrames; i++)
    {
      Frame frame = new Frame("frame-" + nf(i, 5), frame1.width, frame1.height);
      
      float t = float(i) / float(numFrames - 1);
      
      //Interpolate all lines
      for (int j = 0; j < frame1.lines.size(); j++)
      {
        Line line1 = frame1.lines.get(j);
        Line line2 = frame2.lines.get(j);
        Pixel A = new Pixel(line1.A.x + t * (line2.A.x - line1.A.x), line1.A.y + t * (line2.A.y - line1.A.y));
        Pixel B = new Pixel(line1.B.x + t * (line2.B.x - line1.B.x), line1.B.y + t * (line2.B.y - line1.B.y));
        frame.lines.add(new Line(A, B));
      }
      frames.add(frame);
    }
  }
  
  //Call this after makeFrames()
  //This function will go through all frames, and create two images (forward and backward)
  //for each frame.
  void buildWarpedImages()
  {
    for (int i = 0; i < frames.size(); i++)
    {
      print("\nProcessing Frame " + i + " of " + frames.size());
      Frame frame = frames.get(i);
      frame.img = frame2.img;
      Frame forwardFrame = getMorphedFrame(frame1, frame);
      frame.img = frame1.img;
      Frame backwardFrame = getMorphedFrame(frame2, frame);
      forwardFrames.add(forwardFrame);
      backwardFrames.add(backwardFrame);
    }
  }
  
  //Call this after buildWarpedImages
  //This function will go through all frames, and synthesize a cross-faded sequence
  //between the forward and backward images
  //i.e. morphedImage[i] = forwardImage * (1 - alpha) + backwardImage * alpha
  //where alpha ranges from 0 to 1
  //The cross-faded image is stored back in `frames`.
  void buildMorphedImages()
  {
    float alpha;
    for (int i = 0; i < frames.size(); i++)
    {
      alpha = float(i) / float(frames.size() - 1);
      PImage forwardImage = forwardFrames.get(i).img;
      PImage backwardImage = backwardFrames.get(i).img;
      PImage morphedImage = createImage(frames.get(0).width, frames.get(0).height, RGB);
      
      for (int j = 0; j < frames.get(0).width; j++)
      {
        for (int k = 0; k < frames.get(0).height; k++)
        {
          int index = k * frames.get(0).width + j;
          
          float red1 = red(backwardImage.pixels[index]);
          float green1 = green(backwardImage.pixels[index]);
          float blue1 = blue(backwardImage.pixels[index]);
          
          float red2 = red(forwardImage.pixels[index]);
          float green2 = green(forwardImage.pixels[index]);
          float blue2 = blue(forwardImage.pixels[index]);
          
          float red = red1 * alpha + red2 * (1 - alpha);
          float green = green1 * alpha + green2 * (1 - alpha);
          float blue = blue1 * alpha + blue2 * (1 - alpha);
          
          morphedImage.pixels[index] = color(red, green, blue);
        }
      }
      frames.get(i).img = morphedImage;
    }
  }
  
  Frame getMorphedFrame(Frame sourceFrame, Frame destFrame)
  {
    /*
    Which pixel coordinate in the source image do we sample for each
    pixel in the destination image?
    
    Algorithm:
    ->For each destination image pixel,
    ->  For each line,
    ->    Compute the closest source image pixel
    ->    Set pixel in output frame to this pixel
    ->    Return output frame
    
    */
    Frame morphedFrame = new Frame("morphed", sourceFrame.width, sourceFrame.height);
    int w = sourceFrame.img.width;
    int h = sourceFrame.img.height;
    
    if (sourceFrame.lines.size() != destFrame.lines.size())
    {
      print("RETURNING EMPTY IMAGE");
      return morphedFrame;
    }
    if (sourceFrame.lines.size() == 0 || destFrame.lines.size() == 0)
    {
      print("RETURNING EMPTY IMAGE");
      return morphedFrame;
    }
      
    
    morphedFrame.img.loadPixels();
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        //Replace 1 by lines.size();
        Pixel DSUM = new Pixel(0, 0);
        float weightSum = 0;
        Pixel X = new Pixel(i, j);
        for (int k = 0; k < destFrame.lines.size(); k++)
        //for (int k = 0; k < 3; k++)
        {
          Line sourceLine = sourceFrame.lines.get(k);
          Line destLine = destFrame.lines.get(k);
          //morphedFrame.img.pixels[w * j + i] = color(255);
          
          Pixel P = destFrame.lines.get(k).A;
          Pixel Q = destFrame.lines.get(k).B;
          
          Pixel P1 = sourceFrame.lines.get(k).A;
          Pixel Q1 = sourceFrame.lines.get(k).B;
          
          float u = (X.sub(P)).dot(Q.sub(P)) / pow((Q.sub(P)).mod(), 2);
          float v = (X.sub(P)).dot(Q.sub(P).rot()) / Q.sub(P).mod();
          
          Pixel X1 = (P1.add((Q1.sub(P1)).mul(u))).add(((Q1.sub(P1)).rot()).mul(v / (Q1.sub(P1)).mod()));
          
          Pixel Di = X1.sub(X);
          float dist = abs(v);
          if (u < 0)
            dist = sqrt(pow(P.x - X.x, 2) + pow(P.y - X.y, 2));
          else if (u > 1)
            dist = sqrt(pow(Q.x - X.x, 2) + pow(Q.y - X.y, 2));
          
          float weight = pow(destLine.length, p) / pow((a + dist), b);
          DSUM = DSUM.add(Di.mul(weight));
          
          weightSum += weight;
        }
        
        Pixel X_sampled = X.add(DSUM.mul(1 / weightSum));
        int s = int(X_sampled.x);
        int t = int(X_sampled.y);
        if ((s > 0 && s < w) && (t > 0 && t < h))
          morphedFrame.img.pixels[w * j + i] = sourceFrame.img.pixels[w * t + s];
        else
        {
          //print("NOT PROCESSING! ");
        }
          
      }
    }
    morphedFrame.img.updatePixels();
    
    return morphedFrame;
  }
  
  void loadFrames()
  {
    File dir = new File(dataPath("Output"));
    String[] images = dir.list();
    
    for (int i = 0; i < images.length; i++)
    {
      String fileName = images[i];
      String formatExt = fileName.substring(fileName.length() - 3, fileName.length());
      if (formatExt.equals("tif") == true)
      {
        print("\nREADING FILE " + dir + "/" + fileName);
        frames.add(new Frame(dir + "/" + fileName, fileName, WIDTH, HEIGHT));
      }
    }
  }
  
  void saveFrames()
  {
    for (int i = 0; i < frames.size(); i++)
    {
      String name = frames.get(i).name;
      String path = "data/Output/" + name;
      frames.get(i).img.save(path);
    }
    print("\nSaved " + frames.size() + " frames to disk...");
  }
  
  void play()
  {
    if (playDirection == 1)
    {
      if (curPlayingFrameIndex < frames.size() - 1)
      {
        curPlayingFrameIndex += 1;
        curPlayingFrame = frames.get(curPlayingFrameIndex);
      }
      else
      {
        playDirection = -1;
      }
    }
    
    else if (playDirection == -1)
    {
      if (curPlayingFrameIndex > 1)
      {
        curPlayingFrameIndex -= 1;
        curPlayingFrame = frames.get(curPlayingFrameIndex);
      }
      else
      {
        playDirection = 1;
      }
    }
  }
  
}
