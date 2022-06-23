import controlP5.*;

/*
Using the game of life to compose/help compose music
SURF 2022, jrkm
*/

//
// GRID VARIABLES
//

// Parameters for grid size
int cellsPerRow    = 50;
int cellsPerColumn = 50;
float cellWidth;
float cellHeight;
int halfwayLineX; // X coordinate for line that cuts screen in half

// Cell Arrays
int[][] cells;
int[][] cellsBuffer;

// Cell colors
color aliveColor = color(103,102,165);
color deadColor = color(227,124,124);

// Grid Generation
int probabilityOfCellsBeingAlive = 15; // In percent, default is 15


//
// GAME OF LIFE VARIABLES
//
int totalNumberOfIterations = 1;
int currentNumberOfIterations = 0;
float timeBetweenIterations = 1000;  // in ms
int lastRecordedTime = 0;
boolean iteratingForever = false; // If true, iterates until manually stopped

//
// CONTROL P5 VARIABLES
//
ControlP5 controlP5;
String RandomizeGrid = "Randomize";
String ChanceOfCellsBeingAlive = "Chance of cells being alive(%)";
String ClearGrid = "Clear";
String GameOfLife = "Game Of life";
String TotalIterations = "Number of iterations to queue";
String TimeBetweenIterations = "Time between iterations(seconds)";
String IterateForever = "Iterate Forever";


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
  cells = new int[cellsPerRow][cellsPerColumn];
  cellsBuffer = new int[cellsPerRow][cellsPerColumn];
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      cells[i][j] = 0;
      cellsBuffer[i][j] = cells[i][j];
    }
  }
  
  
  //
  // CONTROL P5 STUFF
  //
  controlP5 = new ControlP5(this);
  setupControls();
}


void draw(){
  // Draws line to cut screen in half for controls
  strokeWeight(8);
  line(halfwayLineX,0,halfwayLineX,height);
  strokeWeight(1);
  
  background(200);
  
  // Drawing grid
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      if(cells[i][j] == 0){
        fill(deadColor);
      } else{
        fill(aliveColor);
      }
      rect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
    }
  }
  
  // Allowing the user to click on the grid to draw
  if(mousePressed && mouseX < halfwayLineX){
    // Mapping coordinate clicked to cell
    int xCellOver = int(map(mouseX, 0, halfwayLineX, 0, cellsPerRow));
    int yCellOver = int(map(mouseY, 0, height, 0, cellsPerColumn));
    // Checking to see if cell is alive or dead
    if(cellsBuffer[xCellOver][yCellOver] == 0){
      cells[xCellOver][yCellOver] = 1;
    } else {
      cells[xCellOver][yCellOver] = 0;
    }
  } else if(!mousePressed){
    // On mouse release, update arrays to match again
      for(int i = 0; i < cellsPerRow; i++){
        for(int j = 0; j < cellsPerColumn; j++){
          cellsBuffer[i][j] = cells[i][j];
        }
      }    
  }
    
  // Iteration timer
  if((millis() - lastRecordedTime > timeBetweenIterations) && ((currentNumberOfIterations < totalNumberOfIterations) || iteratingForever)){
    gameOfLife();
    lastRecordedTime = millis();
    currentNumberOfIterations++;
  }
  
  
  // Iteration Text
  textSize(24);
  fill(0);
  text("Current Iteration: ", width*34/40,height/40);
  String currentIterationText = " " + currentNumberOfIterations;
  text(currentIterationText, width*38/40, height/40);
  // Display iterating forever text when iterating forever toggle is on
  if(iteratingForever){
    text("ITERATING FOREVER", width*34/40, height*2/40);
  }
    
    
}


// One iteration of the game of life
void gameOfLife(){
  // Double check that arrays match up
    for(int i = 0; i < cellsPerRow; i++){
      for(int j = 0; j < cellsPerColumn; j++){
        cellsBuffer[i][j] = cells[i][j];
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
                if(cellsBuffer[neighborX][neighborY] == 1){
                  neighbors++;
                } // End of if(checking if neighbor alive)
              } // End of if(checking against self)
            } // End of if(checking to make sure in bounds)
          } // End of neighborY traversal
        } // End of neighborX traversal
        
        // After checking neighbors, apply rules
        // If the cell is alive
        if(cellsBuffer[cellX][cellY] == 1){
          // If has less than 2 neighbors, or more than 3, kill it
          if(neighbors < 2 || neighbors > 3){
            cells[cellX][cellY] = 0;
          } 
        }else{ // Else, the cell is dead
          //If it has 3 neighbors, bring it to life
          if(neighbors == 3){
            cells[cellX][cellY] = 1;
          }
        }
      } // End of cellY traversal
    } // End of cellX traversal    
}


