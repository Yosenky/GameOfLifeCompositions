// Grid Controller Class
// Creates a GridController object for ease of use and readabiltiy in the main file




public class GridController{
  
  public GridController(){} // Empty constructor
  
  // Initialize grid and cells
  void initializeGrid(){
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
  }
  
  
  // Draws grid of cells
  void drawGrid(){
    for(int i = 0; i < cellsPerRow; i++){
      for(int j = 0; j < cellsPerColumn; j++){
        cells[i][j].drawCell();
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
    gameOfLifeController.countNeighbors(); // Count and mark the cells with the most neighbors
  }


  // Checking for user input on the grid and updating if receieved
  void checkForInput(){
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
        gameOfLifeController.countNeighbors(); // Count and mark the cells with the most neighbors
    }
  }
  
  
  // Updates grid based on info received in a message
  void updateGridFromMessage(int newGridWidth, int newGridHeight, int[] activeCellYCoordinates){
    // Resizing grid
    resizeGrid(newGridWidth, newGridHeight);
    controlP5.getController(CellsPerRow).setValue(newGridWidth);
    controlP5.getController(CellsPerColumn).setValue(newGridHeight);
    // Updating cells
    for(int i = 0; i < cellsPerRow; i++){
      cells[i][activeCellYCoordinates[i]].revive();  
    }
  }
}
