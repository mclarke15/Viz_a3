int displayHeight = 600;
Bar_chart barChart;
Line_chart lineChart;
Pie_chart pieChart;
BarLine barLine;
LineBar lineBar;
BarPie barPie; 
PieBar pieBar; 
String[] times;
float[] temps;
button bar;
button line;
button pie;
button suggestion;
String state;
String text1, text2;
float total = 0; 
String suggestionText = "";

int pointRadius = 2; //10
float numShrinks = 50; 
float numMovesBarShrinks = 50; 
float numBarMoves = 50;

/* color */
color buttonA = color(164, 176, 245);
color buttonB = color(164, 176, 245);
color buttonC = color(164, 176, 245);
color buttonD = color(222, 107, 72);
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
  
  size(800, 600);
  frameRate(10);
  String[] lines = loadStrings("data3.csv");
  String[] headers = split(lines[0],   ",");
  times = new String[lines.length - 1];
  temps = new float[lines.length - 1];
  for(int i = 1; i < lines.length; i++){
    String[] content = split(lines[i], ",");
    times[i-1] = content[0];
    temps[i-1] = float(content[1]);
    //println(times[i-1]);
    //println(temps[i-1]); 
  }
  
  barChart = new Bar_chart(headers[0], headers[1], times, temps); 
  lineChart = new Line_chart(headers[0], headers[1], times, temps); 
  pieChart = new Pie_chart(headers[0], headers[1], times, temps); 
  barLine = new BarLine(headers[0], headers[1], times, temps);
  lineBar = new LineBar(headers[0], headers[1], times, temps);
  barPie = new BarPie(headers[0], headers[1], times, temps);
  pieBar = new PieBar(headers[0], headers[1], times, temps); 
}

void draw() 
{
  bar = new button(buttonA, "bar", 40, 30, 20, 30, 12);
  line = new button(buttonB, "line", 40, 30, 70, 30, 12);
  pie = new button(buttonC, "pie", 40, 30, 120, 30, 12);
  suggestion = new button(buttonD, suggestionText, int(textWidth(suggestionText)), 30, 180 + int(textWidth(suggestionText))/2, 30, 12);
  
  if (state == "bar") {
    background(255);
    buttonA = color(0);
    buttonB = color(164, 176, 245);
    buttonC = color(164, 176, 245);
    barChart.render(mouseX, mouseY);
    bar.drawButton();
    line.drawButton();
    pie.drawButton();
    suggestionText = "  Try 'Line' for trends and 'Pie' for parts of a whole!  ";
    suggestion.drawButton();
  } else if (state == "line") {
    background(255);
    buttonA = color(164, 176, 245);
    buttonB = color(0);
    buttonC = color(0);
    lineChart.render(mouseX, mouseY);
    bar.drawButton();
    line.drawButton();
    pie.drawButton();
    suggestionText = "  Try 'Bar' to compare Y values!  ";
    suggestion.drawButton();
  } else if (state == "pie") {
    background(255);
    buttonA = color(164, 176, 245);
    buttonB = color(0);
    buttonC = color(0);
    line.drawButton();
    bar.drawButton();
    pie.drawButton();
    suggestionText = "  Try 'Bar' to compare Y values!  ";
    suggestion.drawButton();
    pieChart.render(width/2, height/2 , height*.4); 
  } else if (state == "barToLine") {
    barLine.render();
  } else if (state == "lineToBar") {
    lineBar.render();
  } else if (state == "barToPie") {
    //background(255);
    barPie.render(width/2, height/2 , height*.4);
  } else if (state == "pieToBar") {
    pieBar.render(width/2, height/2 , height*.4);
  }
 
}

void mouseClicked() {    

    if (mouseX > bar.X1 && mouseX < bar.X2 && mouseY > bar.Y1 && mouseY < bar.Y2) {
      if (state == "line") {
       state = "lineToBar";
      } else if (state == "pie") {
        state = "pieToBar";
      }
    }
    if (mouseX > pie.X1 && mouseX < pie.X2 && mouseY > pie.Y1 && mouseY < pie.Y2) {
      if (state == "bar") {
       state = "barToPie";
      } 
    }
    if (mouseX > line.X1 && mouseX < line.X2 && mouseY > line.Y1 && mouseY < line.Y2) {
      if (state == "bar") {
       state = "barToLine";
      } 
    }
  }