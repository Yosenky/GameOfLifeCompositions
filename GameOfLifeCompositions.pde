import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import controlP5.*;

/*
Using the game of life to compose/help compose music
SURF 2022, jrkm
*/

//
// GRID VARIABLES
//

// Parameters for grid size
int cellsPerRow    = 10;
int cellsPerColumn = 10;
float cellWidth;
float cellHeight;
int halfwayLineX; // X coordinate for line that cuts screen in half
int maxCellsPerRow = 150;
int maxCellsPerColumn = 150;

// Cell Arrays
Cell[][] cells;
Cell[][] cellsBuffer;

// Cell colors
color aliveColor = color(103,102,165);
color deadColor = color(227,124,124);

// Grid Generation
int probabilityOfCellsBeingAlive = 15; // In percent, default is 15


//
// GAME OF LIFE VARIABLES
//
int totalNumberOfIterations = 0;
int currentNumberOfIterations = 0;
float timeBetweenIterations = 1000;  // in ms
int lastRecordedTime = 0;
boolean iteratingForever = false; // If true, iterates until manually stopped
boolean showingNeighborVotes = false; // If true, highlights each cell with the most neighbors
boolean lookingForCellWithMostNeighbors = true; // If true, search for first cell with most neighbors
boolean allowMoreThanOneWinnerPerColumn = false; // If true, allows more than one cell per column to be marked with the most neighbors

//
// CONTROL P5 VARIABLES
//
ControlP5 controlP5;
String RandomizeGrid = "Randomize";
String ChanceOfCellsBeingAlive = "Chance of cells being alive(%)";
String ClearGrid = "Clear";
String OneIteration = "One iteration";
String MultipleIterations = "Multiple iterations";
String TotalIterations = "Number of iterations to queue";
String TimeBetweenIterations = "Time between iterations(seconds)";
String InfiniteIterations = "Infinite iterations";
String CellsPerRowController = "Cells Per Row";
String CellsPerColumnController = "Cells Per Column";
String ShowingNeighbors = "Show cells with most neighbors";
String AllowMoreThanOneWinner = "Allow more than one winner per column";
String StopIterating = "Stop iterating";

color activeToggleColor = color(14,220,55); // Color when toggle is active
color inactiveToggleColor = color(0,0,0); // Color when toggle is inactive
color hoveredToggleColor = color(80,80,80); // Color when toggle is being hovered over


void setup(){
  //fullScreen();
  size(1800,1000);
  
  //
  // GRID STUFF
  //
  cellWidth = (width/2) / cellsPerRow;
  cellHeight = height / cellsPerColumn;
  halfwayLineX = width/2 + 4;
  
  // Initializing arrays of cells to all be 0 at start
  cells = new Cell[maxCellsPerRow][maxCellsPerColumn];
  cellsBuffer = new Cell[maxCellsPerRow][maxCellsPerColumn];
  for(int i = 0; i < maxCellsPerRow; i++){
    for(int j = 0; j < maxCellsPerColumn; j++){
      cells[i][j] = new Cell(i*cellWidth, j*cellHeight, cellWidth, cellHeight, false);
      cellsBuffer[i][j] = new Cell(cells[i][j]);
    }
  }
  
  
  //
  // CONTROL P5 STUFF
  //
  controlP5 = new ControlP5(this);
  setupControls();
}


