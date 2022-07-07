// Game of life controller class
// Contains methods for running the game of life



public class GameOfLifeController{
 
  public GameOfLifeController(){} // Empty constructor
  
  
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
        cells[i][j].hasMostNeighbors(false); // Reset all cells back to default of not being the winner
        if(currentCellsNeighbors >= maximumNeighbors){
          maximumNeighbors = currentCellsNeighbors;
        }
      }
      if(maximumNeighbors != 0){
        // Marks the cells that have the most neighbors
        lookingForCellWithMostNeighbors = true; // Will be set to false upon first cell in column being marked
        for(int j = 0; j < cellsPerColumn; j++){
          if(cells[i][j].getNumberOfNeighbors() == maximumNeighbors && lookingForCellWithMostNeighbors){
            cells[i][j].hasMostNeighbors(true);  // If has most neighbors
            if(!allowMoreThanOneWinnerPerColumn){
              lookingForCellWithMostNeighbors = false; 
            }    
          }
        }
      }
    }
  }
  
  
  // Timer for iterations
  void iterationTimer(){
    // Iteration timer
    if((millis() - lastRecordedTime > timeBetweenIterations) && ( currentNumberOfIterations < totalNumberOfIterations|| iteratingForever)){
      gameOfLifeController.gameOfLife(); // One iteration of game of life
      lastRecordedTime = millis(); // Update time
      currentNumberOfIterations++; // Add iteration
      if(iteratingThenPlaying){ // If iterating then playing was pressed
        audioController.queueNotes(); // Queue current grid
        if(currentNumberOfIterations == totalNumberOfIterations){ // If last iteration, play notes
           out.resumeNotes(); 
        }
      }
    }
  }
  
  
  // Displays the current number of iterations in the top right corner
  void displayIterationText(){
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
}
