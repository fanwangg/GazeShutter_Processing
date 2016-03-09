int dotSize = 24;
ArrayList points = new ArrayList() ;
color[] gradientColors = {color(255,0,0), color(255,255,0), color(0, 255, 0), color(0,255,255), color(0,0,255)};

class Heatmap {
  ArrayList points;
  int maximumClicked = -1;
  HMGradient grad = new HMGradient(gradientColors);
  
  Heatmap(ArrayList points) {
    this.points = points;

    calcMaximum();
  }
  
  void calcMaximum() {
    for(int i = 0; i < points.size(); i++ ) {
      int current = ((HMPoint) points.get(i)).clicks;
      if(maximumClicked < current) {
        maximumClicked = current;
      }
    }
    
    if(maximumClicked <= 0) { maximumClicked = 1; }
  }

  void click(int x, int y) {
    boolean handled = false;

    for(int i = 0; i < points.size(); i++) {
      HMPoint point = (HMPoint) points.get(i);
      if(point.x == x && point.y == y) { 
        point.click();
        handled = true;
        //println("Point found, handled.");
        break;
      }
    }

    if(!handled) {
      //println("Making point");
      HMPoint point = p(x,y,1);
      points.add(point); 
    }
    
    calcMaximum();
    
    
    // Info printout:
    int clicks = 0;
    for(int i = 0; i < points.size(); i++) {
      clicks += ((HMPoint)points.get(i)).clicks;
    }
    //println("Points: " + points.size() + ", Clicks: " + clicks);
  }
  
  void draw() {
    for(int i = 0; i < points.size(); i++) {
      HMPoint point = (HMPoint) points.get(i);
      //println("(" + point.x + "," + point.y + ") - Max Clicked: " + maximumClicked + ",  HMPoint clicks: " + point.clicks);
      
      float intensity = float(point.clicks) / float(maximumClicked);
      //println("Intensity: " + intensity);
      
      FuzzyDot f = new FuzzyDot(point.x,point.y,dotSize, 1);//intensity);
      f.draw();
    }
    
    //JS is currently too slow to render this properly...
    convertGrayscaleToColor();
  }
  
  void convertGrayscaleToColor() {
    loadPixels();
    for(int i = 0; i < pixels.length; i++) {
      color currentColor = pixels[i];
      //if(color(255) != currentColor) {
        float currentAlpha = red(currentColor); // Alpha not preserved, useless...
        pixels[i] = grad.gradientLerpColor(currentAlpha/255); // Take one channel and use as grayscale value

        // println("Color: " + hex(currentColor));
        // println("New Color: " + hex(pixels[i]));
      //}
    } 
    updatePixels();
  }
}


class HMGradient {
  color[] colors;
  HMGradient(color[] colors) {
    this.colors = colors; 
  }
  
  color gradientLerpColor(float degree) {
    int numColors = colors.length;
    float step = 255 / numColors;
    float degreeToStep = 255 * degree;
    for(int i = 0; i < numColors - 1; i++) {
      if(degreeToStep >= i*step && degreeToStep < (i+1)*step) {
        color from = colors[i];
        color to =   colors[i+1];
        float newDegree = (degreeToStep % step) / step;
        return lerpColor(from, to, newDegree);
      }
    }
    //lerpColor(colors[colors.length-2],colors[colors.length-1], 1); // Set actual degree
    return colors[colors.length-1];
  }
}

HMPoint p(int x, int y, int clicks) { return new HMPoint(x,y,clicks); }
class HMPoint {
  int x;
  int y; 
  int clicks;
  HMPoint(int x, int y, int clicks) {
    this.x = x;
    this.y = y;
    this.clicks = clicks;
  }

  void click() { clicks++; }
}

class FuzzyDot {
  int x;
  int y;
  int c;
  int diameter;
  float originalDotAlpha;
  float dotAlpha;
  int steps;
  int originalSteps;
  float intensity;

  FuzzyDot(int x, int y, int diameter, float intensity) {
    this.x = x; this.y = y; 
    if(diameter <= 2) { diameter = 2; }
    this.diameter = diameter;

    originalDotAlpha = 255 / (diameter/2);
    originalSteps = int(255 / originalDotAlpha);
    
    steps = originalSteps;
    dotAlpha = originalDotAlpha;
    
    setIntensity(intensity);
  }
  
  void draw() {
    fill(0,dotAlpha);
    for(int i = 0; i < steps; i++) {
      ellipse(x,y,diameter-2*i,diameter-2*i);
    }
  }
  
  void setIntensity(float intensity) {
    this.intensity = intensity;
    steps = int(originalSteps * intensity);
    dotAlpha = originalDotAlpha * intensity; // Rework whole draw() to make intensity less fragile
  }
}