void draw(){  
  background(200);
  // Draws line to cut screen in half for controls
  strokeWeight(8);
  line(halfwayLineX,0,halfwayLineX,height);
  strokeWeight(1);
  
  // Drawing grid
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      cells[i][j].drawCell();
    }
  }
 
  
  // Allowing the user to click on the grid to draw
  if(mousePressed && mouseX < halfwayLineX && mouseX > 0){
    // Mapping coordinate clicked to cell
    int xCellOver = int(map(mouseX, 0, halfwayLineX, 0, cellsPerRow));
    int yCellOver = int(map(mouseY, 0, height, 0, cellsPerColumn));
    // Checking to see if cell is alive or dead
    if(cellsBuffer[xCellOver][yCellOver].isDead()){
      cells[xCellOver][yCellOver].revive();
    } else {
      cells[xCellOver][yCellOver].kill();
    }
  } else if(!mousePressed && mouseX < halfwayLineX && mouseX > 0){
    // On mouse release, update arrays to match again
      for(int i = 0; i < cellsPerRow; i++){
        for(int j = 0; j < cellsPerColumn; j++){
          cellsBuffer[i][j].copyCell(cells[i][j]);
        }
      }
      countNeighbors(); // Count and mark the cells with the most neighbors
  }
  

  
  // Iteration timer
  if((millis() - lastRecordedTime > timeBetweenIterations) && ( currentNumberOfIterations < totalNumberOfIterations|| iteratingForever)){
    gameOfLife();
    lastRecordedTime = millis();
    currentNumberOfIterations++;
  }
  
  
  // Iteration Text
  textSize(24);
  fill(0);
  String currentIterationText = "Current Iteration:  " + currentNumberOfIterations + " / " + totalNumberOfIterations;
  text(currentIterationText, width*34/40,height/40);
  // Display iterating forever text when iterating forever toggle is on
  if(iteratingForever){
    text("ITERATING FOREVER", width*34/40, height*2/40);
  }
    
    
}


// One iteration of the game of life
void gameOfLife(){
  countNeighbors();
  // Double check that arrays match up
    for(int i = 0; i < cellsPerRow; i++){
      for(int j = 0; j < cellsPerColumn; j++){
        cellsBuffer[i][j].copyCell(cells[i][j]);
      }
    }
    // Visit each cell
    for(int cellX = 0; cellX < cellsPerRow; cellX++){
      for(int cellY = 0; cellY < cellsPerColumn; cellY++){
        int neighbors = cellsBuffer[cellX][cellY].getNumberOfNeighbors();
        // After checking neighbors, apply rules
        // If the cell is alive
        if(cellsBuffer[cellX][cellY].isAlive()){
          // If has less than 2 neighbors, or more than 3, kill it
          if(neighbors < 2 || neighbors > 3){
            cells[cellX][cellY].kill();
          } 
        }else{ // Else, the cell is dead
          //If it has 3 neighbors, bring it to life
          if(neighbors == 3){
            cells[cellX][cellY].revive();
          }
        }
        cells[cellX][cellY].setNumberOfNeighbors(neighbors);
      } // End of cellY traversal
    } // End of cellX traversal    
}


// Counts the neighbors of each cell, then marks the cells with the most neighbors in each column
void countNeighbors(){
    // Double check that arrays match up
    for(int i = 0; i < cellsPerRow; i++){
      for(int j = 0; j < cellsPerColumn; j++){
        cellsBuffer[i][j].copyCell(cells[i][j]);
      }
    }
    
   // Visit each cell
    for(int cellX = 0; cellX < cellsPerRow; cellX++){
      for(int cellY = 0; cellY < cellsPerColumn; cellY++){
        // And visit all of the neighbors of each cell
        int neighbors = 0;
        for(int neighborX = cellX-1; neighborX<= cellX+1; neighborX++){
          for(int neighborY = cellY-1; neighborY<= cellY+1; neighborY++){
            // Makes sure you are not out of bounds
            if(((neighborX >= 0) && (neighborX < cellsPerRow)) && ((neighborY >= 0) && (neighborY < cellsPerColumn))){
              // Makes sure to check against self
              if((cellX != neighborX) || (cellY != neighborY)){
                // If neighbor is alive, count them
                if(cellsBuffer[neighborX][neighborY].isAlive()){
                  neighbors++;
                } // End of if(checking if neighbor alive)
              } // End of if(checking against self)
            } // End of if(checking to make sure in bounds)
          } // End of neighborY traversal
        } // End of neighborX traversal
        cells[cellX][cellY].setNumberOfNeighbors(neighbors);
        cellsBuffer[cellX][cellY].setNumberOfNeighbors(neighbors);
      } // End of cellY traversal
    } // End of cellX traversal    
  
  for(int i = 0; i < cellsPerRow; i++){
    int maximumNeighbors = 0; // The highest number of neighbors in each column
    int currentCellsNeighbors = 0; // The current cells neighbor count
    for(int j = 0; j < cellsPerColumn; j++){
      currentCellsNeighbors = cells[i][j].getNumberOfNeighbors();
      if(currentCellsNeighbors >= maximumNeighbors){
        maximumNeighbors = currentCellsNeighbors;
      }
    }
    // Marks the cells that have the most neighbors
    lookingForCellWithMostNeighbors = true; // Will be set to false upon first cell in column being marked
    for(int j = 0; j < cellsPerColumn; j++){
      if(cells[i][j].getNumberOfNeighbors() == maximumNeighbors && lookingForCellWithMostNeighbors){
        cells[i][j].hasMostNeighbors(true);  // If has most neighbors
        if(!allowMoreThanOneWinnerPerColumn){
          lookingForCellWithMostNeighbors = false; 
        }

      } else {
        cells[i][j].hasMostNeighbors(false); // If doesn't have most neighbors
      }
    }
  }
}


