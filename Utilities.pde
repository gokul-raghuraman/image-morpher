//Colors
color black=#000000, white=#FFFFFF, red=#FF0000, green_true=#00FF01, green=#31CB94, blue=#75C4F7, blue_true=#0300FF, 
      yellow=#FEFF00, cyan=#00FDFF, magenta=#FF00FB, grey=#5F5F5F, grey_dark = #292626, grey_light = #DBD9D9;

//A simple Pixel class
class Pixel
{
  float x, y;
  
  Pixel(float xLoc, float yLoc)
  {
    x = xLoc;
    y = yLoc;
  }
  
  Pixel(int xLoc, int yLoc)
  {
    x = float(xLoc);
    y = float(yLoc);
  }
  
  Pixel sub(Pixel p)
  {
    return new Pixel(x - p.x, y - p.y);
  }
  
  Pixel add(Pixel p)
  {
    return new Pixel(x + p.x, y + p.y);
  }
  
  Pixel mul(float u)
  {
    return new Pixel(u * x, u * y);
  }
  
  Pixel rot()
  {
    return new Pixel(-y, x);
  }
  
  float dot(Pixel p)
  {
    return x * p.x + y * p.y;
  }
  
  float mod()
  {
    return sqrt(pow(x, 2) + pow(y, 2));
  }
  
  
  
}

