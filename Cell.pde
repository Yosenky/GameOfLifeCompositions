// Cell class for grid

public class Cell{
  float cellWidth; // Cell width
  float cellHeight; // Cell height
  float cellX; // Cell X-coordinate
  float cellY; // Cell Y-coordinate
  boolean isCellAlive; // Cell life state
  int numberOfNeighbors; // Counts the number of neighbors the cell has
  boolean hasMaximumNeighbors; // True if cell has the most neighbors out of all cells in it's column
  
  color aliveColor = color(103,102,165);
  color deadColor = color(227,124,124);
  color maximumNeighborsColor = color(104,56,84);
  color fillColor = deadColor;
 
  // Base constructor
  public Cell(float cellX, float cellY, float cellWidth, float cellHeight, boolean isCellAlive){
    this.cellWidth = cellWidth;
    this.cellHeight = cellHeight;
    this.cellX = cellX;
    this.cellY = cellY;
    this.isCellAlive = isCellAlive;
  }
  
  // Copy constructor
  public Cell(Cell cellToBeCopied){
    this.cellWidth   = cellToBeCopied.getWidth();
    this.cellHeight  = cellToBeCopied.getHeight();
    this.cellX       = cellToBeCopied.getCellX();
    this.cellY       = cellToBeCopied.getCellY();
    this.isCellAlive = cellToBeCopied.isAlive();
  }
  
  
  
  //
  // GETTER METHODS
  //
  
  // Returns cell width
  float getWidth(){
    return cellWidth;
  }
  
  // Returns cell height
  float getHeight(){
    return cellHeight;
  }
  
  // Returns cell x-coordinate
  float getCellX(){
    return cellX;
  }
  
  // Returns cell y-coordinate
  float getCellY(){
    return cellY;
  }
  
  // Returns true if cell is alive
  boolean isAlive(){
    return isCellAlive;
  }
  
  // Returns true if cell is dead
  boolean isDead(){
    return !isCellAlive;
  }
  
  // Returns number of neighbors
  int getNumberOfNeighbors(){
    return numberOfNeighbors;
  }
  
  
  //
  // SETTER METHODS
  //
  
  // Sets cell width
  void setWidth(float newWidth){
    cellWidth = newWidth;
  }
  
  // Sets cell height
  void setHeight(float newHeight){
    cellHeight = newHeight;
  }
  
  // Sets cell x-coordinate
  void setCellX(float newCellX){
    cellX = newCellX;
  }
  
  // Sets cell y-coordinate
  void setCellY(float newCellY){
    cellY = newCellY;
  }
  
  // Kills cell
  void kill(){
    isCellAlive = false;
    fillColor = deadColor;
  }
  
  // Brings cell to life
  void revive(){
    isCellAlive = true;
    fillColor = aliveColor;
  }
  
  // Copies all aspects of another cell
  // Used for the buffer array
  void copyCell(Cell cellToBeCopied){
    this.cellWidth   = cellToBeCopied.getWidth();
    this.cellHeight  = cellToBeCopied.getHeight();
    this.cellX       = cellToBeCopied.getCellX();
    this.cellY       = cellToBeCopied.getCellY();
    this.isCellAlive = cellToBeCopied.isAlive();
  }
  
  // Set number of neighbors
  void setNumberOfNeighbors(int numberOfNeighbors){
    this.numberOfNeighbors = numberOfNeighbors;
  }
  
  // Sets hasMaximumNeighbors true if has maximum neighbors, false if not
  void hasMostNeighbors(boolean hasMaximumNeighbors){
    this.hasMaximumNeighbors = hasMaximumNeighbors;
  }
  
  
  //
  // DRAWING
  //
  
  // Draws cell
  void drawCell(){
    setCellColor();
    rect(cellX, cellY, cellWidth, cellHeight);
  }
  
  void setCellColor(){
    if(hasMaximumNeighbors){
      fill(maximumNeighborsColor);
    }else if(isCellAlive){
      fill(aliveColor);
    }else{
      fill(deadColor);
    }
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