// Sets random cells to be alive in the grid
void generateRandomCells(){
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      cells[i][j].kill(); // Initialize entire array to be dead at start
      float isAlive = random(100);
      if(isAlive < probabilityOfCellsBeingAlive){
        cells[i][j].revive();
      }
    }
  }
}


// Clears the grid(sets all cells to be dead with no neighbors)
void clearGrid(){
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      cells[i][j].kill(); // Set cell to be dead
    }
  }
  clearNeighbors();
}

// Removes all neighbor tracking from all cells
void clearNeighbors(){
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      cells[i][j].setNumberOfNeighbors(0); // Set cell to have 0 registered neighbors
      cells[i][j].hasMostNeighbors(false); // Set cell to not have the most neighbors in it's column
    }
  }
}


// Resizes the grid when the number of cells in the rows/columns are changed
void resizeGrid(int newCellsPerRow, int newCellsPerColumn){
  // Resetting grid
  clearGrid();
  currentNumberOfIterations = 0;
  totalNumberOfIterations = 0;
  cellsPerRow = newCellsPerRow;
  cellsPerColumn = newCellsPerColumn;
  // Resizing all of the displayed cells
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      cellWidth = (width/2) / (float)cellsPerRow;
      cellHeight = height / (float)cellsPerColumn;
      cells[i][j].setWidth(cellWidth);
      cells[i][j].setHeight(cellHeight);
      cells[i][j].setCellX(cellWidth * i);
      cells[i][j].setCellY(cellHeight * j);
      cellsBuffer[i][j].copyCell(cells[i][j]);
    }
  }
  
  cellsPerRow = newCellsPerRow;
  cellsPerColumn = newCellsPerColumn;
  countNeighbors(); // Count and mark the cells with the most neighbors
}


//
// ALL CONTROLP5 STUFF UNDER HERE
//



