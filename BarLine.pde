class BarLine {
  String xTitle, yTitle; 
  String[] names;
  float[] values;
  int yMin, yMax, xNum; 
  float padding = 0.15; 
  float barFill = 0.8; 
  float z = 0;
  int numShrinks = 20;
  int j;  

  BarLine(String xTitle, String yTitle, String[] names, float[] values) {
    this.xTitle = xTitle;
    this.yTitle = yTitle;
    this.names = names;
    this.values = values;
    this.yMin = 0; // min(int(values));
    this.yMax = max(int(values)); 
    this.xNum = names.length; 
  }
  
  void render() {    
    if (z == 0) {
     renderBar(); 
    } else if (z > 0 && z < numShrinks) {
      renderBarShrink();
    } else if (z >= numShrinks && z < (numShrinks + xNum)) {
      renderPoints();
      renderLine();
    } else {
      state = "line";
      z = 0;
    }
    z++;
  }

  void renderBar() {
    ToolTip t = null;
    fill(255); 
    rect(0, 0, width, height); 
    fill(0); 
    line(padding*width, (1 - padding)*height, (1 - padding)*width, (1 - padding)*height);
    pushStyle();
    textAlign(CENTER); 
    text(xTitle, width/2, (1 - padding/3)*height);
    popStyle(); 

    //spacing 
    float spacing = (width - 2*padding*width)/xNum; 
    float barWidth = barFill*spacing;
    float xStart = width*padding; 
    float yStart = height*(1-padding); 
    float ySpacing = (height - 2*padding*height) / (yMax - yMin);  
   
    for (int i = 0; i < xNum; i++) {
        float x, y; 
        x = xStart + spacing * i; 
        y = yStart; 
        float barHeight = values[i]*ySpacing - yMin*ySpacing; 
        
        /* try rotating text */
        pushMatrix();
        translate(x, y); //change origin 
        rotate(PI/2); //rotate around new origin 
        fill(0);
        //text(" " + names[i], spacing, 0); //put text at new origin 
        popMatrix();
        /* end rotate text */
          
        if (mouseX >= x && mouseX <= x + barWidth 
                      && mouseY >= y - barHeight && mouseY <= y) {
          fill(hoverC);
          rect(x, y - barHeight, barWidth, barHeight);
          fill(color(0, 0, 0));
          t = new ToolTip("(" + names[i] + ", " + values[i] + ")", mouseX, mouseY);
        } else {
          fill(chartC); 
          rect(x, y - barHeight, barWidth, barHeight);
        }
        
    }
    if (t != null) {
      t.render();
    }
    
    int NUMTICKS = 10;
    float yInterval = yMax / NUMTICKS;
    for (int i = yMin; i <= yMax; i+=yInterval) {
      pushStyle(); 
      textAlign(RIGHT); 
      fill(0); 
      text(i + " ", xStart, yStart - i*ySpacing); 
      popStyle(); 
    } 
    
    line(padding*width, padding*height, padding*width, (1 - padding)*height);  
    pushMatrix();
    translate(padding*width/2, height / 2); //change origin 
    rotate(PI/2); //rotate around new origin 
    fill(0);
    text(yTitle, 0, 0); //put text at new origin 
    popMatrix();
  }
  
  void renderBarShrink() {
    ToolTip t = null;
    fill(255); 
    rect(0, 0, width, height); 
    fill(0); 
    line(padding*width, (1 - padding)*height, (1 - padding)*width, (1 - padding)*height);
    pushStyle();
    textAlign(CENTER); 
    text(xTitle, width/2, (1 - padding/3)*height);
    popStyle(); 

    //spacing 
    float spacing = (width - 2*padding*width)/xNum; 
    float barWidth = barFill*spacing;
    float xStart = width*padding; 
    float yStart = height*(1-padding); 
    float ySpacing = (height - 2*padding*height) / (yMax - yMin);  
   
    for (int i = 0; i < xNum; i++) {
        float x, y; 
        x = xStart + spacing * i; 
        y = yStart; 
        float barHeight = (values[i]*ySpacing - yMin*ySpacing); 
        
        /* try rotating text */
        pushMatrix();
        translate(x, y); //change origin 
        rotate(PI/2); //rotate around new origin 
        fill(0);
        //text(" " + names[i], spacing, 0); //put text at new origin 
        popMatrix();
        /* end rotate text */
          
        if (mouseX >= x && mouseX <= x + barWidth 
                      && mouseY >= y - barHeight && mouseY <= y) {
          fill(hoverC);
          rect(x, y - barHeight, (barWidth) - (1 - (z/numShrinks)*(2 * pointRadius - barWidth)), barHeight*(1 - (z/numShrinks)));
          fill(color(0, 0, 0));
          t = new ToolTip("(" + names[i] + ", " + values[i] + ")", mouseX, mouseY);
        } else {
          fill(chartC); 
          rect(x, y - barHeight, (barWidth) - (1 - (z/numShrinks)*(2 * pointRadius - barWidth)), barHeight* (1 - (z/numShrinks)));
        }
        
    }
    if (t != null) {
      t.render();
    }
    
    int NUMTICKS = 10;
    float yInterval = yMax / NUMTICKS;
    for (int i = yMin; i <= yMax; i+=yInterval) {
      pushStyle(); 
      textAlign(RIGHT); 
      fill(0); 
      text(i + " ", xStart, yStart - i*ySpacing); 
      popStyle(); 
    } 
    
    line(padding*width, padding*height, padding*width, (1 - padding)*height);  
    pushMatrix();
    translate(padding*width/2, height / 2); //change origin 
    rotate(PI/2); //rotate around new origin 
    fill(0);
    text(yTitle, 0, 0); //put text at new origin 
    popMatrix();
  
  }
  
  void renderLine() {
    float spacing = (width - 2*padding*width)/xNum; 
    float xStart = width*padding; 
    float yStart = height*(1-padding); 
    float ySpacing = (height - 2*padding*height) / (yMax - yMin);  
    float x, y, x2, y2;
    float barHeight, barHeight2;
    j = int(z) - numShrinks;
      x = xStart + spacing * j; 
      y = yStart; 
      barHeight = values[j]*ySpacing - yMin*ySpacing; 
      
      if (j != xNum - 1) {
          x2 = xStart + spacing * (j + 1); 
          y2 = yStart; 
          barHeight2 = values[j+1]*ySpacing - yMin*ySpacing; 
       } else {
          x2 = 0;
          y2 = 0; 
          barHeight2 = 0; 
       }
        
      if (j != xNum - 1) {
            line(x, y - barHeight, x2, y2 - barHeight2);
            x = x2;
            y = y2; 
          } 
      for (int k = 0; k < j; k++) {
          if (k > xNum - 1) {
             k = xNum - 1;
          } else {
            x = xStart + spacing * k; 
            y = yStart; 
            barHeight = values[k]*ySpacing - yMin*ySpacing; 
      
            if (k != xNum - 1) {
              x2 = xStart + spacing * (k + 1); 
              y2 = yStart; 
              barHeight2 = values[k+1]*ySpacing - yMin*ySpacing; 
            } else {
              x2 = 0;
              y2 = 0; 
              barHeight2 = 0; 
           }
        
          if (k != xNum - 1) {
            line(x, y - barHeight, x2, y2 - barHeight2);
            x = x2;
            y = y2; 
          } 
      }
    }
    }
    
   void renderPoints() {
    ToolTip t = null;
    fill(255); 
    rect(0, 0, width, height);  
    fill(0); 
    line(padding*width, (1 - padding)*height, (1 - padding)*width, (1 - padding)*height);
    pushStyle();
    textAlign(CENTER); 
    text(xTitle, width/2, (1 - padding/3)*height);
    popStyle(); 

    //spacing 
    float spacing = (width - 2*padding*width)/xNum; 
    float xStart = width*padding; 
    float yStart = height*(1-padding); 
    float ySpacing = (height - 2*padding*height) / (yMax - yMin);  
    float x, y;
    float barHeight;
    int NUMTICKS = 10;
    float yInterval = yMax / NUMTICKS;
    for (int i = yMin; i <= yMax; i+=yInterval) {
      pushStyle(); 
      textAlign(RIGHT); 
      fill(0); 
      text(i + " ", xStart, yStart - i*ySpacing); 
      popStyle(); 
    } 
    
    line(padding*width, padding*height, padding*width, (1 - padding)*height);  
    pushMatrix();
    translate(padding*width/2, height / 2); //change origin 
    rotate(PI/2); //rotate around new origin 
    fill(0);
    text(yTitle, 0, 0); //put text at new origin 
    popMatrix();
   
   
    for (int i = 0; i < xNum; i++) {
        x = xStart + spacing * i; 
        y = yStart; 
        barHeight = values[i]*ySpacing - yMin*ySpacing; 
        
        /* try rotating text */
        pushMatrix();
        translate(x, y); //change origin 
        rotate(PI/2); //rotate around new origin 
        fill(0);
        //text(" " + names[i], spacing, 0); //put text at new origin 
        popMatrix();
        /* end rotate text */
          
        if (mouseX >= x - pointRadius && mouseX <= x + pointRadius 
                      && mouseY >= y - barHeight - pointRadius && mouseY <= y - barHeight + pointRadius) {
          fill(hoverC);
          ellipse(x, y - barHeight, pointRadius, pointRadius);
          fill(color(0, 0, 0));
          t = new ToolTip("(" + names[i] + ", " + values[i] + ")", mouseX, mouseY);
        } else {
          fill(chartC); 
          ellipse(x, y - barHeight, pointRadius, pointRadius);
        }
    }
    if (t != null) {
      t.render();
    }
  }
}