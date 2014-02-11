import processing.net.*;
import omicronAPI.*;

import javax.swing.*;
import java.awt.*;

OmicronAPI omicronManager;
TouchListener touchListener;

// Link to this Processing applet - used for touchDown() callback example
PApplet applet;

// Override of PApplet init() which is called before setup()
public void init() {
  super.init();

  // Creates the OmicronAPI object. This is placed in init() since we want to use fullscreen
  omicronManager = new OmicronAPI(this);

  // Removes the title bar for full screen mode (present mode will not work on Cyber-commons wall)
  omicronManager.setFullscreen(true);
}


// map variables-----------------------------------------------------
float sizeMapHeight = 1;
float sizeMapWidth = 1;
int countryCount;
public String countryName;
private PShape worldMap, country;
ProcessTable countries;
ManageMap manageMap;
ArrayList<Country> countryList;

//------------------------------------------------------------------

HScrollbar hs1, hs2;
ProcessTable data, data2, temp;

float dataMin, dataMax;

int rowCount, columnCount;
int currentRow;
int worldRow;
int colStart, colEnd;
int yearEnd, yearStart;
int[] colors = {  #A13423, #12BC45, #3443D2, #563912, #7898B0, #A1B345, #CA1AEF, #988912, #10A2DE, #309010, #BACEDF, #FFEDFF, #123451, #9823A0, #001272, #EF00C1, #098789, #FFFFF1, #B7C2D2, #239010, #A2B3CE};

//char[][] keyboardLayout = new char[10][3];

char keyboardLayout[][] = {{'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'}, {'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', '0'}, {'Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '0'}};

int yearMin, yearMax;
int[] years;

int yearInterval = 5;
float unitInterval;
float unitIntervalMinor;



int scaleFactor = 12;
// 12 for cyber-commons 
// 2 for laptop screen 1360 * 384

// Info Display Window 
float idPlotX1, idPlotX2;
float idPlotY1, idPlotY2;
float idWidth, idHeight;

// control panel plot cordinates
float cpPlotX1, cpPlotX2;
float cpPlotY1, cpPlotY2;
float cpWidth, cpHeight;

// Graphical window plot cordinates
float gwPlotX1, gwPlotX2;
float gwPlotY1, gwPlotY2;
float gwWidth, gwHeight;

// Tabular window plot cordinates
float twPlotX1, twPlotX2;
float twPlotY1, twPlotY2;
float twWidth, twHeight;

// button 1 -> energy production cordiantes
float epButtonX1, epButtonX2;
float epButtonY1, epButtonY2;
float epWidth, epHeight;

// button 2 -> energy consumption cordiantes
float ecButtonX1, ecButtonX2;
float ecButtonY1, ecButtonY2;
float ecWidth, ecHeight;

// button 3 -> CO2emissions cordiantes
float co2ButtonX1, co2ButtonX2;
float co2ButtonY1, co2ButtonY2;
float co2Width, co2Height;

// button 4 -> renewable electricity generation cordiantes
float regButtonX1, regButtonX2;
float regButtonY1, regButtonY2;
float regHeight, regWidth;


// Graphics window Graph cordinates
float gwGraphX1, gwGraphX2;
float gwGraphY1, gwGraphY2;

// Total button cordiantes
float totalButtonX1, totalButtonX2;
float totalButtonY1, totalButtonY2;

// Per Capita Button cordinates
float perCapitaButtonX1, perCapitaButtonX2;
float perCapitaButtonY1, perCapitaButtonY2;

// Text Box cordinates
float textBoxX1, textBoxX2;
float textBoxY1, textBoxY2;

// text area back button cordinates
float backButtonX1, backButtonX2;
float backButtonY1, backButtonY2;

// textField cordinates
float textFieldX1, textFieldX2;
float textFieldY1, textFieldY2;

// Textfield ok button cordinates
float textFieldOkX1, textFieldOkX2;
float textFieldOkY1, textFieldOkY2;

// help button cordinates
float helpButtonX1, helpButtonX2;
float helpButtonY1, helpButtonY2;

// mapButton cordinates
float mapButtonX1, mapButtonX2;
float mapButtonY1, mapButtonY2;

// onScreenKeyboard cordinates
float screenX1, screenX2;
float screenY1, screenY2;

// tabular data  button cordinates
float tabularDataButtonX1, tabularDataButtonX2;
float tabularDataButtonY1, tabularDataButtonY2;

// compareDataSet cordinates
float compareDataSetX1, compareDataSetX2;
float compareDataSetY1, compareDataSetY2;

// select year range button
float yearRangeButtonX1, yearRangeButtonX2;
float yearRangeButtonY1, yearRangeButtonY2;

// compareRegionsButton cordinates
float compareRegionsX1, compareRegionsX2;
float compareRegionsY1, compareRegionsY2;

// spacebar, enter and backSpace cordinates
float spacebarX1, spacebarY1, spacebarWidth, spacebarHeight;
float enterX1, enterY1, enterWidth, enterHeight;
float backSpaceX1, backSpaceY1, backSpaceWidth, backSpaceHeight;

// entire range button cordinates
float entireRangeX1;
float entireRangeY1;
float entireRangeWidth;
float entireRangeHeight;

// year Increase and decrease buttons
float year1IncX1, year1IncY1;
float year2IncX1, year2IncY1;
float year1DecX1, year1DecY1;
float year2DecX1, year2DecY1;
float yearWidth, yearHeight;


// control structure for the six data sets
boolean energyProduction = false;
boolean energyConsumption = false;
boolean co2Emissions = false;
boolean renewableEnergyGeneration = false;
boolean totalButton = false;
boolean perCapitaButton = false;
boolean setTextBox = false;
boolean clearGraph = false;
boolean helpButton = false;
//boolean tabularData = false;
boolean compareDataSet = false;
boolean yearRange = false;
boolean compareRegions = false;
boolean displayStartScreen = true;
boolean oneYear = false;
boolean selectMap = true;

PFont plotFont;
String regionName = "";
String[] selectedRegions = new String[100];
String dataBaseName;
String yAxisUnitLabel;
String autoString = "";
int check = 0;
char regionNameChar[] = new char[300];
int typedCount;
int regionCount = 0;
int maxRegions = 0;
public float Xpos, Ypos, scrollBarXpos, scrollBarYpos;

void setup() {
  //size(1360,700);
  size(680*scaleFactor, 192*scaleFactor, P3D); // notebook fullscreen 
  //size(8160, 2304, P3D); //cyber-commons wall

  // Make the connection to the tracker machine (uncomment this if testing with touch)
  omicronManager.ConnectToTracker(7001, 7340, "131.193.77.159");

  // Create a listener to get events
  touchListener = new TouchListener();

  // Register listener with OmicronAPI
  omicronManager.setTouchListener(touchListener);

  // Sets applet to this sketch
  applet = this;


  // information Display Window Cordinates
  idPlotX1 = 10 * scaleFactor;
  idPlotX2 = width * 0.29 + idPlotX1;
  idPlotY1 = 10 * scaleFactor;
  idPlotY2 = 0.45 * height + idPlotY1;
  idWidth = idPlotX2 - idPlotX1;
  idHeight = idPlotY2 - idPlotY1;

  // Control Panel cordinates
  cpPlotX1 = 10 * scaleFactor;
  cpPlotX2 = width * 0.29 + cpPlotX1;
  cpPlotY1 = idPlotY2 + 0.02 * height;
  cpPlotY2 = height - 10 * scaleFactor;
  cpWidth = cpPlotX2 - cpPlotX1;
  cpHeight = cpPlotY2 - cpPlotY1;

  // Graphical Window coordiantes
  gwPlotX1 = cpPlotX2 + 0.01 * width;
  gwPlotX2 = gwPlotX1 + 0.40 * width;
  gwPlotY1 = 10 * scaleFactor;
  gwPlotY2 = height - 10 * scaleFactor;
  gwWidth = gwPlotX2 - gwPlotX1;
  gwHeight = gwPlotY2 - gwPlotY1;

  // Graphical window graph cordinates
  gwGraphX1 = gwPlotX1 + 63 * scaleFactor;
  gwGraphX2 = gwGraphX1 + 0.29 * gwPlotX2;
  gwGraphY1 = gwPlotY1 + 25 * scaleFactor;
  gwGraphY2 = gwGraphY1 + 0.60 * gwPlotY2;


  // tabular Window cordinates
  twPlotX1 = gwPlotX2 + 0.01 * width;
  twPlotX2 = width - 10 * scaleFactor;
  twPlotY1 = 10 * scaleFactor;
  twPlotY2 = height - 10 * scaleFactor;
  twWidth = twPlotX2 - twPlotX1;
  twHeight = twPlotY2 - twPlotY1;

  // energy production button cordinates
  epButtonX1 = cpPlotX1 + 5 * scaleFactor;
  epButtonX2 = epButtonX1 + 0.35 * cpPlotX2;
  epButtonY1 = cpPlotY1 + 5 * scaleFactor;
  epButtonY2 = epButtonY1 + 0.215 * cpHeight;
  epWidth = epButtonX2 - epButtonX1;
  epHeight = epButtonY2 - epButtonY1; 

  // energy consumption button cordinates
  ecButtonX1 = epButtonX1;
  ecButtonX2 = epButtonX2;
  ecButtonY1 = epButtonY2 + 0.01 * cpHeight;
  ecButtonY2 = ecButtonY1 + 0.215 * cpHeight; 
  ecWidth = ecButtonX2 - ecButtonX1;
  ecHeight = ecButtonY2 - ecButtonY1;

  // co2 emission button cordinates
  co2ButtonX1 = ecButtonX1;
  co2ButtonX2 = ecButtonX2;
  co2ButtonY1 = ecButtonY2 + 0.01 * cpHeight;
  co2ButtonY2 = co2ButtonY1 + 0.215 * cpHeight;
  co2Width = co2ButtonX2 - co2ButtonX1;
  co2Height = co2ButtonY2 - co2ButtonY1;

  // renewable electricity generation cordinates
  regButtonX1 = co2ButtonX1;
  regButtonX2 = co2ButtonX2;
  regButtonY1 = co2ButtonY2 + 0.01 * cpHeight;
  regButtonY2 = regButtonY1 + 0.215 * cpHeight;
  regWidth = regButtonX2 - regButtonX1;
  regHeight = regButtonY2 - regButtonY1;

  // total button cordinates
  totalButtonX1 = epButtonX2 + 5 * scaleFactor;
  totalButtonX2 = totalButtonX1 + 25 * scaleFactor;
  totalButtonY1 = cpPlotY1 + 10 * scaleFactor;
  totalButtonY2 = totalButtonY1 + 10 * scaleFactor;

  // perCapita Button cordinates
  perCapitaButtonX1 = totalButtonX2 + 3 * scaleFactor;
  perCapitaButtonX2 = perCapitaButtonX1 + 35 * scaleFactor;
  perCapitaButtonY1 = cpPlotY1 + 10 * scaleFactor;
  perCapitaButtonY2 = perCapitaButtonY1 + 10 * scaleFactor;

  //compareDataSet Button cordinates
  compareDataSetX1 = ecButtonX2 + 11 * scaleFactor;
  compareDataSetX2 = cpPlotX2 - 5 * scaleFactor;
  compareDataSetY1 = ecButtonY1;
  compareDataSetY2 = ecButtonY2;

  // year Range Button cordinates
  yearRangeButtonX1 = co2ButtonX2 + 11 * scaleFactor;
  yearRangeButtonX2 = yearRangeButtonX1 + 49 * scaleFactor;
  yearRangeButtonY1 = co2ButtonY1;
  yearRangeButtonY2 = co2ButtonY2;
  
  //year range inc and dec button
  year1DecX1 = year2DecX1 = gwPlotX1 + 105 * scaleFactor;
  year1DecY1 = year1IncY1 = gwPlotY1 + 38 * scaleFactor;
  year1IncX1 = year2IncX1 = gwPlotX2 - 105 * scaleFactor;
  year2DecY1 = year2IncY1 = gwPlotY1 + 62 * scaleFactor;
  yearWidth = 4 * scaleFactor;
  yearHeight = 4 * scaleFactor;

  // compare regions cordinates
  compareRegionsX1 = yearRangeButtonX2 + 2 * scaleFactor;
  compareRegionsX2 = cpPlotX2 - 5 * scaleFactor;
  compareRegionsY1 = yearRangeButtonY1;
  compareRegionsY2 = yearRangeButtonY2;

  // textBox  cordinates
  textBoxX1 = epButtonX2 + 11 * scaleFactor;
  textBoxX2 = textBoxX1 + 49 * scaleFactor;
  textBoxY1 = regButtonY1;
  textBoxY2 = regButtonY2;

  // text area back button cordinates
  backButtonX1 = gwPlotX1 + 5 * scaleFactor;
  backButtonX2 = backButtonX1 + 30 * scaleFactor;
  backButtonY2 = gwPlotY2 - 5 * scaleFactor;
  backButtonY1 = backButtonY2 - 15 * scaleFactor;

  // textField cordinates
  textFieldX1 = gwPlotX1 + 10 * scaleFactor;
  textFieldX2 = gwPlotX2 - 10 * scaleFactor;
  textFieldY1 = gwPlotY1 + 10 * scaleFactor;
  textFieldY2 = textFieldY1 + 10 * scaleFactor;

  // textFieldOk cordinates
  textFieldOkX1 = backButtonX1;
  textFieldOkX2 = backButtonX2;
  textFieldOkY2 = backButtonY1 - 2 * scaleFactor;
  textFieldOkY1 = textFieldOkY2 - 15 * scaleFactor;

  // helpbutton cordinates
  helpButtonX1 = cpPlotX2 - 30 * scaleFactor;
  helpButtonX2 = helpButtonX1 + 25 * scaleFactor;
  helpButtonY1 = epButtonY1;
  helpButtonY2 = epButtonY2;

  //mapButton cordinates
  mapButtonX1 = textBoxX2 + 2 * scaleFactor;
  mapButtonX2 = cpPlotX2 - 5 * scaleFactor;
  mapButtonY1 = textBoxY1;
  mapButtonY2 = textBoxY2;

  // select entire range
  entireRangeX1 = gwPlotX1 + (gwPlotX2-gwPlotX1)/2;
  entireRangeY1 = gwPlotY1 + 80 * scaleFactor;
  entireRangeWidth = 40 * scaleFactor;
  entireRangeHeight = 5 * scaleFactor;

  // onscreen keyboard cordinates
  screenX1 = backButtonX2 + 5 * scaleFactor;
  screenX2 = gwPlotX2 - 5 * scaleFactor;
  screenY2 = gwPlotY2 - 5 * scaleFactor;
  screenY1 = gwPlotY2 - 50 * scaleFactor;

  // spacebar, backspace and enter cordinates
  

  if (selectMap == true) {
    
    spacebarX1 = gwPlotX1 + 62 * scaleFactor;
    spacebarY1 = gwPlotY2 - 32 * scaleFactor;
    spacebarWidth = 20 * scaleFactor;
    spacebarHeight = 4 * scaleFactor;
  
    backSpaceX1 =  gwPlotX1 + 92 * scaleFactor;
    backSpaceY1 = gwPlotY2 - 32 * scaleFactor;
    backSpaceWidth = 8 * scaleFactor;
    backSpaceHeight = 4 * scaleFactor;
    
    enterX1 = gwPlotX1 + 110 * scaleFactor;
    enterY1 = gwPlotY2 - 32 * scaleFactor;
    enterHeight = 4 * scaleFactor;
    enterWidth =  8 * scaleFactor;
    
  }
  else {
    
    spacebarX1 = gwPlotX1 + (gwPlotX2-gwPlotX1)/2;
    spacebarY1 = gwPlotY2 - 10 * scaleFactor;
    spacebarWidth = 50 * scaleFactor;
    spacebarHeight = 4 * scaleFactor;
  
    backSpaceX1 = spacebarX1 + 60 * scaleFactor + 5 * scaleFactor;
    backSpaceY1 = gwPlotY2 - 10 * scaleFactor;
    backSpaceWidth = 10 * scaleFactor;
    backSpaceHeight = 4 * scaleFactor;
    
    enterX1 = gwPlotX1 + (165) * scaleFactor + 80 * scaleFactor;
    enterY1 = gwPlotY2 - 45 * scaleFactor + 12 * scaleFactor;
    enterHeight = 14 * scaleFactor;
    enterWidth =  14 * scaleFactor;
  }


  temp = new ProcessTable("total_carbon_dioxide_emissions.tsv");
  colEnd = temp.getColumnCount();
  colStart = 0;
  yearEnd = 2009;
  yearStart = 1980;
  //yearStart =temp.getColName(colStart);
  //yearEnd = temp.getColName(colEnd);
  println(yearStart);
  println(yearEnd);
  hs1 = new HScrollbar(gwPlotX1 + 10 * scaleFactor, gwPlotY2 - 30 * scaleFactor, (int)(gwPlotX2 - gwPlotX1 - 20 * scaleFactor), 8 * scaleFactor, 16);
  hs2 = new HScrollbar(gwPlotX1 + 10 * scaleFactor, gwPlotY2 - (45 * scaleFactor), (int)(gwPlotX2 - gwPlotX1 - 20 * scaleFactor), 8 * scaleFactor, 16);
  plotFont = createFont("Helvetica", 20*scaleFactor);
  textFont(plotFont);
  
  //sizeMap = ((float) width/(gwPlotX2-gwPlotX1));
  countryList = new ArrayList<Country>();
  countryCount = temp.getRowCount();
  manageMap = new ManageMap(sizeMapWidth, sizeMapHeight,temp,countryList,width,height,this);
  manageMap.setupMap();
  worldMap = manageMap.getWorldMap();
  println(worldMap);

  smooth();
}


void draw() {
  background(150);

  //plotting the three windows: control panel, graphics window and tabular window
  //stroke(100);
  fill(0);
  rectMode(CORNERS);
  rect(idPlotX1, idPlotY1, idPlotX2, idPlotY2);
  rect(cpPlotX1, cpPlotY1, cpPlotX2, cpPlotY2);
  rect(gwPlotX1, gwPlotY1, gwPlotX2, gwPlotY2);
  rect(twPlotX1, twPlotY1, twPlotX2, twPlotY2);

  /*
  if(tabularData == false) {
   rect(gwPlotX1, gwPlotY1, gwPlotX2, gwPlotY2);
   rect(twPlotX1, twPlotY1, twPlotX2, twPlotY2);
   }
   else {
   rect(gwPlotX1, gwPlotY1, twPlotX2, twPlotY2);
   }*/



  // plotting the buttons
  noStroke();
  fill(180);
  rectMode(CORNERS);
  rect(epButtonX1, epButtonY1, epButtonX2, epButtonY2);
  rect(ecButtonX1, ecButtonY1, ecButtonX2, ecButtonY2);
  rect(co2ButtonX1, co2ButtonY1, co2ButtonX2, co2ButtonY2);
  rect(regButtonX1, regButtonY1, regButtonX2, regButtonY2);
  
  rect(helpButtonX1, helpButtonY1, helpButtonX2, helpButtonY2);
  

  if (displayStartScreen == true) {
    displayStartScreen();
  }


  if  (helpButton == true) {
    fill(230);
    rect(helpButtonX1, helpButtonY1, helpButtonX2, helpButtonY2);
  }

  fill(250);
  rectMode(CORNERS);

  noStroke();
  fill(0);
  textSize(7*scaleFactor);
  textLeading(7*scaleFactor);
  textAlign(CENTER, CENTER);
  text("Energy Production", epButtonX1+epWidth/2, epButtonY1+epHeight/2);
  text("Energy Consumption", ecButtonX1+ecWidth/2, ecButtonY1+ecHeight/2);
  text("Carbon Dioxide\nEmissions", co2ButtonX1+co2Width/2, co2ButtonY1+co2Height/2);
  text("Renewable Electricity\nGeneration", regButtonX1+regWidth/2, regButtonY1+regHeight/2);
  text("Select region", textBoxX1 +  (textBoxX2 - textBoxX1)/2, textBoxY1 + (textBoxY2-textBoxY1)/2);
  text("Help!", helpButtonX1 + (helpButtonX2 - helpButtonX1)/2, helpButtonY1 + (helpButtonY2-helpButtonY1)/2);
  

  if (helpButton == true) {
    fill(#5134C1);
    text("Help!", helpButtonX1 + (helpButtonX2 - helpButtonX1)/2, helpButtonY1 + (helpButtonY2-helpButtonY1)/2);
  }
  

  
  noFill();
  stroke(170);
  strokeWeight(0.5 * scaleFactor);
  rectMode(CORNERS);
  rect(mapButtonX1, mapButtonY1, mapButtonX2, mapButtonY2);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(7*scaleFactor);
  fill(170);
  text("Map", mapButtonX1 + (mapButtonX2-mapButtonX1)/2, mapButtonY1 + (mapButtonY2-mapButtonY1)/2);
  if (selectMap == true) {
    fill(0);
    rect(gwPlotX2,gwPlotY1, twPlotX1, gwPlotY2);
    noFill();
    stroke(#41ffC1);
    strokeWeight(0.5 * scaleFactor);
    rect(mapButtonX1, mapButtonY1, mapButtonX2, mapButtonY2);
    fill(#8ED5DE,200);
    //fill(#4545AE);
    noStroke();
    rect(gwPlotX1, gwPlotY1, twPlotX2, gwPlotY2);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(7*scaleFactor);
    fill(#41ffC1);
    text("Map", mapButtonX1 + (mapButtonX2-mapButtonX1)/2, mapButtonY1 + (mapButtonY2-mapButtonY1)/2);
    fill(255);
    
    drawMap();
  }
  
  
  
  noFill();
  stroke(170);
  strokeWeight(0.5 * scaleFactor);
  rectMode(CORNERS);
  rect(textBoxX1, textBoxY1, textBoxX2, textBoxY2 );
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(7*scaleFactor);
  fill(170);
  text("Select region", textBoxX1 +  (textBoxX2 - textBoxX1)/2, textBoxY1 + (textBoxY2-textBoxY1)/2);
  if (setTextBox == true) {
    noFill();
    stroke(#41ffC1);
    strokeWeight(0.5 * scaleFactor);
    rect(textBoxX1, textBoxY1, textBoxX2, textBoxY2 );
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(7*scaleFactor);
    fill(#41ffC1);
    text("Select region", textBoxX1 +  (textBoxX2 - textBoxX1)/2, textBoxY1 + (textBoxY2-textBoxY1)/2);
  }

  fill(250);
  textAlign(LEFT, CENTER);
  text("See Data As : ", epButtonX2 + 10 * scaleFactor, cpPlotY1 + 5 * scaleFactor);

  noFill();
  stroke(170);
  strokeWeight(0.5 * scaleFactor);
  rectMode(CORNERS);
  rect(compareDataSetX1, compareDataSetY1, compareDataSetX2, compareDataSetY2);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(7*scaleFactor);
  fill(170);
  text ("Compare Energy Production\nand Consumption", compareDataSetX1 + (compareDataSetX2-compareDataSetX1)/2, compareDataSetY1 + (compareDataSetY2-compareDataSetY1)/2);
  if (compareDataSet == true) {
    noFill();
    stroke(#41ffC1);
    strokeWeight(0.5 * scaleFactor);
    rect(compareDataSetX1, compareDataSetY1, compareDataSetX2, compareDataSetY2);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(7*scaleFactor);
    fill(#41ffC1);
    text ("Compare Energy Production\nand Consumption", compareDataSetX1 + (compareDataSetX2-compareDataSetX1)/2, compareDataSetY1 + (compareDataSetY2-compareDataSetY1)/2);
  }




  noFill();
  stroke(170);
  strokeWeight(0.5 * scaleFactor);
  rectMode(CORNERS);
  rect(compareRegionsX1, compareRegionsY1, compareRegionsX2, compareRegionsY2);
  fill(170);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(7*scaleFactor);
  text("Compare\nregions", compareRegionsX1 + (compareRegionsX2 - compareRegionsX1)/2, compareRegionsY1 + (compareRegionsY2 - compareRegionsY1)/2);
  if (compareRegions == true) {
    noFill();
    stroke(#41ffC1);
    strokeWeight(0.5 * scaleFactor);
    rectMode(CORNERS);
    rect(compareRegionsX1, compareRegionsY1, compareRegionsX2, compareRegionsY2);
    fill(#41ffC1);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(7*scaleFactor);
    text("Compare\nregions", compareRegionsX1 + (compareRegionsX2 - compareRegionsX1)/2, compareRegionsY1 + (compareRegionsY2 - compareRegionsY1)/2);
  }


  displayInfo();
  setDataTableName();
  drawData();


  stroke(170);
  strokeWeight(0.5 * scaleFactor);
  noFill();
  rectMode(CORNERS);
  rect(yearRangeButtonX1, yearRangeButtonY1, yearRangeButtonX2, yearRangeButtonY2);
  noStroke();
  fill(170);
  textSize(7*scaleFactor);
  textAlign(CENTER, CENTER);
  text ("Select\nYear Range", yearRangeButtonX1 + (yearRangeButtonX2-yearRangeButtonX1)/2, yearRangeButtonY1 + (yearRangeButtonY2-yearRangeButtonY1)/2);
  if (yearRange == true) {
    stroke(#41ffC1);
    strokeWeight(0.5 * scaleFactor);
    noFill();
    rect(yearRangeButtonX1, yearRangeButtonY1, yearRangeButtonX2, yearRangeButtonY2);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(7*scaleFactor);
    fill(#41ffC1);
    text ("Select\nYear Range", yearRangeButtonX1 + (yearRangeButtonX2-yearRangeButtonX1)/2, yearRangeButtonY1 + (yearRangeButtonY2-yearRangeButtonY1)/2);

    fill(10, 150, 200, 250);
    rect(gwPlotX1, gwPlotY1, gwPlotX2, gwPlotY2);
    // rect(twPlotX1, twPlotY1, twPlotX2, twPlotY2);

    //float img1Pos = hs1.getPos()- (gwPlotX2-gwPlotX1)/2;
    fill(0);
    textSize(8 * scaleFactor);
    //text(img1Pos, gwPlotX1 + 10 * scaleFactor, gwPlotY2 - 5 * scaleFactor); 
    fill(170);
    hs1.update();
    hs1.display();
    hs2.update();
    hs2.display();
    selectYearPos();
  }


  //---------------------------------------------------------------------
  
  if (selectMap == true) {
    
    spacebarX1 = gwPlotX1 + 62 * scaleFactor;
    spacebarY1 = gwPlotY2 - 32 * scaleFactor;
    spacebarWidth = 20 * scaleFactor;
    spacebarHeight = 4 * scaleFactor;
  
    backSpaceX1 =  gwPlotX1 + 92 * scaleFactor;
    backSpaceY1 = gwPlotY2 - 32 * scaleFactor;
    backSpaceWidth = 8 * scaleFactor;
    backSpaceHeight = 4 * scaleFactor;
    
    enterX1 = gwPlotX1 + 110 * scaleFactor;
    enterY1 = gwPlotY2 - 32 * scaleFactor;
    enterHeight = 4 * scaleFactor;
    enterWidth =  8 * scaleFactor;
    
  }
  else {
    
    spacebarX1 = gwPlotX1 + (gwPlotX2-gwPlotX1)/2;
    spacebarY1 = gwPlotY2 - 10 * scaleFactor;
    spacebarWidth = 50 * scaleFactor;
    spacebarHeight = 4 * scaleFactor;
  
    backSpaceX1 = spacebarX1 + 60 * scaleFactor + 5 * scaleFactor;
    backSpaceY1 = gwPlotY2 - 10 * scaleFactor;
    backSpaceWidth = 10 * scaleFactor;
    backSpaceHeight = 4 * scaleFactor;
    
    enterX1 = gwPlotX1 + (165) * scaleFactor + 80 * scaleFactor;
    enterY1 = gwPlotY2 - 45 * scaleFactor + 12 * scaleFactor;
    enterHeight = 14 * scaleFactor;
    enterWidth =  14 * scaleFactor;
  }

//--------------------------------------------------------------------------

  omicronManager.process();
}

void displayStartScreen() {
  textSize(10 *  scaleFactor);
  textAlign(CENTER, CENTER);
  fill(200, 19, 19);
  text("Start by selecting a Data set or Region!", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + (gwPlotY2 - gwPlotY1)/2);
}

void displayInfo() {
  if (dataBaseName != null) {
    if (compareRegions == false) {
      if (regionCount>0) {
        textSize(8*scaleFactor);
        textAlign(LEFT, CENTER);
        fill(#5153A9);
        text("Information Display", idPlotX1 + 10 * scaleFactor, idPlotY1 + 10 * scaleFactor);
        fill(#899012);
        textSize(7*scaleFactor);
        text(dataBaseName + " data\nfrom year " + (yearStart) + " to " + yearEnd + "\nfor the region(s) : " + selectedRegions[regionCount-1], idPlotX1 + 10 * scaleFactor, idPlotY1 + 30 * scaleFactor);
      }
    }
    else {
      if (regionCount>0) {
        textSize(8*scaleFactor);
        textAlign(LEFT, CENTER);
        fill(#5153A9);
        text("Information Display", idPlotX1 + 10 * scaleFactor, idPlotY1 + 10 * scaleFactor);
        textSize(7*scaleFactor);
        fill(#899012);
        int countY = 0;
        int countX = 0;
        text(dataBaseName + " data\nfrom year " + (yearStart) + " to " + yearEnd + "\nfor the region(s) :", idPlotX1 + 10 * scaleFactor, idPlotY1 + 30 * scaleFactor);
        for (int i = 0; i<regionCount; i++) {

          fill(colors[i]);
          if (idPlotY1 + 50 * scaleFactor + countY * 8 * scaleFactor > idPlotY2) {
            countY = 0;
            countX++;
          }
          text("\n" + selectedRegions[i] + "\n", idPlotX1 + 10 * scaleFactor + countX * 50 * scaleFactor, idPlotY1 + 50 * scaleFactor + countY * 7 * scaleFactor);
          countY++;
        }
      }
    }
  }
}


void drawMap() {
  //sizeMapWidth= ((float) width /(twPlotX2-gwPlotX1));
  //sizeMapHeight = ((float) height/(gwPlotY2-gwPlotY1-50*scaleFactor));
  manageMap.setSizeMap(twPlotX2-gwPlotX1,gwPlotY2-gwPlotY1);
  manageMap.drawMap();
}

void drawData() {
  if (check == 1 && setTextBox == false && clearGraph == true) {
    if (compareDataSet == false) {
      noStroke();
      fill(#5679C1, 100);
      if (regionCount == 0) {
        setTextBox = true;
      }
      if (oneYear == true) {
        println("one year");
      }
      else {

        if (compareRegions == false) {
          drawDataBars(currentRow, colStart, colEnd);

          drawDataRelateWorld(currentRow, colStart, colEnd);
          drawDataHighlight(currentRow, colStart, colEnd);

          drawTitle();
          drawAxisLabels();

          drawUnitLabels();
          drawYearLabels(colStart, colEnd);
        }

        else {
          for (int i = 0; i<regionCount; i++) {
            int currentRow = data.getRowIndex(selectedRegions[i]);
            println(currentRow + " : " + selectedRegions[i]);
            drawTitle();
            println("0");
            drawAxisLabels();
            println("1");
            drawUnitLabels();
            println("1.2");
            drawYearLabels(colStart, colEnd); 
            println("2");
            drawDataPoints(currentRow, colStart, colEnd, colors[i]);
            drawDataCurve(currentRow, colStart, colEnd, colors[i]);

            // drawDataRelateWorld(currentRow, colStart, colEnd);
            drawDataHighlight(currentRow, colStart, colEnd);
          }
        }
      }
    } 
    else {
      drawTitle();
      drawAxisLabels();

      drawUnitLabels();
      drawYearLabels(colStart, colEnd); 

      drawDataArea(currentRow, colStart, colEnd);
      //drawDataRelateWorld(currentRow, 0, columnCount);
      //drawDataHighlight(currentRow);
    }
  }
  if (setTextBox == true) {
    setTextBoxFunc();
  }
  if (helpButton == true) {
    setHelpFunc();
  }
}



void setHelpFunc() {
  //setting back button
  noStroke();
  fill(180);
  rectMode(CORNERS);
  rect(backButtonX1, backButtonY1, backButtonX2, backButtonY2);  
  noStroke();
  fill(0);
  textSize(7*scaleFactor);
  textLeading(7*scaleFactor);
  textAlign(CENTER, CENTER);
  text("Back", backButtonX1 +( backButtonX2-backButtonX1)/2, backButtonY1 + (backButtonY2 - backButtonY1)/2);
  textSize(8*scaleFactor);
  fill(#AA1212);
  textAlign(CENTER, CENTER);
  text("Help", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 15 * scaleFactor);
  textSize(5*scaleFactor);
  fill(255);
  textAlign(CENTER,CENTER);
  if (selectMap ==true) {
    fill(0);
  }
  text("Energy Production - Click or touch to select Energy Production data.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 25 * scaleFactor);
  text("Energy Consumption - Click or touch to select Energy Consumption data.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 30 * scaleFactor);
  text("Carbon Dioxide Emissions - Click or touch to select Carbon Dioxide Emissions data.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 35 * scaleFactor);
  text("Renewable Energy Generation - Click or touch to select Renewable Energy Generation data.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 40 * scaleFactor);
  text("Total - Click or touch to view data as \"Total\" for the selected data set.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 45 * scaleFactor);
  text("Per Capita - Click or touch to view data as \"Per Capita\" for the selected data", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 50 * scaleFactor);
  text("Selecting a region :", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 65 * scaleFactor);
  text("Click or touch the \"Select Region\" button to open the select region screen. \nUse the keyboard\\on screen keyboard to input the Region Name and Hit \"Enter\\Return\".\nThen select the data set you want to view from the control panel.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 80 * scaleFactor);
  text("You can also select the region using the \"Map\" Button from the control panel.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 95 * scaleFactor);
  text("Compare :", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 107 * scaleFactor);
  text("Use the \"compare regions\" button to compare two or more regions.\nUse the \"Compare Production and Consumption Button\" to compare the region's\nenergy production and consumption data.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 120 * scaleFactor);
  text("Selecting year range :", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 135 * scaleFactor);
  text("Use the \"Select Year\" button to select year range to view data.", gwPlotX1 + (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 141 * scaleFactor);

  textAlign(CENTER,CENTER);
  fill(#A1A423);
  textSize(8*scaleFactor);
  text("Credits", twPlotX1 + (twPlotX2 - twPlotX1)/2, twPlotY1 + 15 * scaleFactor);
  fill(#ffffff);
  if (selectMap == true) {
    fill(0);
  }
  textSize(7 * scaleFactor);
  text("Electric Avenue", twPlotX1 + (twPlotX2 - twPlotX1)/2, twPlotY1 + 30 * scaleFactor);
  textSize(5 * scaleFactor);
  text("CS 424 - Visualization and Visual Analytics : Project 1", twPlotX1 + (twPlotX2 - twPlotX1)/2, twPlotY1 + 38 * scaleFactor);
  text("Developed By : Giric Goyal - 657440995", twPlotX1 + (twPlotX2 - twPlotX1)/2, twPlotY1 + 45 * scaleFactor);
  text("The project makes use of data from\nthe US Energy Information Administration\nfor the years 1980 through 2009.", twPlotX1 + (twPlotX2 - twPlotX1)/2, twPlotY1 + 65 * scaleFactor);

}



void plotKeyboardButtons() {
  for (int i = 0 ; i < 3 ; i++ ) {
    for (int j = 0 ; j < 10; j++) {
      if ((keyboardLayout[i][j] >= 'A' && keyboardLayout[i][j] <= 'Z') || keyboardLayout[i][j] == '.' || keyboardLayout[i][j] == ',') {
        textSize(6* scaleFactor);
        textAlign(CENTER, CENTER);
        noFill();
        stroke(#554592);
        strokeWeight(0.5*scaleFactor);
        rectMode(RADIUS);
        if (selectMap == true) {
          rect(gwPlotX1 + 8*scaleFactor + (j*10) * scaleFactor + i * 8 * scaleFactor, gwPlotY2 - 70 * scaleFactor + i * 12 * scaleFactor, 5 * scaleFactor, 5 * scaleFactor);
          fill(#554592);
          text(keyboardLayout[i][j], gwPlotX1 + 8*scaleFactor+ (j*10) * scaleFactor + i * 8 * scaleFactor, gwPlotY2 - 70 * scaleFactor + i * 12 * scaleFactor);
        }
        else {
          
          rect(gwPlotX1 + (50+j*10) * scaleFactor + j * 8 * scaleFactor + i * 8 * scaleFactor, gwPlotY2 - 45 * scaleFactor + i * 12 * scaleFactor, 5 * scaleFactor, 5 * scaleFactor);
          fill(180);
          text(keyboardLayout[i][j], gwPlotX1 + (50+j*10) * scaleFactor + j * 8 * scaleFactor + i * 8 * scaleFactor, gwPlotY2 - 45 * scaleFactor + i * 12 * scaleFactor);
        }
      }
    }
  }
  text("Enter", enterX1, enterY1);
  text("Del", backSpaceX1, backSpaceY1);
  noFill();
  stroke(#554592);
  strokeWeight(0.5*scaleFactor);
  rect(spacebarX1, spacebarY1, spacebarWidth, spacebarHeight);
  rect(enterX1, enterY1, enterWidth, enterHeight);
  rect(backSpaceX1, backSpaceY1, backSpaceWidth, backSpaceHeight);
}

void setTextBoxFunc() {
  //setting back button
  noStroke();
  fill(180);
  rectMode(CORNERS);
  rect(backButtonX1, backButtonY1, backButtonX2, backButtonY2);  
  noStroke();
  fill(0);
  textSize(7*scaleFactor);
  textLeading(7*scaleFactor);
  textAlign(CENTER, CENTER);
  text("Back", backButtonX1 +( backButtonX2-backButtonX1)/2, backButtonY1 + (backButtonY2 - backButtonY1)/2);

  //setting textField
  noStroke();
  fill(250, 250, 250, 190);
  rectMode(CORNERS);
  rect(textFieldX1, textFieldY1, textFieldX2, textFieldY2);
  fill(0);
  textSize(7*scaleFactor);
  textLeading(7*scaleFactor);
  textAlign(LEFT, CENTER);
  text("Enter region name : " + regionName + autoString, textFieldX1 + 10 * scaleFactor, textFieldY1 + (textFieldY2-textFieldY1)/2);


  // setting textbox field ok button
  noStroke();
  fill(180);
  rectMode(CORNERS);
  rect(textFieldOkX1, textFieldOkY1, textFieldOkX2, textFieldOkY2);
  fill(0);
  textSize(7*scaleFactor);
  textLeading(7*scaleFactor);
  textAlign(CENTER, CENTER);
  text("Ok", textFieldOkX1 +( textFieldOkX2-textFieldOkX1)/2, textFieldOkY1 + (textFieldOkY2 - textFieldOkY1)/2);

  // on screen keyboard
  stroke(255);
  noFill();
  //rect(screenX1, screenY1, screenX2, screenY2);
  plotKeyboardButtons();



  //  display possible region names
  if (autoString != "") {
    String[] rowNames = new String[100];
    rowNames = data.getRowNames();
    int count = 0;
    int countY = 0;
    for (int i = 0; i<data.getRowCount() ; i++) {
      if (regionName.length() == 0) {
      }
      else if ((rowNames[i].toUpperCase()).startsWith(regionName.toUpperCase()) == true) {
        noFill();
        noStroke();
        fill(255);
        textSize(6 * scaleFactor);
        textAlign(LEFT, CENTER);

        if (gwPlotY1 +  (20 + countY * 10) * scaleFactor > gwPlotY2 - 70 * scaleFactor ) {
          count ++;
          countY = 0;
        }
        countY++ ;
        //count ++ ;
        if (selectMap == true) {
          fill(0);
        }
        text(rowNames[i], gwPlotX1 +  90 * count * scaleFactor + 25, gwPlotY1 +  (20 + countY * 10) * scaleFactor);
      }
    }
  }
}


void clearGraphArea() {
  check = 0;
  clearGraph = true;
  stroke(100);
  fill(100);
  rectMode(CORNERS);
  rect(gwPlotX1, gwPlotY1, gwPlotX2, gwPlotY2);
}

void checkData() {
  if (dataMax <= 1) {
    data.convertDataUnit(worldRow, 1);
    data.convertDataUnit(currentRow, 1);
    getDataMaxMin(currentRow); 
    setYAxisUnitLabelLesser1();
  }
  else if (dataMax >= 1 && dataMax <= 1000) {
    setYAxisUnitLabelGreater1();
  }
  else {
    //data.convertDataUnit(worldRow, 0);
    //data.convertDataUnit(currentRow, 0);
    getDataMaxMin(currentRow);
    setYAxisUnitLabelGreater1();
  }
  setData();
}

void setData() {
  if (dataMax <= 5) {
    unitInterval = 1;
    dataMax = 5;
  }
  else if (dataMax <= 10) { 
    unitInterval = 1;
    dataMax = 10;
  }
  else if (dataMax <= 20) {
    unitInterval = 2;
    dataMax = 20;
  }
  else if (dataMax <= 50) {
    unitInterval = 5;
    dataMax = 50;
  }
  else if (dataMax <= 100) {
    unitInterval = 10;
    dataMax = 100;
  }
  else if (dataMax <= 200) {
    unitInterval = 20;
    dataMax = 200;
  }
  else if (dataMax <= 500) {
    unitInterval = 50;
    dataMax = 500;
  }
  else if (dataMax <= 1000) {
    unitInterval = 100;
    dataMax = 1000;
  }
  else if (dataMax <= 5000) {
    unitInterval = 500;
    dataMax = 5000;
  }
  else if (dataMax > 10000) {
    unitInterval = 5000;
    dataMax = ceil(data.getRowMax(currentRow)/ unitInterval) * unitInterval;
  }
  else {

    unitInterval = 1000;
    dataMax = ceil(data.getRowMax(currentRow)/ unitInterval) * unitInterval;
    println(dataMax + "!!!!");

    if (compareDataSet == true) {
      if (dataMax < ceil(data2.getRowMax(currentRow)/ unitInterval) * unitInterval) {
        dataMax = ceil(data2.getRowMax(currentRow)/ unitInterval) * unitInterval;
      }
    }
  }
  unitIntervalMinor = ceil(unitInterval / 10);
}


void getDataMaxMin(int row) { 

  dataMin = data.getRowMin(row);
  dataMax = data.getRowMax(row);
  if (compareDataSet == true) {
    if (dataMax < data2.getRowMax(row)) {
      dataMax = data2.getRowMax(row);
    }
  }
}


void selectDataBase() {
  if (selectedRegions[0] != null)
  {
    if (compareDataSet == true) {
      data = new ProcessTable("Total_Primary_Energy_Production.tsv");
      data2 = new ProcessTable("Total_Primary_Energy_Consumption.tsv");
      check = 1;
      dataBaseName = "Total Energy Production vs Consumption";
      clearGraph = true;
      setTextBox = false;
    }
    else if (energyProduction) {
      if (totalButton) {
        data = new ProcessTable("Total_Primary_Energy_Production.tsv");
        dataBaseName = "Total Primary Energy Production";
        check = 1;
      }
    }
    else if (energyConsumption) {
      if (totalButton) {
        data = new ProcessTable("Total_Primary_Energy_Consumption.tsv");
        dataBaseName = "Total Primary Energy Consumption";
        check = 1;
      }
      else if (perCapitaButton) {
        data = new ProcessTable("Total_Primary_Energy_Consumption_per_Capita.tsv");
        dataBaseName = "Per Capita Primary Energy Consumption";
        check = 1;
      }
    }
    else if (co2Emissions) {
      if (totalButton) {
        data = new ProcessTable("total_carbon_dioxide_emissions.tsv");
        dataBaseName = "Total Carbon Dioxide Emissions";
        check = 1;
      }
      else if (perCapitaButton) {
        data = new ProcessTable("per_capita_carbon_dioxide_emissions.tsv");
        dataBaseName = "Per Capita Carbon Dioxide Emissions";
        check = 1;
      }
    }
    else if (renewableEnergyGeneration) {
      if (totalButton) {
        data = new ProcessTable("Total_Renewable_Electricity_Net_Generation.tsv");
        dataBaseName = "Total Renewable Electricity Generation";
        check = 1;
      }
    }

    columnCount = data.getColumnCount();
    rowCount = data.getRowCount();


    years = int(data.getColumnNames());
    yearMin = years[0];
    yearMax = years[years.length - 1];

    worldRow = rowCount-1;

    if (selectedRegions[0] == null) {
      getDataMaxMin(currentRow);

      checkData();
    }
    else {
      if (compareRegions == true) {
        float tempMax = -9999;
        for (int i = 0; i < regionCount; i++) {
          currentRow = data.getRowIndex(selectedRegions[i]);
          if (data.getRowMax(currentRow) > tempMax) {
            tempMax = data.getRowMax(currentRow);
            getDataMaxMin(currentRow);
          }
        }
        for (int i=0; i<regionCount; i++) {
          currentRow = data.getRowIndex(selectedRegions[i]);
          dataMin = 0;
          checkData();
          drawData();
        }
      }
      // tried for multiple selection but didnt work try again
      /*
      for (int i=0; i<regionCount; i++){
       currentRow = data.getRowIndex(selectedRegions[i]);
       if (currentRow > 0) {
       getDataMaxMin(currentRow);
       checkData();
       dataMin = 0;
       drawData();
       }
       }
       */
      else {
        currentRow = data.getRowIndex(selectedRegions[regionCount-1]);
        if (currentRow >= 0) {
          getDataMaxMin(currentRow);
          checkData();
          dataMin = 0;


          drawData();
        }
      }
    }
    dataMin = 0;
  }
  else {
    setTextBox = true;
    setTextBoxFunc();
  }
}

void setDataTableName() {
  if (energyProduction == true) {
    // plotting the buttons
    noStroke();
    rectMode(CORNERS);
    fill(230);
    rect(epButtonX1, epButtonY1, epButtonX2, epButtonY2);
    fill(180);
    rect(ecButtonX1, ecButtonY1, ecButtonX2, ecButtonY2);
    rect(co2ButtonX1, co2ButtonY1, co2ButtonX2, co2ButtonY2);
    rect(regButtonX1, regButtonY1, regButtonX2, regButtonY2);

    noStroke();
    textSize(7*scaleFactor);
    textLeading(7*scaleFactor);
    textAlign(CENTER, CENTER);
    fill(#5134C1);
    text("Energy Production", epButtonX1+epWidth/2, epButtonY1+epHeight/2);
    fill(0);
    text("Energy Consumption", ecButtonX1+ecWidth/2, ecButtonY1+ecHeight/2);
    text("Carbon Dioxide\nEmissions", co2ButtonX1+co2Width/2, co2ButtonY1+co2Height/2);
    text("Renewable Electricity\nGeneration", regButtonX1+regWidth/2, regButtonY1+regHeight/2);

    if (totalButton == false) {
      pressTotalButton(0);
      pressPerCapitaButton(-1);
    }
    else {
      pressTotalButton(1);
    }
  }
  else if (energyConsumption == true) {
    // plotting the buttons
    noStroke();
    rectMode(CORNERS);
    fill(230);
    rect(ecButtonX1, ecButtonY1, ecButtonX2, ecButtonY2);
    fill(180);
    rect(epButtonX1, epButtonY1, epButtonX2, epButtonY2);
    rect(co2ButtonX1, co2ButtonY1, co2ButtonX2, co2ButtonY2);
    rect(regButtonX1, regButtonY1, regButtonX2, regButtonY2);

    noStroke();
    textSize(7*scaleFactor);
    textLeading(7*scaleFactor);
    textAlign(CENTER, CENTER);
    fill(#5134C1);
    text("Energy Consumption", ecButtonX1+ecWidth/2, ecButtonY1+ecHeight/2);
    fill(0);
    text("Energy Production", epButtonX1+epWidth/2, epButtonY1+epHeight/2);
    text("Carbon Dioxide\nEmissions", co2ButtonX1+co2Width/2, co2ButtonY1+co2Height/2);
    text("Renewable Electricity\nGeneration", regButtonX1+regWidth/2, regButtonY1+regHeight/2);  

    if (perCapitaButton == true) {
      pressPerCapitaButton(1);
    }
    else if (totalButton == true) {
      pressTotalButton(1);
    }
    else if (perCapitaButton == false && totalButton == false) {
      pressTotalButton(0);
      pressPerCapitaButton(0);
    }
  }
  else if (co2Emissions == true) {
    // plotting the buttons
    noStroke();
    rectMode(CORNERS);
    fill(230);
    rect(co2ButtonX1, co2ButtonY1, co2ButtonX2, co2ButtonY2);
    fill(180);
    rect(ecButtonX1, ecButtonY1, ecButtonX2, ecButtonY2);
    rect(epButtonX1, epButtonY1, epButtonX2, epButtonY2);
    rect(regButtonX1, regButtonY1, regButtonX2, regButtonY2);

    noStroke();
    textSize(7*scaleFactor);
    textLeading(7*scaleFactor);
    textAlign(CENTER, CENTER);
    fill(#5134C1);
    text("Carbon Dioxide\nEmissions", co2ButtonX1+co2Width/2, co2ButtonY1+co2Height/2);
    fill(0);
    text("Energy Consumption", ecButtonX1+ecWidth/2, ecButtonY1+ecHeight/2);
    text("Energy Production", epButtonX1+epWidth/2, epButtonY1+epHeight/2);
    text("Renewable Electricity\nGeneration", regButtonX1+regWidth/2, regButtonY1+regHeight/2);


    if (perCapitaButton == true) {
      pressPerCapitaButton(1);
    } 
    else if (totalButton == true) {
      pressTotalButton(1);
    }
    else {
      pressTotalButton(0);
      pressPerCapitaButton(0);
    }
  }
  else if (renewableEnergyGeneration == true) {
    // plotting the buttons
    noStroke();
    rectMode(CORNERS);
    fill(230);
    rect(regButtonX1, regButtonY1, regButtonX2, regButtonY2);
    fill(180);
    rect(ecButtonX1, ecButtonY1, ecButtonX2, ecButtonY2);
    rect(epButtonX1, epButtonY1, epButtonX2, epButtonY2);
    rect(co2ButtonX1, co2ButtonY1, co2ButtonX2, co2ButtonY2);

    noStroke();
    textSize(7*scaleFactor);
    textLeading(7*scaleFactor);
    textAlign(CENTER, CENTER);
    fill(#5134C1);
    text("Renewable Electricity\nGeneration", regButtonX1+regWidth/2, regButtonY1+regHeight/2);
    fill(0);
    text("Energy Consumption", ecButtonX1+ecWidth/2, ecButtonY1+ecHeight/2);
    text("Energy Production", epButtonX1+epWidth/2, epButtonY1+epHeight/2);
    text("Carbon Dioxide\nEmissions", co2ButtonX1+co2Width/2, co2ButtonY1+co2Height/2);

    if (totalButton == true) {
      pressTotalButton(1);
    }
    else {
      pressTotalButton(0);
      pressPerCapitaButton(-1);
    }
  }
}


void setYAxisUnitLabelGreater1000() {
  if (compareDataSet == true) {
    yAxisUnitLabel = "Quintillion\nBtu";
  }
  else if (energyProduction == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Quintillion\nBtu";
    }
  }
  else if (energyConsumption == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Quintillion\nBtu";
    }
    else if (perCapitaButton == true) {
      yAxisUnitLabel = "Billion\nBtu\nper Person";
    }
  }
  else if (co2Emissions == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Billion\nMetric\nTons";
    }  
    else if (perCapitaButton == true) {
      yAxisUnitLabel = "x 1000\nMetric Tons\nper Persons";
    }
  }
  else if (renewableEnergyGeneration == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Trillion\nKWattHours";
    }
  }
}

void setYAxisUnitLabelGreater1() {
  if (compareDataSet == true) {
    yAxisUnitLabel = "Quadrillion\nBtu";
  }
  else if (energyProduction == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Quadrillion\nBtu";
    }
  }
  else if (energyConsumption == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Quadrillion\nBtu";
    }
    else if (perCapitaButton == true) {
      yAxisUnitLabel = "Million\nBtu\nper Person";
    }
  }
  else if (co2Emissions == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Million\nMetric\nTons";
    }  
    else if (perCapitaButton == true) {
      yAxisUnitLabel = "Metric Tons\nper Persons";
    }
  }
  else if (renewableEnergyGeneration == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Brillion\nKWattHours";
    }
  }
}

void setYAxisUnitLabelLesser1() {
  if (compareDataSet == true) {
    yAxisUnitLabel = "Trillion\nBtu";
  }
  if (energyProduction == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Trillion\nBtu";
    }
  }
  else if (energyConsumption == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Trillion\nBtu";
    }
    else if (perCapitaButton == true) {
      yAxisUnitLabel = "Thousand\nBtu\nper Person";
    }
  }
  else if (co2Emissions == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Thousand\nMetric\nTons";
    }
    else if (perCapitaButton == true) {
      yAxisUnitLabel = "Kilograms\nper Persons";
    }
  }
  else if (renewableEnergyGeneration == true) {
    if (totalButton == true) {
      yAxisUnitLabel = "Million\nKWattHours";
    }
  }
}



void drawTitle() {
  fill(255); 
  textSize(7*scaleFactor); 
  textAlign(LEFT);
  noStroke();
  String title = data.getRowName(currentRow); 
  if (selectMap == true) {
    fill(0);
  }
  text(dataBaseName + ": " + title, gwPlotX1 + 5 * scaleFactor, gwPlotY1 + 15 * scaleFactor);
}

void drawAxisLabels() {
  fill(255);
  textSize(4*scaleFactor);
  noStroke();
  textLeading(6*scaleFactor);
  if (selectMap == true) {
    fill(0);
  }
  
  textAlign(CENTER, CENTER);
  text(yAxisUnitLabel, gwPlotX1 + 18 * scaleFactor, (gwGraphY1+gwGraphY2)/2);
  text(yAxisUnitLabel, gwPlotX2 - 18 * scaleFactor, (gwGraphY1+gwGraphY2)/2);
  textAlign(CENTER);
  text("Year", (gwGraphX1+gwGraphX2)/2, gwGraphY1 + 0.95 * gwGraphY2);
}


void drawYearLabels(int startCol, int endCol) {
  fill(255);
  textSize(6*scaleFactor);
  textAlign(CENTER, TOP);
  if (yearMax - yearMin <= 5 ){
    yearInterval = 1;
  }
  else if (yearMax - yearMin <= 10 ){
    yearInterval = 2;
  }
  else {
    yearInterval = 5;
  }
  
  stroke(200, 200, 200, 100);
  strokeWeight(1*scaleFactor);
  if (selectMap == true) {
    fill(0);
    stroke(0, 0, 0, 100);
  }
  for (int column = startCol; column < endCol; column++) {
    if (years[column] % yearInterval == 0) {
      float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
      text(years[column], x, gwGraphY2 + textAscent() + 5*scaleFactor);
      line(x, gwGraphY2, x, gwGraphY2 + 2 * scaleFactor);
    }
  }
}


void selectYearPos() {

  oneYear = false;
  fill(192,192,192);
  rectMode(RADIUS);
  rect(entireRangeX1, entireRangeY1, entireRangeWidth, entireRangeHeight); 
  
  rect(year1DecX1, year1DecY1, yearWidth, yearHeight); 
  rect(year1IncX1, year1IncY1, yearWidth, yearHeight);
  rect(year2DecX1, year2DecY1, yearWidth, yearHeight);
  rect(year2IncX1, year2IncY1, yearWidth, yearHeight);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(7 * scaleFactor);
  text("Select entire range", entireRangeX1, entireRangeY1);
  
  text("<", year1DecX1, year1DecY1);
  text("<", year2DecX1, year2DecY1);
  text(">", year1IncX1, year1IncY1);
  text(">", year2IncX1, year2IncY1);
  textSize(7*scaleFactor);
  textAlign(CENTER, CENTER);
  int yearIntervalTemp1 = 1;
  int yearIntervalTemp2 = 4;
  stroke(255);
  strokeWeight(1* scaleFactor);
  //float yearStart, yearEnd;
  ProcessTable dataTemp = new ProcessTable("Total_Renewable_Electricity_Net_Generation.tsv");
  int columnCountTemp = dataTemp.getColumnCount();
  int[] yearsTemp = int(dataTemp.getColumnNames());
  int yearMinTemp = yearsTemp[0];
  int yearMaxTemp = yearsTemp[yearsTemp.length-1];
  //yearStart = yearMinTemp;
  //yearEnd = yearMaxTemp;
  for (int column = 0; column < columnCountTemp; column++) {
    if (yearsTemp[column] % yearIntervalTemp1 == 0) {
      float x = map(yearsTemp[column], yearMinTemp, yearMaxTemp, gwPlotX1 + 20 * scaleFactor, gwPlotX2 - 20 * scaleFactor);
      //text(yearsTemp[column], x, gwPlotY2 - 22 * scaleFactor + textAscent());
      //line(x, gwGraphY2, x, gwGraphY2 + 2 * scaleFactor);
      if (mousePressed) {
        if (mouseX > x-5 && mouseX < x+5) {
          if (mouseY > gwPlotY2 - 30 * scaleFactor - 5 && mouseY < gwPlotY2 - 30 * scaleFactor + 5) {
            float test = map(x, gwPlotX1 + 20 * scaleFactor, gwPlotX2 - 20 * scaleFactor, yearMinTemp, yearMaxTemp);
            if (test == yearsTemp[column]) {
              
              colStart = column;
              yearStart = int(test);
              yearMin = yearStart;
            }
          }
          if (mouseY > gwPlotY2 - 45 * scaleFactor - 5 && mouseY < gwPlotY2 - 45 * scaleFactor + 5) {
            float test2 = map(x, gwPlotX1 + 20 * scaleFactor, gwPlotX2 - 20 * scaleFactor, yearMinTemp, yearMaxTemp);
            if (test2 == yearsTemp[column]) {

              colEnd = column;
              yearEnd = int(test2);
              yearMax = yearEnd;
            }
          }
        }
      } 


      if (colStart > colEnd) {
        int tempYear = yearStart;
        yearStart = yearEnd;
        yearEnd = tempYear;
      }

      if (colStart == colEnd) {
        oneYear = true;
      }

      //println(data.getColName(colEnd));
      textSize(7 * scaleFactor);
      textAlign(CENTER, CENTER);
      stroke(0, 0, 0, 100);
      fill(0, 0, 0, 100);
      text("Select year range from : ", gwPlotX2 - (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 25 * scaleFactor);
      text(yearStart, gwPlotX2 - (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 38 * scaleFactor);
      text("to : ", gwPlotX2 - (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 51 * scaleFactor);
      text(yearEnd, gwPlotX2 - (gwPlotX2-gwPlotX1)/2, gwPlotY1 + 64 * scaleFactor);
    }
  }
  for (int column = 0; column < columnCountTemp; column++) {
    if (yearsTemp[column] % yearIntervalTemp2 == 0) {
      float x = map(yearsTemp[column], yearMinTemp, yearMaxTemp, gwPlotX1 + 20 * scaleFactor, gwPlotX2 - 20 * scaleFactor);
      textSize(7 * scaleFactor);
      fill(0);
      textAlign(CENTER, TOP);
      stroke(0);
      text(yearsTemp[column], x, gwPlotY2 - 25 * scaleFactor + textAscent());
      line(x, gwPlotY2 - 23 * scaleFactor, x, gwPlotY2 - 25 * scaleFactor);
      textAlign(CENTER, BOTTOM);
      text(yearsTemp[column], x, gwPlotY2 - 57 * scaleFactor + textAscent());
      line(x, gwPlotY2 - 51 * scaleFactor, x, gwPlotY2 - 53 * scaleFactor);
    }
  }
}


void drawUnitLabels() {
  fill(255);
  textSize(6*scaleFactor);
  textAlign(RIGHT);

  noStroke();

  for (float v = dataMin; v <= dataMax; v += unitIntervalMinor) {
    if (v % unitIntervalMinor == 0) {
      float y = map(v, dataMin, dataMax, gwGraphY2, gwGraphY1);
      if (v % unitInterval == 0) {
        float textOffset = textAscent()/2;
        if (y == dataMin) {
          textOffset = 0;
        }
        else if (v == dataMax) {
          textOffset = textAscent();
        }
        if (selectMap == true) {
          fill(0);
        } 
        textAlign(RIGHT);
        text(floor(v), gwGraphX1 - 20 * scaleFactor, y + textOffset);
        textAlign(LEFT);
        text(floor(v), gwGraphX2 + 20 * scaleFactor, y + textOffset);

        float linePlotX1 = gwGraphX1 - 5 * scaleFactor;
        float linePlotX2 = gwGraphX2 + 10 * scaleFactor;
        //line(linePlotX1, dataMin, linePlotX2, dataMin);
        stroke(200, 200, 200, 100);
        if (selectMap == true) {
          stroke(0,0,0,100);
        }
        for (int count = 0; (linePlotX1 + count + 2) <= (linePlotX2); count += 10) {
          line(linePlotX1 + count, y, linePlotX1 + count + 4, y);
        }
      }
      // else {
      //line(gwGraphX1 - 2,y, gwGraphX1, y);
      //}
    }
  }
}

void drawDataHighlight(int row, int colStart, int colEnd) {
  int columnCount = data.getColumnCount();
  //yearMax = colEnd;
  //yearMin = colStart;
  for (int column = colStart; column <= colEnd; column++) {
    if (data.isValid(row, column)) {
      float value = data.getFloat(row, column);
      //yearMax = years[colEnd-1];
      //yearMin = years[colStart];
      float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
      float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
      if (dist(mouseX, mouseY, x, y) < 2 * scaleFactor || dist(mouseX, mouseY, x, gwGraphY2) < 2 * scaleFactor) {
        //strokeWeight(5 * scaleFactor);
        point(x, y);
        fill(255);
        if (selectMap == true) {
          fill(0);
        }
        textSize(7 * scaleFactor);
        textAlign(RIGHT);
        text(nf(value, 0, 2) + " (" + years[column] + ")", gwPlotX2 - 5 * scaleFactor, gwPlotY2 - 5 * scaleFactor);
        textAlign(LEFT);
        text(nf(value, 0, 2) + " (" + years[column] + ")", gwPlotX1 + 5 * scaleFactor, gwPlotY2 - 5 * scaleFactor);
        //text(nf(value,0,2) + " (" + years[column] + ")", x, y - 8*scaleFactor);
        textAlign(LEFT);
      }
    }
  }
}
//
//void drawPieChart(int row, int columnStart, int columnEnd) {
//  float diameter;
//  
//}

float barWidth = 4 * scaleFactor;
void drawDataBars(int row, int columnStart, int columnEnd) {
  rectMode(CORNERS);
  fill(32, 128, 192, 150);
  if (selectMap == true) {
    fill(50,120,250,180);
  }
  noStroke();
  for (int column = columnStart; column <= columnEnd; column++) {
    if (data.isValid(row, column)) {
      float value = data.getFloat(row, column);
      //yearMax = years[columnEnd-1];
      //yearMin = years[columnStart];
      float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
      float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
      rect(x-barWidth/2, y, x+barWidth/2, gwGraphY2);
    }
  }
}

void drawDataPoints(int row, int columnStart, int columnEnd, int colorSelect) {
  fill(colorSelect);
  noStroke();
  for (int column = columnStart; column <= columnEnd; column++) {
    if (data.isValid(row, column)) {
      float value = data.getFloat(row, column);
      float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
      float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
      point(x, y);
    }
  }
}

void drawDataCurve(int row, int columnStart, int columnEnd, int colorSelect) {
  beginShape();
  noFill();
  stroke(colorSelect);
  strokeWeight(1 * scaleFactor);
  for (int column = columnStart; column <= columnEnd; column++) {
    if (data.isValid(row, column)) {
      float value = data.getFloat(row, column);
      float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
      float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
      curveVertex(x, y);
      if ((column == columnStart) || (column == columnEnd -1)) {
        curveVertex(x, y);
      }
    }
  }
  endShape();
}


void drawDataArea(int row, int columnStart, int columnEnd) {

  // area plot for production

  int columnCount = data.getColumnCount();
  if (data2.getRowMax(row) > data.getRowMax(row)) {
    beginShape();
    fill(32, 128, 192, 190);
    noStroke();
    for (int column = columnStart; column <= columnEnd; column++) {
      if (data2.isValid(row, column)) {

        float value = data2.getFloat(row, column);
        float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
        float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
        curveVertex(x, y);
        if ((column == columnStart) || (column == columnEnd -1)) {
          curveVertex(x, y);
        }
      }
    }
    float colEndMap = map(years[colEnd-1], yearMin, yearMax, gwGraphX1, gwGraphX2);
    float colStartMap = map(years[colStart], yearMin, yearMax, gwGraphX1, gwGraphX2);
    vertex(colEndMap, gwGraphY2);
    vertex(colStartMap, gwGraphY2);
    endShape(CLOSE);
    textSize(7 * scaleFactor);
    textAlign(LEFT, CENTER);
    text("Total Energy Consumption", gwPlotX1 + 5 * scaleFactor, gwPlotY2 - 15 * scaleFactor);
    // area plot for consumption
    beginShape();
    fill(230, 128, 128, 190);
    noStroke();
    for (int column = columnStart; column <= columnEnd; column++) {
      if (data.isValid(row, column)) {

        float value = data.getFloat(row, column);
        float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
        float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
        curveVertex(x, y);
        if ((column == columnStart) || (column == columnEnd - 1)) {
          curveVertex(x, y);
        }
      }
    }
    vertex(colEndMap, gwGraphY2);
    vertex(colStartMap, gwGraphY2);
    endShape(CLOSE);

    textSize(7 * scaleFactor);
    textAlign(RIGHT, CENTER);
    text("Total Energy Production", gwPlotX2 - 5 * scaleFactor, gwPlotY2 - 15 * scaleFactor);
  }
  else {

    beginShape();
    fill(230, 128, 128, 190);
    noStroke();
    for (int column = columnStart; column <= columnEnd; column++) {
      if (data.isValid(row, column)) {

        float value = data.getFloat(row, column);
        float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
        float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
        curveVertex(x, y);
        if ((column == columnStart) || (column == columnEnd - 1)) {
          curveVertex(x, y);
        }
      }
    }
    float colEndMap = map(years[colEnd-1], yearMin, yearMax, gwGraphX1, gwGraphX2);
    float colStartMap = map(years[colStart], yearMin, yearMax, gwGraphX1, gwGraphX2);
    vertex(colEndMap, gwGraphY2);
    vertex(colStartMap, gwGraphY2);
    endShape(CLOSE);

    textSize(7 * scaleFactor);
    textAlign(RIGHT, CENTER);
    text("Total Energy Production", gwPlotX2 - 5 * scaleFactor, gwPlotY2 - 15 * scaleFactor);


    beginShape();
    fill(32, 128, 192, 190);
    noStroke();
    for (int column = columnStart; column <= columnEnd; column++) {
      if (data2.isValid(row, column)) {

        float value = data2.getFloat(row, column);
        float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
        float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
        curveVertex(x, y);
        if ((column == columnStart) || (column == columnEnd -1)) {
          curveVertex(x, y);
        }
      }
    }

    vertex(colEndMap, gwGraphY2);
    vertex(colStartMap, gwGraphY2);
    endShape(CLOSE);
    textSize(7 * scaleFactor);
    textAlign(LEFT, CENTER);
    text("Total Energy Consumption", gwPlotX1 + 5 * scaleFactor, gwPlotY2 - 15 * scaleFactor);
  }  

  // mouse over for production and consumption
  for (int column = columnStart; column <= columnEnd; column++) {
    if (data.isValid(row, column)) {
      float value = data.getFloat(row, column);
      float value2 = data2.getFloat(row, column);
      float x = map(years[column], yearMin, yearMax, gwGraphX1, gwGraphX2);
      float y = map(value, dataMin, dataMax, gwGraphY2, gwGraphY1);
      float y2  = map(value2, dataMin, dataMax, gwGraphY2, gwGraphY1);
      if (dist(mouseX, mouseY, x, y) < 2 * scaleFactor || dist(mouseX, mouseY, x, y2) < 2 * scaleFactor) {
        //strokeWeight(5 * scaleFactor);
        point(x, y);
        fill(230, 128, 128, 190);
        textSize(7 * scaleFactor);
        textAlign(RIGHT);
        text(nf(value, 0, 2) + " (" + years[column] + ")", gwPlotX2 - 5 * scaleFactor, gwPlotY2 - 5 * scaleFactor);
        //text(nf(value,0,2) + " (" + years[column] + ")", x, y - 8*scaleFactor);
        textAlign(LEFT);

        fill(32, 128, 192, 190);
        textSize(7 * scaleFactor);
        textAlign(LEFT);
        text(nf(value2, 0, 2) + " (" + years[column] + ")", gwPlotX1 + 5 * scaleFactor, gwPlotY2 - 5 * scaleFactor);
        //text(nf(value,0,2) + " (" + years[column] + ")", x, y - 8*scaleFactor);
        textAlign(LEFT);
      }
    }
  }

  // %age plot
  barWidth = 1.5 * scaleFactor;
  rectMode(CORNERS);
  float minValueX = twPlotX1 + 25 *scaleFactor;
  float maxValueX = twPlotX2 - 25 * scaleFactor;
  float minValueY = twPlotY1 + 20 * scaleFactor;
  float maxValueY = twPlotY2 - 20 * scaleFactor;
  fill(255); 
  if (selectMap == true) {
      fill(0);
  }
  textSize(7*scaleFactor); 
  textAlign(LEFT);
  //String title = data.getRowName(currentRow); 
  text(dataBaseName + " percentage\nrelative to World", twPlotX1+ 5 *scaleFactor, gwPlotY1 + 7 * scaleFactor); 

  //
  for (int column = columnStart; column <= columnEnd; column++) {
    if (data2.isValid(row, column)) {
      float worldValue = data2.getFloat(worldRow, column);
      float value = data2.getFloat(row, column);
      value = value / worldValue * 100;
      float x = map(value, 0, 100, minValueX, maxValueX);
      float y = map(years[column], yearMin, yearMax, maxValueY, minValueY);
      noStroke();
      float plotX1 = twPlotX1 + 25 * scaleFactor;
      float plotX2 = twPlotX2 - 25 * scaleFactor;
      fill(#A2A212,150);
      textSize(6*scaleFactor); 
      textAlign(RIGHT); 
      text("World", twPlotX2 - 5 * scaleFactor, twPlotY2 - 5 * scaleFactor);
      rect(plotX1, y - barWidth, plotX2, y+barWidth);
      textAlign(RIGHT, CENTER);
      text("100%", twPlotX2 - 5 * scaleFactor, map(years[columnStart], yearMin, yearMax, maxValueY, minValueY));

      fill(#A14343, 200);
      rect( plotX1, y - barWidth, x, y + barWidth);
      textSize(6*scaleFactor); 
      textAlign(LEFT);
      String title = data2.getRowName(currentRow); 
      text(title + " : Energy Consumption", twPlotX1 + 5 * scaleFactor, twPlotY2 - 8 * scaleFactor);

      if (dist(mouseX, mouseY, x, y) < 4) {
        //strokeWeight(5 * scaleFactor);
        point(x, y);
        fill(#A14343, 200);
        textSize(6 * scaleFactor);
        textAlign(LEFT);
        text(title + " : Energy Consumption - " + nf(value, 0, 4) + "% (" + years[column] + ")", twPlotX1 + 5 * scaleFactor, twPlotY2 - 8 * scaleFactor);
        //text(nf(value, 0, 4) + "% (" + years[column] + ")", twPlotX2 - 5 * scaleFactor, twPlotY1 + 15 * scaleFactor);
        //text(nf(value,0,2) + " (" + years[column] + ")", x, y - 8*scaleFactor);
        textAlign(LEFT);
      }
      fill(255);
      textSize(5*scaleFactor);
      textAlign(LEFT, CENTER);
      yearInterval = 2;
      if (years[column] % yearInterval == 0) {
        y = map(years[column], yearMin, yearMax, maxValueY, minValueY);
        text(years[column], twPlotX1 + 8 * scaleFactor, y);
        //rect(twPlotX1 + 5 *scalrFactor , y, x, y);
        //line(x, gwGraphY2, x, gwGraphY2 + 2 * scaleFactor);
      }
    }
  }


  for (int column = columnStart; column <= columnEnd; column++) {
    if (data.isValid(row, column)) {
      float worldValue = data.getFloat(worldRow, column);
      float value = data.getFloat(row, column);
      value = value / worldValue * 100;
      float x = map(value, 0, 100, minValueX, maxValueX);
      float y = map(years[column], yearMin, yearMax, maxValueY, minValueY);
      noStroke();
      float plotX1 = twPlotX1 + 25 * scaleFactor;
      float plotX2 = twPlotX2 - 25 * scaleFactor;
      fill(#5143A1, 200);
      rect( plotX1, y - barWidth, x, y + barWidth);
      textSize(6*scaleFactor); 
      fill(#5143A1, 200);
      textAlign(LEFT);
      String title = data.getRowName(currentRow); 
      text(title + " : Energy Production", twPlotX1 + 5 * scaleFactor, twPlotY2 - 3 * scaleFactor);

      if (dist(mouseX, mouseY, x, y) < 4) {
        //strokeWeight(5 * scaleFactor);
        point(x, y);
        fill(255);
        noStroke();
        //textSize(7 * scaleFactor);
        //textAlign(RIGHT);
        textSize(6*scaleFactor); 
        fill(#5143A1, 200);
        textAlign(LEFT);
        text(title + " : Energy Production - " + nf(value, 0, 4) + "% (" + years[column] + ")", twPlotX1 + 5 * scaleFactor, twPlotY2 - 3 * scaleFactor);
        //text(nf(value, 0, 4) + "% (" + years[column] + ")", twPlotX2 - 5 * scaleFactor, twPlotY1 + 15 * scaleFactor);
        //text(nf(value,0,2) + " (" + years[column] + ")", x, y - 8*scaleFactor);
        textAlign(LEFT);
      }
      fill(255);
      if (selectMap == true) {
        fill(0);
      }
      textSize(5*scaleFactor);
      textAlign(LEFT, CENTER);
      yearInterval = 2;
      if (years[column] % yearInterval == 0) {
        y = map(years[column], yearMin, yearMax, maxValueY, minValueY);
        text(years[column], twPlotX1 + 8 * scaleFactor, y);
        //rect(twPlotX1 + 5 *scalrFactor , y, x, y);
        //line(x, gwGraphY2, x, gwGraphY2 + 2 * scaleFactor);
      }
    }
  }
}



void drawDataRelateWorld(int row, int columnStart, int columnEnd) {
  if (totalButton == true) {
    barWidth = 1.5  * scaleFactor;
    rectMode(CORNERS);
    float minValueX = twPlotX1 + 25 *scaleFactor;
    float maxValueX = twPlotX2 - 25 * scaleFactor;
    float minValueY = twPlotY1 + 20 * scaleFactor;
    float maxValueY = twPlotY2 - 20 * scaleFactor;
    fill(255); 
    if (selectMap == true) {
      fill(0);
    }
    textSize(7*scaleFactor); 
    textAlign(LEFT);
    //String title = data.getRowName(currentRow); 
    text(dataBaseName + " percentage\nrelative to World", twPlotX1+ 5 *scaleFactor, gwPlotY1 + 7 * scaleFactor); 
   
    for (int column = columnStart; column <= columnEnd; column++) {
      if (data.isValid(row, column)) {
        float worldValue = data.getFloat(worldRow, column);
        float value = data.getFloat(row, column);
        value = value / worldValue * 100;
        float x = map(value, 0, 100, minValueX, maxValueX);
        float y = map(years[column], yearMin, yearMax, maxValueY, minValueY);
        noStroke();
        float plotX1 = twPlotX1 + 25 * scaleFactor;
        float plotX2 = twPlotX2 - 25 * scaleFactor;
        fill(#91A212);
        textSize(8*scaleFactor); 
        textAlign(RIGHT); 
        text("World", twPlotX2 - 5 * scaleFactor, twPlotY2 - 5 * scaleFactor); 
        rect(plotX1, y - barWidth, plotX2, y+barWidth);
        textAlign(RIGHT, CENTER);
        textSize(6*scaleFactor);
        text("100%", twPlotX2 - 5 * scaleFactor, map(years[columnStart], yearMin, yearMax, maxValueY, minValueY));
        fill(#5143A1, 200);
        
        rect( plotX1, y - barWidth, x, y + barWidth);
        textSize(8*scaleFactor); 
        textAlign(LEFT);
        String title = data.getRowName(currentRow); 
        text(title, twPlotX1 + 5 * scaleFactor, twPlotY2 - 5 * scaleFactor);

        if (dist(mouseX, mouseY, x, y) < 4) {
          //strokeWeight(5 * scaleFactor);
          point(x, y);
          fill(255);
          if (selectMap == true) {
            fill(0);
          }
          textSize(7 * scaleFactor);
          textAlign(RIGHT);
          text(nf(value, 0, 4) + "% (" + years[column] + ")", twPlotX2 - 5 * scaleFactor, twPlotY1 + 15 * scaleFactor);
          //text(nf(value,0,2) + " (" + years[column] + ")", x, y - 8*scaleFactor);
          textAlign(LEFT);
        }
        fill(255);
        if (selectMap == true) {
          fill(0);
        }
        textSize(5*scaleFactor);
        textAlign(LEFT, CENTER);
        yearInterval = 2;
        if (years[column] % yearInterval == 0) {
          y = map(years[column], yearMin, yearMax, maxValueY, minValueY);
          text(years[column], twPlotX1 + 8 * scaleFactor, y);
          //rect(twPlotX1 + 5 *scalrFactor , y, x, y);
          //line(x, gwGraphY2, x, gwGraphY2 + 2 * scaleFactor);
        }
      }
    }
  }
}


void pressTotalButton(int val) {
  if (val == 1) {
    totalButton = true;
    fill(#41ffC1);
    textSize(7*scaleFactor);
    text("Totals", totalButtonX1 + (totalButtonX2-totalButtonX1)/2, totalButtonY1+(totalButtonY2-totalButtonY1)/2);
    if (energyConsumption || co2Emissions) {
      pressPerCapitaButton(0);
    }
    else {
      pressPerCapitaButton(-1);
    }
  }
  else if (val == 0) {
    totalButton = false;
    fill(170);
    textSize(7*scaleFactor);
    text("Totals", totalButtonX1 + (totalButtonX2-totalButtonX1)/2, totalButtonY1+(totalButtonY2-totalButtonY1)/2);
  }
  else if (val == -1) {
    totalButton = false;
    fill(30);
    textSize(7*scaleFactor);
    text("Totals", totalButtonX1 + (totalButtonX2-totalButtonX1)/2, totalButtonY1+(totalButtonY2-totalButtonY1)/2);
  }
}

void pressPerCapitaButton(int val) {
  if (val == 1) {
    perCapitaButton = true;
    fill(#41ffC1);
    textSize(7*scaleFactor);
    text("PerCapita", perCapitaButtonX1 + (perCapitaButtonX2-perCapitaButtonX1)/2, totalButtonY1+(totalButtonY2-totalButtonY1)/2);
    pressTotalButton(0);
  }
  else if (val == 0) {
    perCapitaButton = false;
    fill(170);
    textSize(7*scaleFactor);
    text("PerCapita", perCapitaButtonX1 + (perCapitaButtonX2-perCapitaButtonX1)/2, totalButtonY1+(totalButtonY2-totalButtonY1)/2);
  }
  else if (val == -1) {
    perCapitaButton = false;
    fill(30);
    textSize(7*scaleFactor);
    text("PerCapita", perCapitaButtonX1 + (perCapitaButtonX2-perCapitaButtonX1)/2, totalButtonY1+(totalButtonY2-totalButtonY1)/2);
  }
}

void selectEnergyProduction() {
  println("// Energy Production epButton pressed");
  energyProduction = true;
  energyConsumption = false;
  //energyConsumptionPerCapita = false;
  co2Emissions = false;
  //co2EmissionsPerCapita = false;
  renewableEnergyGeneration = false;
  compareDataSet = false;
  displayStartScreen = true;
}

void selectEnergyConsumption() {
  println("// Energy Consumption Button Pressed");
  energyProduction = false;
  energyConsumption = true;
  //energyConsumptionPerCapita = false;
  co2Emissions = false;
  //co2EmissionsPerCapita = false;
  renewableEnergyGeneration = false;
  compareDataSet = false;
  displayStartScreen = true;
}

void selectPerCapitaEnergyConsumption() {
  println("// Energy Consumption Button Pressed");
  energyProduction = false;
  energyConsumption = false;
  //energyConsumptionPerCapita = true;
  co2Emissions = false;
  //co2EmissionsPerCapita = false;
  renewableEnergyGeneration = false;
  compareDataSet = false;
  displayStartScreen = true;
}

void selectCo2Emissions() {
  println("// co2 Emission button pressed");
  energyProduction = false;
  energyConsumption = false;
  //energyConsumptionPerCapita = false;
  co2Emissions = true;
  //co2EmissionsPerCapita = false;
  renewableEnergyGeneration = false;
  compareDataSet = false;
  displayStartScreen = true;
}

void selectPerCapitaCo2Emissions() {
  println("// co2 Emission button pressed");
  energyProduction = false;
  energyConsumption = false;
  //energyConsumptionPerCapita = false;
  co2Emissions = false;
  //co2EmissionsPerCapita = true;
  renewableEnergyGeneration = false;
  compareDataSet = false;
  displayStartScreen = true;
}

void selectRenewableElectricityGeneration() {
  println("// renewable energy generation button pressed");
  energyProduction = false;
  energyConsumption = false;
  //energyConsumptionPerCapita = false;
  co2Emissions = false;
  //co2EmissionsPerCapita = false;
  renewableEnergyGeneration = true;
  compareDataSet = false;
  displayStartScreen = true;
}

void updateRegionName(char tempKey, int var) {
  if (var == 1) {
    regionName = regionName + tempKey;
  }
  else {
    regionName = new String(regionNameChar, 0, regionName.length()-1);
  }
}


void displayHelp() {
  if (helpButton == false) {
    helpButton = true;
    compareDataSet = false;
    setTextBox = false;
    clearGraphArea();
  }
  else {
    helpButton = false;
    if (totalButton == true || perCapitaButton == true) {
      check = 1;
    }
  }
}

void autoComplete () { 
  data = new ProcessTable("Total_Primary_Energy_Production.tsv");
  String[] rowNames = new String[100];
  rowNames = data.getRowNames();
  for (int i = 0; i<data.getRowCount() ; i++) {
    if (regionName.length() == 0) {
      autoString = "";
    }
    else if ((rowNames[i].toUpperCase()).startsWith(regionName.toUpperCase()) == true) {
      autoString = rowNames[i].substring(regionName.length());
    }
  }
}


void compareDataSetFunc() {
  if (compareDataSet == false) {
    clearGraphArea();
    compareDataSet = true;
    selectDataBase();
    energyProduction = false;
    energyConsumption = false;
    totalButton = false;
    co2Emissions = false;
    renewableEnergyGeneration = false;
    //setTextBox = true;
    displayStartScreen = false;
  }
  else {
    clearGraphArea();
    compareDataSet = false;
    energyProduction = false;
    energyConsumption = false;
    totalButton = false;
    co2Emissions = false;
    renewableEnergyGeneration = false;
    setTextBox = false;
    displayStartScreen = true;
  }
  
}

void yearRangeFunc() {
  if (yearRange == true) {
    fill(0);
    rect(gwPlotX1, gwPlotY1, gwPlotX2, gwPlotY2);
    rect(twPlotX1, twPlotY1, twPlotX2, twPlotY2);
    yearRange = false;
  }
  else {
    selectMap = false;
    yearRange = true;
  }
}

void compareRegionFunc() {
  if (compareRegions == true) {
    clearGraphArea();
    compareRegions = false;
  }
  else {
    //selectedRegions = null;
    regionCount = 0;
    compareRegions = true;
    regionName = "";
    // clearGraphArea();
    setTextBox = true;
    helpButton = false;
    typedCount = 0;
    clearGraph = false;
    displayStartScreen = false;
    compareDataSet = false;
    data = new ProcessTable("Total_Primary_Energy_Production.tsv");
  }
}



void keyPressed() {
  if (key == '[') {
    currentRow--;
    if (currentRow < 0) {
      currentRow = rowCount - 1;
    }

    selectDataBase();
  }
  else if (key == ']') {
    currentRow++;
    if (currentRow == rowCount) {
      currentRow = 0;
    }

    selectDataBase();
  }

  if (setTextBox == true) {
    if ((key >= 'a' && key <= 'z') || (key >= 'A' && key <= 'Z') || key == ' ' || key == ',' || key == '.' || (key >= '0' && key <= '9')) {
      regionNameChar[typedCount++] = key; 
      updateRegionName(regionNameChar[typedCount-1], 1);
      autoComplete();
    }
    if (key == BACKSPACE || key == DELETE) {
      if (typedCount > 0 ) {
        typedCount--;
        updateRegionName(key, 0);
        autoComplete();
      }
    }
    if (key == ENTER || key == RETURN) {
      regionName = regionName + autoString;
      //println(regionName);
      selectedRegions[regionCount++] = regionName;
      regionName = "";
      autoString = "";
      clearGraphArea();
      clearGraph = true;
      if (compareRegions == false) {
        setTextBox = false;
      }
      if (totalButton == true || perCapitaButton == true) {
        check = 1;
        selectDataBase();
      }
      else {
      }
    }
  }
}




void mousePressed() {
  if (mouseX > epButtonX1 && mouseX < epButtonX2) {
    if (mouseY > epButtonY1 && mouseY < epButtonY2) {
      // Energy Production epButton pressed
      selectEnergyProduction();
      totalButton = false;
      perCapitaButton = false;
      setTextBox = false;
      clearGraphArea();
    }
    else if (mouseY > ecButtonY1 && mouseY < ecButtonY2) {
      // Energy Consumption Button Pressed
      selectEnergyConsumption();
      totalButton = false;
      perCapitaButton = false;
      setTextBox = false;
      clearGraphArea();
    }
    else if (mouseY > co2ButtonY1 && mouseY < co2ButtonY2) {
      // co2 Emission button pressed
      selectCo2Emissions();
      totalButton = false;
      perCapitaButton = false;
      setTextBox = false;
      clearGraphArea();
    }
    else if (mouseY > regButtonY1 && mouseY < regButtonY2) {
      // renewable energy generation button pressed
      selectRenewableElectricityGeneration();
      totalButton = false;
      setTextBox = false;
      perCapitaButton = false;
      clearGraphArea();
    }
  }

  // entireRangeButton
  if (yearRange == true) {
    if (mouseX > entireRangeX1 - entireRangeWidth && mouseY < entireRangeX1 + entireRangeWidth) {
      if (mouseY > entireRangeY1 - entireRangeHeight && mouseY < entireRangeY1 + entireRangeHeight) {
      
        colStart = 0;
        colEnd = 30;
        yearMin = yearStart = 1980;
        yearMax = yearEnd = 2009;
        yearRange = false;
      }
    }
    
    if (mouseX > year1DecX1 - yearWidth && mouseX < year1DecX1 + yearWidth) {
      if (mouseY > year1DecY1 - yearHeight && mouseY < year1DecY1 + yearHeight) {
        if (yearStart > 1980) {
          yearStart--;
          yearMin--;
          colStart--;
        } 
      }
    }
      
     if (mouseX > year1IncX1 - yearWidth && mouseX < year1IncX1 + yearWidth) {
      if (mouseY > year1IncY1 - yearHeight && mouseY < year1IncY1 + yearHeight) {
        if (yearStart < 2009) {
          yearStart++;
          yearMin++;
          colStart++;
        } 
      }
    }
    
     if (mouseX > year2DecX1 - yearWidth && mouseX < year2DecX1 + yearWidth) {
      if (mouseY > year2DecY1 - yearHeight && mouseY < year2DecY1 + yearHeight) {
        if (yearEnd > 1980) {
          yearEnd--;
          yearMax--;
          colEnd--;
        } 
      }
     }
      
     if (mouseX > year2IncX1 - yearWidth && mouseX < year2IncX1 + yearWidth) {
      if (mouseY > year2IncY1 - yearHeight && mouseY < year2IncY1 + yearHeight) {
        if (yearEnd < 2009) {
          yearEnd++;
          yearMax++;
          colEnd++;
        } 
      }
    }
  }
  
 

  // total button 
  if (mouseY > totalButtonY1 && mouseY < totalButtonY2) {
    if (mouseX > totalButtonX1 && mouseX < totalButtonX2) {
      setTextBox = false;
      helpButton = false;
      pressTotalButton(1);
      pressPerCapitaButton(-1);
      displayStartScreen = false;
      if (energyConsumption || co2Emissions) {
        pressPerCapitaButton(0);
      }
      selectDataBase();
    }

    // per capita button
    else if (mouseX > perCapitaButtonX1 && mouseX < perCapitaButtonX2) {
      setTextBox = false;
      helpButton = false;
      pressTotalButton(0);
      displayStartScreen = false;
      pressPerCapitaButton(1);
      selectDataBase();
    }
  }

  // click to enter region button
  if (mouseX > textBoxX1 && mouseX < textBoxX2) {
    if (mouseY > textBoxY1 && mouseY < textBoxY2) {
      regionName = "";
      // clearGraphArea();
      setTextBox = true;
      helpButton = false;
      typedCount = 0;
      clearGraph = false;
      displayStartScreen = false;
      compareDataSet = false;
    }
  }

  // back button
  if (mouseX > backButtonX1 && mouseX < backButtonX2) {
    if (mouseY > backButtonY1 && mouseY < backButtonY2) {
      if (setTextBox == true || helpButton == true) {
        clearGraphArea();
        setTextBox = false;
        helpButton = false;
        clearGraph = true;
        regionName = "";
        if (totalButton == true || perCapitaButton == true) {
          check = 1;
        }
      }
    }
  }       


  // Ok Button
  if (mouseX > textFieldOkX1 && mouseX < textFieldOkX2) {
    if (mouseY > textFieldOkY1 && mouseY < textFieldOkY2) {
      if (setTextBox == true) {
        //selectedRegions[regionCount++] = regionName;
        //regionName = "";
        clearGraphArea();
        clearGraph = true;
        setTextBox = false;
        if (totalButton == true || perCapitaButton == true) {
          check = 1;
          //selectDataBase();
        }
      }
    }
  }
  // help button
  if (mouseX > helpButtonX1 && mouseX < helpButtonX2) {
    if (mouseY > helpButtonY1 && mouseY < helpButtonY2) {
      //helpButton = true;
      compareDataSet = false;
      setTextBox = false;
      displayHelp();
      displayStartScreen = false;
    }
  }

  // compareDataSet button
  if (mouseX > compareDataSetX1 && mouseX < compareDataSetX2) {
    if (mouseY > compareDataSetY1 && mouseY < compareDataSetY2) {
      compareDataSetFunc();
    }
  }

  // yearRange Button
  if (mouseX > yearRangeButtonX1 && mouseX < yearRangeButtonX2) {
    if (mouseY > yearRangeButtonY1 && mouseY < yearRangeButtonY2) {
      yearRangeFunc();
    }
  }
  

  // commpare region
  if (mouseX > compareRegionsX1 && mouseX < compareRegionsX2) {
    if (mouseY > compareRegionsY1 && mouseY < compareRegionsY2) {
      compareRegionFunc();
    }
  }


  if (setTextBox == true) {
    if (selectMap == true) {
      for (int i=0; i<3; i++) {
        for (int j=0; j<10; j++) {
          if (mouseX > (gwPlotX1 + 8*scaleFactor + (j*10) * scaleFactor + i * 8 * scaleFactor)-5 * scaleFactor && mouseX < (gwPlotX1 + 8*scaleFactor + (j*10) * scaleFactor + i * 8 * scaleFactor)+5 * scaleFactor) {
            if (mouseY > (gwPlotY2 - 70 * scaleFactor + i * 12 * scaleFactor)-5 * scaleFactor && mouseY < (gwPlotY2 - 70 * scaleFactor + i * 12 * scaleFactor)+5 * scaleFactor) {
              regionNameChar[typedCount++] = keyboardLayout[i][j]; 
              updateRegionName(regionNameChar[typedCount-1], 1);
              autoComplete();
            }
          }
        }
      }
    }
    else {
      for (int i=0; i<3; i++) {
        for (int j=0; j<10; j++) {
          if (mouseX > (gwPlotX1 + (50+j*10) * scaleFactor + j * 8 * scaleFactor + i * 8 * scaleFactor)-5 * scaleFactor && mouseX < (gwPlotX1 + (50+j*10) * scaleFactor + j * 8 * scaleFactor + i * 8 * scaleFactor)+5 * scaleFactor) {
            if (mouseY > (gwPlotY2 - 45 * scaleFactor + i * 12 * scaleFactor)-5 * scaleFactor && mouseY < (gwPlotY2 - 45 * scaleFactor + i * 12 * scaleFactor)+5 * scaleFactor) {
              regionNameChar[typedCount++] = keyboardLayout[i][j]; 
              updateRegionName(regionNameChar[typedCount-1], 1);
              autoComplete();
            }
          }
        }
      }
    }    



    if (mouseX > spacebarX1 - spacebarWidth && mouseX < spacebarX1 + spacebarWidth) {
      if (mouseY > spacebarY1 - spacebarHeight && mouseY < spacebarY1 + spacebarHeight) {
        regionNameChar[typedCount++] = ' '; 
        updateRegionName(regionNameChar[typedCount-1], 1);
        autoComplete();
      }
    }


    if (mouseX > enterX1 - enterWidth && mouseX < enterX1 + enterWidth) {
      if (mouseY > enterY1 - enterHeight && mouseY < enterY1 + enterHeight) {
        regionName = regionName + autoString;
        selectedRegions[regionCount++] = regionName.toLowerCase();
        //println(selectedRegions[regionCount-1] + "##");
        regionName = "";
        autoString = "";
        clearGraphArea();
        clearGraph = true;
        setTextBox = false;
        if (totalButton == true || perCapitaButton == true) {
          check = 1;
          selectDataBase();
        }
        else {
        }
      }
    }

    if (mouseX > backSpaceX1 - backSpaceWidth && mouseX < backSpaceX1 + backSpaceWidth) {
      if (mouseY > backSpaceY1 - backSpaceHeight && mouseY < backSpaceY1 + backSpaceHeight) {
        if (typedCount > 0 ) {
          typedCount--;
          updateRegionName(key, 0);
          autoComplete();
        }
      }
    }
  }
  
  if (mouseX > mapButtonX1 && mouseX < mapButtonX2) {
    if (mouseY > mapButtonY1 && mouseY < mapButtonY2) {
      if (selectMap == true) {
        selectMap = false;
      }
      else {
        displayStartScreen = false;
        //clearGraphArea();
        selectMap = true;
      }
    }
  }
  
  if (selectMap == true) {
    if (mouseX > gwPlotX1 && mouseX < twPlotX2) {
      if (mouseY > gwPlotY1 && mouseY < gwPlotY2) {
        for (int row = 0; row < countryCount; row++) {
          //println(temp.getRowName(row));
          country = worldMap.getChild(temp.getRowName(row).toLowerCase());
//          Xpos = mouseX;
//          Ypos = mouseY;
          if(country!=null){
            if(manageMap.isSelected(country)){
              println(countryName);
              manageMap.selectDeselect(country);
              selectedRegions[regionCount++] = regionName = countryName;
              regionName = "";
              autoString = "";
              clearGraphArea();
              clearGraph = true;
//            if (compareRegions == false) {
//              setTextBox = false;
//            }
              if (totalButton == true || perCapitaButton == true) {
                check = 1;
                selectDataBase();
              }
                    
              
              
              
            }
          }
        }
      }
    }
  }
}

float requestX(){
  //println(mouseX);
  return mouseX;
  //return Xpos;
}

float requestY(){
  return mouseY;
  //return Ypos;
}

float requestTouchX(){
  //println(mouseX);
  //return mouseX;
  return Xpos;
}

float requestTouchY(){
  //return mouseY;
  return Ypos;
}

public void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth) {
  println("Touch at " + xPos + " " + yPos );
  if (xPos > epButtonX1 && xPos < epButtonX2) {
    if (yPos > epButtonY1 && yPos < epButtonY2) {
      // Energy Production epButton pressed
      selectEnergyProduction();
      totalButton = false;
      perCapitaButton = false;
      setTextBox = false;
      clearGraphArea();
    }
    else if (yPos > ecButtonY1 && yPos < ecButtonY2) {
      selectEnergyConsumption();
      totalButton = false;
      perCapitaButton = false;
      setTextBox = false;
      clearGraphArea();
    }
    else if (yPos > co2ButtonY1 && yPos < co2ButtonY2) {
      // co2 Emission button pressed
      selectCo2Emissions();
      totalButton = false;
      perCapitaButton = false;
      setTextBox = false;
      clearGraphArea();
    }
    else if (yPos > regButtonY1 && yPos < regButtonY2) {
      // renewable energy generation button pressed
      selectRenewableElectricityGeneration();
      totalButton = false;
      perCapitaButton = false;
      setTextBox = false;
      clearGraphArea();
    }
  }

  // entireRangeButton
  if (xPos > entireRangeX1 - entireRangeWidth && yPos < entireRangeX1 + entireRangeWidth) {
    if (yPos > entireRangeY1 - entireRangeHeight && yPos < entireRangeY1 + entireRangeHeight) {
      if (yearRange == true) {
        colStart = 0;
        colEnd = 30;
        yearStart = 1980;
        yearEnd = 2009;
        yearRange = false;
      }
    }
  }

  // total button
  if (yPos > totalButtonY1 && yPos < totalButtonY2) {
    if (xPos > totalButtonX1 && xPos < totalButtonX2) {
      setTextBox = false;
      helpButton = false;
      pressTotalButton(1);
      displayStartScreen = false;
      pressPerCapitaButton(-1);
      if (energyConsumption || co2Emissions) {
        pressPerCapitaButton(0);
      }
      selectDataBase();
    }

    /// per capita button
    else if (xPos > perCapitaButtonX1 && xPos < perCapitaButtonX2) {
      setTextBox = false;
      helpButton = false;
      pressTotalButton(0);
      displayStartScreen = false;
      pressPerCapitaButton(1);
      selectDataBase();
    }
  }

  // compare region
  if (xPos > compareRegionsX1 && xPos < compareRegionsX2) {
    if (yPos > compareRegionsY1 && yPos < compareRegionsY2) {
      compareRegionFunc();
    }
  }

  // click to enter text box
  if (xPos > textBoxX1 && xPos < textBoxX2) {
    if (yPos > textBoxY1 && yPos < textBoxY2) {
      clearGraphArea();
      setTextBox = true;
      typedCount = 0;
      clearGraph = false;
      compareDataSet = false;
      helpButton = false;
    }
  }

  // back button
  if (xPos > backButtonX1 && xPos < backButtonX2) {
    if (yPos > backButtonY1 && yPos < backButtonY2) {
      if (setTextBox == true || helpButton == true) {
        clearGraphArea();
        setTextBox = false;
        helpButton = false;
        clearGraph = true;
        displayStartScreen = false;
        if (totalButton == true || perCapitaButton == true) {
          check = 1;
        }
      }
    }
  }

  // Ok Button
  if (xPos > textFieldOkX1 && xPos < textFieldOkX2) {
    if (yPos > textFieldOkY1 && yPos < textFieldOkY2) {
      if (setTextBox == true) {
        //selectedRegions[regionCount++] = regionName;
        //regionName = "";
        clearGraphArea();
        clearGraph = true;
        setTextBox = false;
        if (totalButton == true || perCapitaButton == true) {
          check = 1;
          //selectDataBase();
        }
      }
    }
  }

  // help Button
  if (xPos > helpButtonX1 && xPos < helpButtonX2) {
    if (yPos > helpButtonY1 && yPos < helpButtonY2) {
      //helpButton = true;
      compareDataSet = false;
      setTextBox = false;
      displayHelp();
    }
  }
  
  // map button
  if (selectMap == true) {
    if (xPos > gwPlotX1 && xPos < twPlotX2) {
      if (yPos > gwPlotY1 && yPos < gwPlotY2) {
      for (int row = 0; row < countryCount; row++) {
          country = worldMap.getChild(temp.getRowName(row).toLowerCase());
           Xpos = xPos;
           Ypos = yPos;
          if(country!=null){
            if(manageMap.isSelectedOMC(country)){
              println("country touch at :"+countryName);
              manageMap.selectDeselect(country);
              selectedRegions[regionCount++] = regionName = countryName;
              regionName = "";
              autoString = "";
              clearGraphArea();
              clearGraph = true;
//            if (compareRegions == false) {
//              setTextBox = false;
//            }
              if (totalButton == true || perCapitaButton == true) {
                check = 1;
                selectDataBase();
              }
                         
            
            }
          }
        }
      }
    }
  }

  // compareDataSet button
  if (xPos > compareDataSetX1 && xPos < compareDataSetX2) {
    if (yPos > compareDataSetY1 && yPos < compareDataSetY2) {
      compareDataSetFunc();
    }
  }

  // yearRange Button
  if (xPos > yearRangeButtonX1 && xPos < yearRangeButtonX2) {
    if (yPos > yearRangeButtonY1 && yPos < yearRangeButtonY2) {
      yearRangeFunc();
    }
  }
  
  if (setTextBox == true) {
    if (selectMap == true) {
      for (int i=0; i<3; i++) {
        for (int j=0; j<10; j++) {
          if (xPos > (gwPlotX1 + 8*scaleFactor + (j*10) * scaleFactor + i * 8 * scaleFactor)-5 * scaleFactor && xPos < (gwPlotX1 + 8*scaleFactor + (j*10) * scaleFactor + i * 8 * scaleFactor)+5 * scaleFactor) {
            if (yPos > (gwPlotY2 - 70 * scaleFactor + i * 12 * scaleFactor)-5 * scaleFactor && yPos < (gwPlotY2 - 70 * scaleFactor + i * 12 * scaleFactor)+5 * scaleFactor) {
              regionNameChar[typedCount++] = keyboardLayout[i][j]; 
              updateRegionName(regionNameChar[typedCount-1], 1);
              autoComplete();
            }
          }
        }
      }
    }
    else {
      for (int i=0; i<3; i++) {
        for (int j=0; j<10; j++) {
          if (xPos > (gwPlotX1 + (50+j*10) * scaleFactor + j * 8 * scaleFactor + i * 8 * scaleFactor)-5 * scaleFactor && yPos < (gwPlotX1 + (50+j*10) * scaleFactor + j * 8 * scaleFactor + i * 8 * scaleFactor)+5 * scaleFactor) {
            if (xPos > (gwPlotY2 - 45 * scaleFactor + i * 12 * scaleFactor)-5 * scaleFactor && yPos < (gwPlotY2 - 45 * scaleFactor + i * 12 * scaleFactor)+5 * scaleFactor) {
              regionNameChar[typedCount++] = keyboardLayout[i][j]; 
              updateRegionName(regionNameChar[typedCount-1], 1);
              autoComplete();
            }
          }
        }
      }
    }
  
  
    if (xPos > spacebarX1 - spacebarWidth && xPos < spacebarX1 + spacebarWidth) {
      if (yPos > spacebarY1 - spacebarHeight && yPos < spacebarY1 + spacebarHeight) {
        regionNameChar[typedCount++] = ' '; 
        updateRegionName(regionNameChar[typedCount-1], 1);
        autoComplete();
      }
    }
    if (xPos > enterX1 - enterWidth && xPos < enterX1 + enterWidth) {
      if (yPos > enterY1 - enterHeight && yPos < enterY1 + enterHeight) {
        regionName = regionName + autoString;
        selectedRegions[regionCount++] = regionName.toLowerCase();
        //println(selectedRegions[regionCount-1] + "##");
        regionName = "";
        autoString = "";
        clearGraphArea();
        clearGraph = true;
        setTextBox = false;
        if (totalButton == true || perCapitaButton == true) {
          check = 1;
          selectDataBase();
        }
        else {
        }
      }
    }

    if (xPos > mapButtonX1 && xPos < mapButtonX2) {
      if (yPos > mapButtonY1 && yPos < mapButtonY2) {
        if (selectMap == false) {
          selectMap = true;
          clearGraphArea();
          displayStartScreen = false;
        }
        else {
          selectMap = false;
          displayStartScreen = true;
        }
      }
    }
    
    if (xPos > backSpaceX1 - backSpaceWidth && xPos < backSpaceX1 + backSpaceWidth) {
      if (yPos > backSpaceY1 - backSpaceHeight && yPos < backSpaceY1 + backSpaceHeight) {
        if (typedCount > 0 ) {
          typedCount--;
          updateRegionName(key, 0);
          autoComplete();
        }
      }
    }
  }
}// touchDown

public void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth) {
  noFill();
  stroke(0, 255, 0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
  
}// touchMove

public void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth) {
  noFill();
  stroke(0, 0, 255);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
}// touchUp

