class LineBar {
  String xTitle, yTitle; 
  String[] names;
  float[] values;
  int yMin, yMax, xNum; 
  float padding = 0.15; 
  float barFill = 0.8; 
  int numShrinks = 20;
  float z;
  int j;  

  LineBar(String xTitle, String yTitle, String[] names, float[] values) {
    this.xTitle = xTitle;
    this.yTitle = yTitle;
    this.names = names;
    this.values = values;
    this.yMin = 0; // min(int(values));
    this.yMax = max(int(values)); 
    this.xNum = names.length; 
    this.z = numShrinks + xNum;
  }
  
  void render() {    
    if (z == numShrinks + xNum) {
      renderLine();
    } else if (z < numShrinks + xNum && z >= numShrinks) {
        renderPoints(); 
        undrawLine();     
    } else if (z < numShrinks && z >= 0) {
      renderBarGrow();
    } else {
      state = "bar";
      z = numShrinks + xNum;
    }
    z--;
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
  
  void renderBarGrow() {
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
          rect(x, y - barHeight, (barWidth) + ((z/numShrinks)*(2 * pointRadius - barWidth)), barHeight*(1 -(z/numShrinks)));
          fill(color(0, 0, 0));
          t = new ToolTip("(" + names[i] + ", " + values[i] + ")", mouseX, mouseY);
        } else {
          fill(chartC); 
          rect(x, y - barHeight, (barWidth) + ((z/numShrinks)*(2 * pointRadius - barWidth)), barHeight* (1 - (z/numShrinks)));
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
  
  void undrawLine() {
    float spacing = (width - 2*padding*width)/xNum; 
    float xStart = width*padding; 
    float yStart = height*(1-padding); 
    float ySpacing = (height - 2*padding*height) / (yMax - yMin);  
    float x, y, x2, y2;
    float barHeight, barHeight2;
    j = int(z) - numShrinks;
     
    for (int m = 0; m < j; m++) {
      x = xStart + spacing * m; 
      y = yStart; 
      barHeight = values[m]*ySpacing - yMin*ySpacing;
      
      if (m != xNum - 1) {
          x2 = xStart + spacing * (m + 1); 
          y2 = yStart; 
          barHeight2 = values[m+1]*ySpacing - yMin*ySpacing; 
       } else {
          x2 = 0;
          y2 = 0; 
          barHeight2 = 0; 
       }
       
       if (m != xNum - 1) {
            line(x, y - barHeight, x2, y2 - barHeight2);
            x = x2;
            y = y2; 
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
  
  void renderLine() {
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
    float x, y, x2, y2; 
    float barHeight, barHeight2; 
   
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
    //textAlign(CENTER);
    text(yTitle, 0, 0); //put text at new origin 
    popMatrix();
   
   
    for (int i = 0; i < xNum; i++) {
        x = xStart + spacing * i; 
        y = yStart; 
        barHeight = values[i]*ySpacing - yMin*ySpacing; 
        
        if (i != xNum - 1) {
          x2 = xStart + spacing * (i + 1); 
          y2 = yStart; 
          barHeight2 = values[i+1]*ySpacing - yMin*ySpacing; 
        } else {
          x2 = 0;
          y2 = 0; 
          barHeight2 = 0; 
        }
        
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
          if (i != xNum - 1) {
            line(x, y - barHeight, x2, y2 - barHeight2);
          }
          fill(hoverC);
          ellipse(x, y - barHeight, pointRadius, pointRadius);
          fill(color(0, 0, 0));
          t = new ToolTip("(" + names[i] + ", " + values[i] + ")", mouseX, mouseY);
        } else {
          if (i != xNum - 1) {
            line(x, y - barHeight, x2, y2 - barHeight2);
          }
          fill(chartC); 
          ellipse(x, y - barHeight, pointRadius, pointRadius);
        }
    }
    if (t != null) {
      t.render();
    }
  }
}