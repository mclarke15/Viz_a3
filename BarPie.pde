class BarPie {
  int numShrinks = 50; 
  float total = 0;
  ArrayList<DataPair> data = new ArrayList();
  int i = 0;
  float z = 0; 
      
  class DataPair {
    String _name;
    float _val;
    DataPair(String name, float val) {
      _name = name;
      _val = val;
    } 
  }

  BarPie(String xTitle, String yTitle, String[] names, float[] values) {
      for (int i = 0; i < names.length; i++) {
         DataPair newData = new DataPair(names[i], values[i]);
         data.add(newData);
         total += values[i]; 
      }
  }
  
  void render(float x, float y, float radius) {
    if (z >= 0 & z < numShrinks) {
      renderDonutShrink(x, y, radius); 
    } else if (z == numShrinks){
      renderPie(x, y, radius); 
    } else {
      state = "pie"; 
      z = 0;
    }
    z++;
  }
  
  void renderDonutShrink(float x, float y, float radius) {
    float startTheta = 0;
    float theta;
    boolean inCircle = mouseDistance(x, y) <= radius;
    float mTheta = mouseTheta(x,y);
    float innerRadius = radius - ((z/numShrinks) * radius); 

    ToolTip myTip; 
    boolean inSegment;
    String text;
    i = 0;
    for (DataPair d : data) {
      theta = 2*PI * d._val / total;
      inSegment = inCircle &&(mTheta < theta+startTheta) && (mTheta > startTheta);
      if (inSegment) {
        text = " (" + d._name + ", " + d._val + ") ";
        fill(hoverC);
      }
      else {
        fill((chartR + (redInc*(i%div)))%255, (chartB + (blueInc*(i%div)))%255, (chartG + (greenInc*(i%div)))%255);
        text = ""; 
      }
      arc(x, y, radius * 2, radius * 2, startTheta, theta + startTheta, PIE);    
      startTheta += theta;
      if (inSegment) {
        myTip = new ToolTip(text, mouseX, mouseY);
        myTip.render(); 
      } 
      i++;
    }
    pushStyle();
    fill(255); 
    ellipse(x, y, innerRadius * 2, innerRadius * 2);
    popStyle();
  }
  
  float mouseDistance(float x, float y) {
    return sqrt(pow(x - mouseX, 2) + pow(y - mouseY, 2));
  }
  
  float mouseTheta(float x, float y) {
    float mTheta = atan((mouseY - y)/(mouseX - x));
    if (mouseX > x) { // Right side
       if (mouseY > y) // Lower Right
         return mTheta;
       if (mouseY <= y) 
        return mTheta + 2*PI;
    }
    else { // left side
      if (mouseY > y) // Bottom Left
        return mTheta + PI;
      else // Upper left
        return mTheta + PI;
    }
     return 0; 
  }
 
 void renderPie(float x, float y, float radius) {
    float startTheta = 0;
    float theta;
    boolean inCircle = mouseDistance(x, y) <= radius;
    float mTheta = mouseTheta(x,y);

    ToolTip myTip; 
    boolean inSegment;
    String text;
    i = 0;
    for (DataPair d : data) {
      theta = 2*PI * d._val / total;
      inSegment = inCircle &&(mTheta < theta+startTheta) && (mTheta > startTheta);
      if (inSegment) {
        text = " (" + d._name + ", " + d._val + ") ";
        fill(hoverC);
      }
      else {
        fill((chartR + (redInc*(i%div)))%255, (chartB + (blueInc*(i%div)))%255, (chartG + (greenInc*(i%div)))%255);
        text = ""; 
      }
      arc(x, y, radius * 2, radius * 2, startTheta, theta + startTheta, PIE);    
      startTheta += theta;
      if (inSegment) {
        myTip = new ToolTip(text, mouseX, mouseY);
        myTip.render(); 
      } 
      i++;
    }
  }
}