// Sets random cells to be alive in the grid
void generateRandomCells(){
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      cells[i][j] = 0; // Initialize entire array to be dead at start
      float isAlive = random(100);
      if(isAlive < probabilityOfCellsBeingAlive){
        cells[i][j] = 1;
      }
    }
  }
}


// Clears the grid(sets all cells to be dead)
void clearGrid(){
  for(int i = 0; i < cellsPerRow; i++){
    for(int j = 0; j < cellsPerColumn; j++){
      cells[i][j] = 0; // Set cell to be dead
    }
  }
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
  // % Chance of Being Alive Slider
  controlP5.addSlider(ChanceOfCellsBeingAlive, 1, 100, probabilityOfCellsBeingAlive, 0, width*2/36 , width/10, height/36).setGroup(controlGroup1)
                                                                                                                         .setFont(SmallerUIFont)
                                                                                                                         .setNumberOfTickMarks(100)
                                                                                                                         .showTickMarks(false)
                                                                                                                         .getCaptionLabel()
                                                                                                                         .setColor(0);
  // Clear Grid                                                                                                                   
  controlP5.addBang(controlP5, ClearGrid, ClearGrid, width*3/36, 0, width/36, width/36).setGroup(controlGroup1)
                                                                                       .setFont(SmallerUIFont)
                                                                                       .getCaptionLabel()
                                                                                       .setColor(0);        
                                                                                      
  // Game Of Life                                                                                                                  
  controlP5.addBang(controlP5, GameOfLife, GameOfLife, width*5/36, 0, width/36, width/36).setGroup(controlGroup1)
                                                                                         .setFont(SmallerUIFont)
                                                                                         .getCaptionLabel()
                                                                                         .setColor(0);   
                                                                                      
  // Number of iterations slider
  controlP5.addSlider(TotalIterations, 1, 100, 1, 0, width*3/36 , width/10, height/36).setGroup(controlGroup1)
                                                                                      .setFont(SmallerUIFont)
                                                                                      .setNumberOfTickMarks(100)
                                                                                      .showTickMarks(false)
                                                                                      .getCaptionLabel()
                                                                                      .setColor(0);
                                                                                      
  // Time between iterations slider
  controlP5.addSlider(TimeBetweenIterations, .01, 5, 1, 0, width*4/36 , width/10, height/36).setGroup(controlGroup1)
                                                                                            .setFont(SmallerUIFont)
                                                                                            .setNumberOfTickMarks(500)
                                                                                            .showTickMarks(false)
                                                                                            .getCaptionLabel()
                                                                                            .setColor(0);
                                                                                      
  // Iterate forever toggle                                                                                                        
  controlP5.addBang(controlP5, IterateForever, IterateForever, width*8/36, 0, width/36, width/36).setGroup(controlGroup1)
                                                                                      .setFont(SmallerUIFont)
                                                                                      .getCaptionLabel()
                                                                                      .setColor(0);                                                                                         
                                                                                      
}


// Event handler for all getControllers
void controlEvent(ControlEvent theEvent){
  if(theEvent.isController()){ // Checking to make sure the ControlEvent corresponds to a controller
  
    if(theEvent.getController().getName() == RandomizeGrid){ // Randomizing Grid
      generateRandomCells();
    }
    else if(theEvent.getController().getName() == ChanceOfCellsBeingAlive){ // Changing % of cells that are likely to be alive
      probabilityOfCellsBeingAlive = (int)controlP5.getController(ChanceOfCellsBeingAlive).getValue();
    }
    else if(theEvent.getController().getName() == ClearGrid){ // Clear Grid
    currentNumberOfIterations = 0;
      clearGrid();
    }
    else if(theEvent.getController().getName() == GameOfLife){ // Game of Life
      gameOfLife();
      currentNumberOfIterations = 0;
      lastRecordedTime = millis();
    }
    else if(theEvent.getController().getName() == TotalIterations){ // Number of iterations
      totalNumberOfIterations = (int)controlP5.getController(TotalIterations).getValue();
      currentNumberOfIterations = totalNumberOfIterations; // Makes it so that the game doesn't start until the GameOfLife button is pressed
    }
    else if(theEvent.getController().getName() == TimeBetweenIterations){ // Time between iterations
      timeBetweenIterations = controlP5.getController(TimeBetweenIterations).getValue() * 1000;
    }    
    else if(theEvent.getController().getName() == IterateForever){ // Iterate Forever
       iteratingForever = !iteratingForever;
    }    
  }
}
