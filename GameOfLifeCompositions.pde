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
String ChanceOfCellsBeingAlive = "Chance of life(%)";
String ClearGrid = "Clear";
String OneIteration = "One";
String MultipleIterations = "Multiple";
String TotalIterations = "Number of iterations to queue";
String TimeBetweenIterations = "Time between iterations(seconds)";
String InfiniteIterations = "Infinite";
String CellsPerRowController = "Cells Per Row";
String CellsPerColumnController = "Cells Per Column";
String ShowingNeighbors = "Show Most Neighbors";
String AllowMoreThanOneWinner = "Allow more than one winner per column";
String StopIterating = "Stop";
String PlayNotes = "Play Notes";

color activeToggleColor = color(14,220,55); // Color when toggle is active
color inactiveToggleColor = color(0,0,0); // Color when toggle is inactive
color hoveredToggleColor = color(80,80,80); // Color when toggle is being hovered over

PFont BarFont; // Font for bars at top of control groups
PFont UIFont; // Regular UI Font
PFont SmallerUIFont; // Smaller version of UI Font

ControlGroup gridControls;
ControlGroup gameOfLifeControls;
ControlGroup audioControls;
ControlGroup votingControls;

//
// AUDIO VARIABLES
//
Minim minim;
AudioOutput out;

float noteDuration = .25; // Duration of each note, in beats

//
// OBJECT VARIABLES
//
GridController gridController; // Contains methods for manipulating the grid of cells
ControlsController controlsController; // Contains methods for generation of controls and handling of events

void setup(){
  //fullScreen();
  size(1800,1000);
  
  // OBJECT INITIALIZATION
  gridController = new GridController();
  controlsController = new ControlsController();
  
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
  controlsController.setupControls();
  
  //
  // MINIM STUFF
  //
  minim = new Minim(this);
  out = minim.getLineOut();
  

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
  } else if(!mousePressed){
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

// Saves notes to an audio track
void saveNotes(){
  out.pauseNotes();
  float noteTime = 0;
  for(int i  = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      if(cells[i][j].getHasMaximumNeighbors()){
        out.playNote( noteTime, noteDuration, new SineInstrument( 300 + 20*j) );
        noteTime += noteDuration;
      }
    }
  }  
}

// Plays notes based on neighbors
void playNotes(){
  out.resumeNotes();
}





// Event handler for all getControllers
void controlEvent(ControlEvent theEvent){
  controlsController.newControlEvent(theEvent);
}