void setupControls(){
  PFont BarFont       = createFont("unispaceregular.ttf",width/96);
  PFont UIFont        = createFont("Candal.ttf",24);
  PFont SmallerUIFont = createFont("MonospaceTypewriter.ttf", 18);
  controlP5.setFont(BarFont);
  
  // Creating control groups
  ControlGroup controlGroup1 = controlP5.addGroup("Grid Controls", halfwayLineX + 15, height/30);
  controlGroup1.setBackgroundHeight((height*34/40)/2);
  controlGroup1.setWidth(width/6);
  controlGroup1.setBarHeight(height/40);
  
  // Adding to control groups
  // Control group 1
  
  // RandomizeGridButton
  controlP5.addBang(controlP5, RandomizeGrid, RandomizeGrid, 0, 0, width/36, width/36).setGroup(controlGroup1)
                                                                                      .setFont(SmallerUIFont)
                                                                                      .getCaptionLabel()
                                                                                      .setColor(0);
  // Clear Grid                                                                                                                   
  controlP5.addBang(controlP5, ClearGrid, ClearGrid, width*3/36, 0, width/36, width/36).setGroup(controlGroup1)
                                                                                       .setFont(SmallerUIFont)
                                                                                       .getCaptionLabel()
                                                                                       .setColor(0);     
                                                                                       
  // One iteration                                                                                                                  
  controlP5.addBang(controlP5, OneIteration, OneIteration, 0, width*4/36, width/36, width/36).setGroup(controlGroup1)
                                                                                         .setFont(SmallerUIFont)
                                                                                         .getCaptionLabel()
                                                                                         .setColor(0);   
                                                                                         
  // Multiple iterations                                                                                                                 
  controlP5.addBang(controlP5, MultipleIterations, MultipleIterations, width*4/36, width*4/36, width/36, width/36).setGroup(controlGroup1)
                                                                                         .setFont(SmallerUIFont)
                                                                                         .getCaptionLabel()
                                                                                         .setColor(0);        
                                                                                         
  // Iterate forever toggle    
  controlP5.addToggle(controlP5, InfiniteIterations, InfiniteIterations, false, width*9/36, width*4/36, width/36, width/36).setGroup(controlGroup1)
                                                                                                                           .setColorForeground(hoveredToggleColor)
                                                                                                                           .setColorBackground(inactiveToggleColor)
                                                                                                                           .setColorActive(activeToggleColor)
                                                                                                                           .setFont(SmallerUIFont)
                                                                                                                           .getCaptionLabel()
                                                                                                                           .setColor(0);   
  // Allow more than one winner per column toggle   
  controlP5.addToggle(controlP5, AllowMoreThanOneWinner, AllowMoreThanOneWinner, false, width*8/36, width*2/36, width/36, width/36).setGroup(controlGroup1)
                                                                                                                           .setColorForeground(hoveredToggleColor)
                                                                                                                           .setColorBackground(inactiveToggleColor)
                                                                                                                           .setColorActive(activeToggleColor)
                                                                                                                           .setFont(SmallerUIFont)
                                                                                                                           .getCaptionLabel()
                                                                                                                           .setColor(0); 
                                                                                                                           
  // Counting Neighbors Toggle 
  controlP5.addToggle(controlP5, ShowingNeighbors, ShowingNeighbors, false, 0, width*2/36, width/36, width/36).setGroup(controlGroup1)
                                                                                                                           .setColorForeground(hoveredToggleColor)
                                                                                                                           .setColorBackground(inactiveToggleColor)
                                                                                                                           .setColorActive(activeToggleColor)
                                                                                                                           .setFont(SmallerUIFont)
                                                                                                                           .getCaptionLabel()
                                                                                                                           .setColor(0);   
                                                                                                                           
  // % Chance of Being Alive Slider
  controlP5.addSlider(ChanceOfCellsBeingAlive, 1, 100, probabilityOfCellsBeingAlive, 0, width*6/36 , width/10, height/36).setGroup(controlGroup1)
                                                                                                                         .setFont(SmallerUIFont)
                                                                                                                         .setNumberOfTickMarks(100)
                                                                                                                         .showTickMarks(false)
                                                                                                                         .getCaptionLabel()
                                                                                                                         .setColor(0);                                                                                                                              
                                                                                                                                      
  // Number of iterations slider
  controlP5.addSlider(TotalIterations, 1, 100, 1, 0, width*7/36 , width/10, height/36).setGroup(controlGroup1)
                                                                                      .setFont(SmallerUIFont)
                                                                                      .setNumberOfTickMarks(100)
                                                                                      .showTickMarks(false)
                                                                                      .getCaptionLabel()
                                                                                      .setColor(0);  
                                                                                      
  // Time between iterations slider
  controlP5.addSlider(TimeBetweenIterations, .01, 5, 1, 0, width*8/36 , width/10, height/36).setGroup(controlGroup1)
                                                                                            .setFont(SmallerUIFont)
                                                                                            .setNumberOfTickMarks(500)
                                                                                            .showTickMarks(false)
                                                                                            .getCaptionLabel()
                                                                                            .setColor(0);
                                                                                            
  // Cells Per Row Slider
  controlP5.addSlider(CellsPerRowController, 10, 150, 10, 0, width*9/36 , width/10, height/36).setGroup(controlGroup1)
                                                                                            .setFont(SmallerUIFont)
                                                                                            .setNumberOfTickMarks(maxCellsPerRow-9)
                                                                                            .showTickMarks(false)
                                                                                            .getCaptionLabel()
                                                                                            .setColor(0);
                                                                                            
  // Cells Per Column Slider
  controlP5.addSlider(CellsPerColumnController, 10, 150, 10, 0, width*10/36 , width/10, height/36).setGroup(controlGroup1)
                                                                                            .setFont(SmallerUIFont)
                                                                                            .setNumberOfTickMarks(maxCellsPerColumn-9)
                                                                                            .showTickMarks(false)
                                                                                            .getCaptionLabel()
                                                                                            .setColor(0);                                                                                       
                                                                                       
                                                                                      
}


