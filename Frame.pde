class Frame
{
  String imgPath;
  String name;
  int width, height;
  PImage img;
  ArrayList<Pixel> featurePoints;
  ArrayList<Line> lines;
  //int selectedFeaturePointIndex;
  
  Frame(String p, String n, int w, int h)
  {
    imgPath = p;
    name = n;
    width = w;
    height = h;
    img = loadImage(p);
    img.resize(w, h); 
    featurePoints = new ArrayList<Pixel>();
    lines = new ArrayList<Line>();
    //selectedFeaturePointIndex = -1;
  }
  
  Frame(String n, int w, int h)
  {
    name = n;
    width = w;
    height = h;
    img = createImage(w, h, RGB);
    featurePoints = new ArrayList<Pixel>();
    lines = new ArrayList<Line>();
    //selectedFeaturePointIndex = -1;
  }
  
  void show()
  {
    image(img, 0, 0);
  }
  
  void showLines()
  {
    for (int i = 0; i < lines.size(); i++)
    {
      lines.get(i).show(i);
    }
  }
  
  void _addLine(Pixel p1, Pixel p2)
  {
    lines.add(new Line(p1, p2));
  }
  
  void _deleteFeaturePoint(int index)
  {
    featurePoints.remove(index);
  }
  
  void _clearFeaturePoints()
  {
    featurePoints = new ArrayList<Pixel>();
  }
  
  void loadFeatures()
  {
    String fileName = name + ".txt";
    String[] coordArray = loadStrings(fileName);
    Pixel[] pixelArray = new Pixel[coordArray.length / 2];
    
    for (int i = 0; i < coordArray.length; i+=2)
    {
      pixelArray[i / 2] = new Pixel(-1, -1);
      pixelArray[i / 2].x = Integer.parseInt(coordArray[i]);
      pixelArray[i / 2].y = Integer.parseInt(coordArray[i + 1]);
    }
    
    Line[] lineArray = new Line[pixelArray.length / 2];
    for (int i = 0; i < pixelArray.length; i+=2)
    {
      lineArray[i / 2] = new Line(pixelArray[i], pixelArray[i + 1]);
    }
    
    lines = new ArrayList<Line>();
    for (int i = 0; i < lineArray.length; i++)
    {
      lines.add(lineArray[i]);
    }
    
    print("\nLoaded from file: " + fileName);
  }
  
  void saveFeatures()
  {
    String fileName = name + ".txt";
    Line[] lineArray = new Line[lines.size()];
    for (int i = 0; i < lineArray.length; i++)
    {
      lineArray[i] = lines.get(i);
    }
    
    Pixel[] pixelArray = new Pixel[2 * lineArray.length];
    for (int i = 0; i < pixelArray.length; i++)
    {
      if (i % 2 == 0)
        pixelArray[i] = lineArray[i / 2].A;
      else
        pixelArray[i] = lineArray[i / 2].B; 
    }
    
    String[] coordArray = new String[2 * pixelArray.length];
    for (int i = 0; i < coordArray.length; i++)
    {
      if (i % 2 == 0)
        coordArray[i] = str(int(pixelArray[i / 2].x));
      else
        coordArray[i] = str(int(pixelArray[i / 2].y));
    }
    saveStrings(fileName, coordArray);
    print("\nWrote to file: " + fileName);
  }
}

class Line
{
  Pixel A, B;
  float length;
  Line(Pixel p1, Pixel p2)
  {
    A = p1;
    B = p2;
    length = sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
  }
  
  void show()
  {
    stroke(red);
    strokeWeight(2);
    line(A.x, A.y, B.x, B.y);
    
    strokeWeight(5);
    point(B.x, B.y);
  }
  
  void show(int index)
  {
    stroke(red);
    strokeWeight(2);
    line(A.x, A.y, B.x, B.y);
    
    strokeWeight(5);
    point(B.x, B.y);
    
    noStroke();
    fill(yellow);
    float x = (A.x + B.x) / 2;
    float y = (A.y + B.y) / 2;
    text(index, x, y);
  }
}
