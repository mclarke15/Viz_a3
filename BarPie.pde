class BarPie {
  float numShrinks = 50; 
  int numMovesBarShrinks = 50; 
  int numBarMoves = 50; 
  float total = 0;
  ArrayList<DataPair> data = new ArrayList();
  int i = 0;
  float z = 0; 
  String xTitle, yTitle; 
  String[] names;
  float[] values;
  int yMin, yMax, xNum; 
  float padding = 0.15; 
  float barFill = 0.8; 
      
  class DataPair {
    String _name;
    float _val;
    DataPair(String name, float val) {
      _name = name;
      _val = val;
    } 
  }

  BarPie(String xTitle, String yTitle, String[] names, float[] values) {
      this.xTitle = xTitle;
      this.yTitle = yTitle;
      this.names = names;
      this.values = values;
      this.yMin = 0; // min(int(values));
      this.yMax = max(int(values)); 
      this.xNum = names.length; 
      
      for (int i = 0; i < names.length; i++) {
         DataPair newData = new DataPair(names[i], values[i]);
         data.add(newData);
         total += values[i]; 
      }
  }
  
  void render(float x, float y, float radius) {   
    if (z >= 0 && z < numMovesBarShrinks) {
       renderBars(x, y, radius); 
    } else if (z >= numMovesBarShrinks && z < numMovesBarShrinks + numBarMoves) {
       renderBarMove(x, y, radius); 
    } else if (z >= numMovesBarShrinks + numBarMoves && z < numShrinks + numBarMoves + numMovesBarShrinks) {
      renderDonutShrink(x, y, radius); 
    } else if (z == numShrinks + numBarMoves + numMovesBarShrinks){
      renderPie(x, y, radius); 
    } else {
      state = "pie"; 
      z = 0;
    }
    z++;
  }
  
  void renderBars(float x, float y, float radius) {
    fill(255); 
    rect(0, 0, width, height); 
    fill(0); 
 
   //spacing 
    float spacing = (width - 2*padding*width)/xNum; 
    float barWidth = barFill*spacing;
    float xStart = width*padding; 
    float yStart = height*(1-padding); 
    float ySpacing = (height - 2*padding*height) / (yMax - yMin);  
    float theta; 
    float endLen; 
    float deltaLen; 
    
    for (int i = 0; i < xNum; i++) {
        float xBar, yBar; 
        xBar = xStart + spacing * i; 
        yBar = yStart; 
        float barHeight = values[i]*ySpacing - yMin*ySpacing; 
        DataPair d = data.get(i);  
        theta = 2*PI * d._val / total;  
        endLen = radius * theta;   
        deltaLen = barHeight - endLen; 
        fill((chartR + (redInc*(i%div)))%255, (chartB + (blueInc*(i%div)))%255, (chartG + (greenInc*(i%div)))%255); 
        rect(xBar, yBar- barHeight, barWidth, barHeight - deltaLen * (z / numMovesBarShrinks));
    }
  }
  
  void renderBarMove(float x, float y, float radius) {
    fill(255); 
    rect(0, 0, width, height); 
    fill(0); 
 
   //spacing 
    float spacing = (width - 2*padding*width)/xNum; 
    float barWidth = barFill*spacing;
    float xStart = width*padding; 
    float yStart = height*(1-padding); 
    float ySpacing = (height - 2*padding*height) / (yMax - yMin);  
    float theta; 
    float endLen; 
    float deltaPosX;
    float deltaPosY; 
    float endPosX;
    float endPosY; 
    float startTheta = 0;
    
    for (int i = 0; i < xNum; i++) {
        float xBar, yBar; 
        xBar = xStart + spacing * i; 
        yBar = yStart; 
        float barHeight = values[i]*ySpacing - yMin*ySpacing; 
        DataPair d = data.get(i);  
        theta = 2*PI * d._val / total;  
        endPosX = x + cos(startTheta + theta) * radius;
        endPosY = y + sin(startTheta + theta) * radius;
        startTheta += theta; 
        println("endX " + endPosX);
        println("endY " + endPosY);
        deltaPosX = endPosX - xBar;
        deltaPosY = endPosY - yBar; 
        
        endLen = radius * theta;   
        fill((chartR + (redInc*(i%div)))%255, (chartB + (blueInc*(i%div)))%255, (chartG + (greenInc*(i%div)))%255); 
        
        float tempZ = z - numMovesBarShrinks;
        //println("tempZ " + tempZ); 
        //rect(xBar + deltaPosX * (tempZ / numBarMoves), 
        //      (yBar- barHeight) - deltaPosY * (tempZ / numBarMoves), barWidth, endLen);
        float topLX = xBar + deltaPosX * (tempZ / numBarMoves);
        float topLY = (yBar- barHeight) - deltaPosY * (tempZ / numBarMoves);
        float bottomLX = topLX;  
        float bottomLY = topLY + endLen;  
        beginShape();
          vertex(topLX, topLY);
          vertex(topLX + barWidth, topLY);
          vertex(bottomLX + barWidth, bottomLY);
          vertex(bottomLX, bottomLY);
         endShape(CLOSE);
              
       //rect(xBar + deltaPosX, (yBar- barHeight) - deltaPosY, barWidth, endLen);
     //   println("x " + xBar + deltaPosX * (tempZ / numBarMoves));
      //  println("y " + (yBar- barHeight) + deltaPosY * (tempZ / numBarMoves));
    } 
  }
  
  void renderDonutShrink(float x, float y, float radius) {
    float startTheta = 0;
    float theta;
    boolean inCircle = mouseDistance(x, y) <= radius;
    float mTheta = mouseTheta(x,y);
    float innerRadius = radius - (((z - numMovesBarShrinks - numBarMoves) /numShrinks) * radius); 

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

    ToolTip myTip = null; 
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
       // myTip.render(); 
      } 
      i++;
    }
    if (myTip != null) {
       myTip.render();  
    }
  }
}