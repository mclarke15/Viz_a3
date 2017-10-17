class button {
  int disWidth, disHeight;
  color Color;
  String Text;
  int textSize;
  int buttonW, buttonH;
  int X1, Y1, X2, Y2; // dimensions of button
  
  button(color C, String T, int bW, int bH, int X, int Y, int TextSize) {
    Color = C;
    Text = T;
    textSize = TextSize;
    buttonW = bW;
    buttonH = bH;
    X1 = X;
    Y1 = Y;
    X2 = buttonW + X1;
    Y2 = buttonH + Y1;
  }
  
  void drawButton() {
    stroke(0);
    fill(Color);
    rect(X1, Y1, buttonW, buttonH);
    fill(0);
    text(Text, X1 + buttonW/2, Y1 + buttonH/2);
    textAlign(CENTER);
    textSize(textSize);   
  }
 
}