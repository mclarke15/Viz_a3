class PieBar { 
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
  float topXs[]; 
  float topYs[]; 
  float botXs[];  
  float botYs[]; 
      
  class DataPair {
    String _name;
    float _val;
    DataPair(String name, float val) {
      _name = name;
      _val = val;
    } 
  }

  PieBar(String xTitle, String yTitle, String[] names, float[] values) {
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
      topXs = new float[xNum]; 
      topYs = new float[xNum]; 
      botXs = new float[xNum]; 
      botYs = new float[xNum]; 
  }
  
  void render(float x, float y, float radius) {
    if (z == 0) {
     background(255); 
    } 
    if (z >= 0 && z < numShrinks) {
       renderPie(x, y, radius);
       renderDonutGrow(x, y, radius); 
    } else if (z >= numShrinks && z < numShrinks + numBarMoves) {
       renderBarMove(x, y, radius); 
    } else if (z >= numShrinks + numBarMoves && z < numShrinks + numBarMoves + numMovesBarShrinks) {
        renderBars(x, y, radius); 
    } else {
       state = "bar";
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
    
    float tempZ = z - numShrinks - numBarMoves; 
    
    for (int i = 0; i < xNum; i++) {
        float xBar, yBar; 
        xBar = xStart + spacing * i; 
        yBar = yStart; 
        float barHeight = values[i]*ySpacing - yMin*ySpacing; 
        DataPair d = data.get(i);  
        theta = 2*PI * d._val / total;
        endLen = radius * theta;    
        deltaLen = barHeight - endLen; 
        fill(chartR + redInc, chartB + blueInc, chartG + greenInc);  
        rect(xBar, yBar- barHeight, barWidth, barHeight - deltaLen * (1 - tempZ / numMovesBarShrinks));
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
    float nextTheta; 
    float endLen; 
    float deltaPosX;
    float deltaPosY; 
    float endPosX;
    float endPosY; 
    float ndeltaPosX;
    float ndeltaPosY; 
    float nendPosX;
    float nendPosY; 
    float startTheta = 0;
        
    for (int i = 0; i < xNum; i++) {
        float xBar, yBar; 
        xBar = xStart + spacing * i; 
        yBar = yStart; 
        float barHeight = values[i]*ySpacing - yMin*ySpacing; 
        
        DataPair d = data.get(i);  
        DataPair nextD = data.get( (i + 1) % xNum);
        
        theta = 2*PI * d._val / total;  
        nextTheta = 2*PI * nextD._val / total;
        
        endPosX = x + cos(startTheta + theta) * radius;
        endPosY = y + sin(startTheta + theta) * radius;
        startTheta += theta; 
        nendPosX = x + cos(startTheta + nextTheta) * radius;
        nendPosY = y + sin(startTheta + nextTheta) * radius;
        
        topXs[i] = nendPosX;
        topYs[i] = nendPosY;
        botXs[i] = endPosX;  
        botYs[i] = endPosY;
        
        deltaPosX = endPosX - xBar;
        deltaPosY = endPosY - yBar; 
     
        endLen = radius * theta;      
        fill(chartR + redInc, chartB + blueInc, chartG + greenInc);  
        
        float tempZ = z - numShrinks;
        float endBarMove = numBarMoves * 0.66; 

        if (tempZ < endBarMove) {
          float topLX = topXs[i];
          float topLY = topYs[i];
          
          float deltaX = topLX - botXs[i];
          float deltaY = topLY + endLen - botYs[i]; 
          
          float bottomLX = botXs[i] + (tempZ / endBarMove) * deltaX;
          float bottomLY = botYs[i] +  (tempZ / endBarMove) * deltaY;
          
          beginShape();
            vertex(topLX, topLY);
            vertex(topLX + barWidth, topLY);
            vertex(bottomLX + barWidth, bottomLY);
            vertex(bottomLX, bottomLY);
           endShape(CLOSE);
        } else {
          tempZ = tempZ - endBarMove + 1; 
          //println(tempZ); 
          
          float deltaX = xBar - topXs[i]; 
          float deltaY = yBar- barHeight - topYs[i]; 
          
          float topLX = topXs[i] + (tempZ / (numBarMoves - endBarMove)) * deltaX;
          float topLY = topYs[i] + (tempZ / (numBarMoves - endBarMove)) * deltaY;
          
          beginShape();
            vertex(topLX, topLY);
            vertex(topLX + barWidth, topLY);
            vertex(topLX + barWidth, topLY + endLen);
            vertex(topLX, topLY + endLen);
           endShape(CLOSE);
        }
    } 
  }
  
  void renderDonutGrow(float x, float y, float radius) {
    float spacing = (width - 2*padding*width)/xNum; 
    float barWidth = barFill*spacing;
    float startTheta = 0;
    float theta;
    boolean inCircle = mouseDistance(x, y) <= radius;
    float mTheta = mouseTheta(x,y);
    float innerRadius = (radius - barWidth) - ( (1 - z/numShrinks) * (radius - barWidth)); 

    ToolTip myTip; 
    boolean inSegment;
    String text;
    i = 0;
    for (DataPair d : data) {
      theta = 2*PI * d._val / total;
      inSegment = inCircle &&(mTheta < theta+startTheta) && (mTheta > startTheta);
      if (inSegment) {
        String percentage = String.format("%.1f", (d._val/total) * 100);
        text = percentage + "% (" + d._name + ", " + d._val + ") ";
        fill(hoverC);
      }
      else {
        fill(chartR + redInc, chartB + blueInc, chartG + greenInc); 
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
        String percentage = String.format("%.1f", (d._val/total) * 100);
        text = percentage + "% (" + d._name + ", " + d._val + ") ";
        fill(hoverC);
      }
      else {
        fill(chartR + redInc, chartB + blueInc, chartG + greenInc); 
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