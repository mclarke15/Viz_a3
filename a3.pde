int displayHeight = 600;
Bar_chart barChart;
Line_chart lineChart;
Pie_chart pieChart;
BarLine barLine;
LineBar lineBar;
BarPie barPie; 
String[] times;
float[] temps;
button barline;
button barpie;
String state;
String text1, text2;
float total = 0;
int pointRadius = 10; 

/* color */
color buttonC = color(164, 176, 245);
int chartR = 68; //68
int chartB = 100; //100 
int chartG = 173; //173
int redInc = 5; //5
int blueInc = 5; //9
int greenInc = 3; //3
int div = 24; //24
color chartC = color(chartR, chartB, chartG);
color hoverC = color(222, 107, 72);

void setup()
{ 
  state = "bar";
  text1 = "line";
  text2 = "pie";
  barline = new button(buttonC, text1, 40, 30, 20, 30, 12);
  barpie = new button(buttonC, text2, 75, 30, 20, 30, 12);
  
  size(800, 600);
  frameRate(15);
  String[] lines = loadStrings("data.csv");
  times = new String[lines.length - 1];
  temps = new float[lines.length - 1];
  for(int i = 1; i < lines.length; i++){
    String[] content = split(lines[i], ",");
    times[i-1] = content[0];
    temps[i-1] = float(content[1]);
    //println(times[i-1]);
    //println(temps[i-1]); 
  }
  
  barChart = new Bar_chart("", "", times, temps); 
  lineChart = new Line_chart("", "", times, temps); 
  pieChart = new Pie_chart("", "", times, temps); 
  barLine = new BarLine("", "", times, temps);
  lineBar = new LineBar("", "", times, temps);
  barPie = new BarPie("", "", times, temps);
}

void draw() 
{
  barpie = new button(buttonC, text2, 40, 30, 65, 30, 12);
  barline = new button(buttonC, text1, 40, 30, 20, 30, 12);
  
  if (state == "bar") {
    background(255);
    barChart.render(mouseX, mouseY);
    barline.drawButton();
    barpie.drawButton();
  } else if (state == "line") {
    background(255);
    lineChart.render(mouseX, mouseY);
    barline.drawButton();
  } else if (state == "pie") {
    //background(255);
    barpie.drawButton();
    pieChart.render(width/2, height/2 , height*.4); 
  } else if (state == "barToLine") {
    barLine.render();
    barline.drawButton();
  } else if (state == "lineToBar") {
    lineBar.render();
    barline.drawButton();
  } else if (state == "barToPie") {
    background(255);
    barPie.render(width/2, height/2 , height*.4);
    barpie.drawButton();
  }
 
}

void mouseClicked() {    
    if (mouseX > barline.X1 && mouseX < barline.X2 && mouseY > barline.Y1 && mouseY < barline.Y2) {
      if (state == "bar") {
       text1 = "bar";
       state = "barToLine";
      } else if (state == "line") {
       text1 = "line"; 
       state = "lineToBar";
      } 
    }
    if (mouseX > barpie.X1 && mouseX < barpie.X2 && mouseY > barpie.Y1 && mouseY < barpie.Y2) {
      if (state == "pie") {
       text2 = "pie"; 
       state = "bar";
      } else if (state == "bar") {
       text2 = "bar"; 
       state = "barToPie";
      } 
    }
  }