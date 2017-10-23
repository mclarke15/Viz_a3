class Bar_chart {
  String xTitle, yTitle; 
  String[] names;
  float[] values;
  int yMin, yMax, xNum; 
  float padding = 0.15; 
  float barFill = 0.8; 

  Bar_chart(String xTitle, String yTitle, String[] names, float[] values) {
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
          
        if (xPos >= x && xPos <= x + barWidth 
                      && yPos >= y - barHeight && yPos <= y) {
          fill(hoverC);
          rect(x, y - barHeight, barWidth, barHeight);
          fill(color(0, 0, 0));
          t = new ToolTip("(" + names[i] + ", " + values[i] + ")", xPos, yPos);
          //t.render();
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
    //translate(padding*width/2, (1 - padding)*height / 2); //change origin 
    rotate(PI/2); //rotate around new origin 
    fill(0);
    text(yTitle, 0, 0); //put text at new origin 
    popMatrix();
  }
}