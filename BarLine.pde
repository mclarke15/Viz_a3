class BarLine {
  String xTitle, yTitle; 
  String[] names;
  float[] values;
  int yMin, yMax, xNum; 
  float padding = 0.15; 
  int pointRadius = 5; 
  //float barFill = 0.8; 

  BarLine(String xTitle, String yTitle, String[] names, float[] values) {
    this.xTitle = xTitle;
    this.yTitle = yTitle;
    this.names = names;
    this.values = values;
    this.yMin = 0; // min(int(values));
    this.yMax = max(int(values)); 
    this.xNum = names.length; 
  }

  void render(float xPos, float yPos) {
    ToolTip t = null;
    fill(255); 
    rect(0, 0, width, height);  
    fill(0); 
    line(padding*width, (1 - padding)*height, (1 - padding)*width, (1 - padding)*height);
    pushStyle();
    textAlign(CENTER); 
    text(xTitle, ((1 - padding)*width - padding*width), (1 - padding/3)*height);
    popStyle(); 

    //spacing 
    float spacing = (width - 2*padding*width)/xNum; 
    //float barWidth = barFill*spacing;
    float xStart = width*padding; 
    float yStart = height*(1-padding); 
    float ySpacing = (height - 2*padding*height) / (yMax - yMin);  
    float x, y, x2, y2;
    float stepX, stepY;
    float barHeight, barHeight2; 
    
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
        text(" " + names[i], spacing, 0); //put text at new origin 
        popMatrix();
        /* end rotate text */
          
        if (xPos >= x && xPos <= x + pointRadius 
                      && yPos >= y - barHeight && yPos <= y) {
          fill(hoverC);
          ellipse(x, y - barHeight, pointRadius, pointRadius);
          fill(color(0, 0, 0));
          if (i != xNum - 1) {
            stepX = lerp(x, x2, i/10.0) + 10;
            stepY = lerp(y - barHeight, y2 - barHeight2, i/10.0);
            line(x, y - barHeight, stepX, stepY);
            x = stepX;
            y = stepY;
            
          }
          t = new ToolTip("(" + names[i] + ", " + values[i] + ")", xPos, yPos);
          //t.render();
        } else {
          fill(chartC); 
          ellipse(x, y - barHeight, pointRadius, pointRadius);
          if (i != xNum - 1) {
            line(x, y - barHeight, x2, y2 - barHeight2);
          }
        }
       
        //rect(x, y - barHeight, barWidth, barHeight);
        //text(barHeight / ySpacing, x, y - barHeight); 
        
    }
    if (t != null) {
      t.render();
    }
    
    int NUMTICKS = 10;
    float yInterval = yMax / NUMTICKS;
    //for (int i = yMin; i <= yMax + yInterval; i+=yInterval) {
    for (int i = yMin; i <= yMax; i+=yInterval) {
      pushStyle(); 
      textAlign(RIGHT); 
      fill(0); 
      text(i + " ", xStart, yStart - i*ySpacing); 
      popStyle(); 
    } 
    
    line(padding*width, padding*height, padding*width, (1 - padding)*height);  
    pushMatrix();
    translate(padding*width/2, (1 - padding)*height / 2); //change origin 
    rotate(PI/2); //rotate around new origin 
    fill(0);
    //textAlign(CENTER);
    text(yTitle, 0, 0); //put text at new origin 
    popMatrix();
  }
}