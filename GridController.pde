// Grid Controller Class
// Creates a GridController object for ease of use and readabiltiy in the main file

public class GridController{
  
  public GridController(){} // Empty constructor
  
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

}