// Event handler for all getControllers
void controlEvent(ControlEvent theEvent){
  if(theEvent.isController()){ // Checking to make sure the ControlEvent corresponds to a controller
  
    if(theEvent.getController().getName() == RandomizeGrid){ // Randomizing Grid
      generateRandomCells();
      countNeighbors();
      currentNumberOfIterations = 0;
      totalNumberOfIterations = 0;
      countNeighbors(); // Count and mark the cells with the most neighbors
    }
    else if(theEvent.getController().getName() == ChanceOfCellsBeingAlive){ // Changing % of cells that are likely to be alive
      probabilityOfCellsBeingAlive = (int)controlP5.getController(ChanceOfCellsBeingAlive).getValue();
    }
    else if(theEvent.getController().getName() == ClearGrid){ // Clear Grid
      currentNumberOfIterations = 0;
      totalNumberOfIterations = 0;
      clearGrid();
      iteratingForever = false;
      countNeighbors(); // Count and mark the cells with the most neighbors
    }
    else if(theEvent.getController().getName() == OneIteration){ // Single iteration
      currentNumberOfIterations = 1;
      totalNumberOfIterations = 1;
      gameOfLife();
      lastRecordedTime = millis();
    }
    else if(theEvent.getController().getName() == MultipleIterations){ // Multiple Iterations
      currentNumberOfIterations = 0;
      currentNumberOfIterations++;
      gameOfLife();
      totalNumberOfIterations = (int)controlP5.getController(TotalIterations).getValue();
      lastRecordedTime = millis();    
    }
    else if(theEvent.getController().getName() == TimeBetweenIterations){ // Time between iterations
      timeBetweenIterations = controlP5.getController(TimeBetweenIterations).getValue() * 1000;
    }    
    else if(theEvent.getController().getName() == InfiniteIterations){ // Iterate Forever
       iteratingForever = !iteratingForever;
    }
    else if(theEvent.getController().getName() == ShowingNeighbors){ // Count Neighbors
       showingNeighborVotes = !showingNeighborVotes;
    }
    else if(theEvent.getController().getName() == AllowMoreThanOneWinner){ // Allow more than one winner per column
       allowMoreThanOneWinnerPerColumn = !allowMoreThanOneWinnerPerColumn;
       countNeighbors(); //
    }    
    else if(theEvent.getController().getName() == CellsPerRowController){ // Adjusts number of cells per row
      resizeGrid((int)controlP5.getController(CellsPerRowController).getValue(), cellsPerColumn);
    }   
    else if(theEvent.getController().getName() == CellsPerColumnController){ // Adjusts number of cells per column
      resizeGrid(cellsPerRow, (int)controlP5.getController(CellsPerColumnController).getValue());
    }   
  }
}
