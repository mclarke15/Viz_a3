class ToolTip {
  String text;
  float x;
  float y;
  float offset = 5; 
  
  ToolTip(String text, float x, float y) {
    this.text = " " + text + " ";
    this.x = x;
    this.y = y;
  }
  void render() {
    pushStyle();
     
    fill(255);
    rectMode(CORNER);
    rect(x, y - offset, textWidth(text), textAscent() + textDescent(), 5, 5, 5, 5);
    fill(0);
    textAlign(LEFT, TOP); 
    text(text, x, y - offset);
    popStyle();
  }
}