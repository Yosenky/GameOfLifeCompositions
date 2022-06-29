// Object for use controlling the controlP5 objects and events
// Contains methods for creating and using controlP5 controls

String AddToTrack = "Save to track";

public class ControlsController{
  
  public ControlsController(){} // Empty constructor
  
 
  // Sets up all controls
  void setupControls(){
    createFonts();
    createControlGroups();
    createGridControls();
    createGameOfLifeControls();
    createAudioControls();
    createVotingControls();                                                                                        
  }
  
  
  // Creates all fonts for use in UI
  void createFonts(){
    BarFont       = createFont("unispaceregular.ttf",width/96);
    UIFont        = createFont("Candal.ttf",24);
    SmallerUIFont = createFont("MonospaceTypewriter.ttf", 16);
    controlP5.setFont(BarFont);
  }
  
  
  // Creates all control groups
  void createControlGroups(){
    // Grid controls
    gridControls = controlP5.addGroup("Grid Controls", halfwayLineX + 15, height/30);
    gridControls.setBackgroundHeight((height*34/40)/2);
    gridControls.setWidth(width/6);
    gridControls.setBarHeight(height/40);
    
    // Game of life controls
    gameOfLifeControls = controlP5.addGroup("Game of Life Controls", halfwayLineX + 15, height*10/30);
    gameOfLifeControls.setBackgroundHeight((height*34/40)/2);
    gameOfLifeControls.setWidth(width/6);
    gameOfLifeControls.setBarHeight(height/40);
    
    // Audio controls
    audioControls = controlP5.addGroup("Audio Controls", halfwayLineX + 15, height*20/30);
    audioControls.setBackgroundHeight((height*34/40)/2);
    audioControls.setWidth(width/6);
    audioControls.setBarHeight(height/40);    

    // Voting controls
    votingControls = controlP5.addGroup("Voting Controls", halfwayLineX * 3/2, height*2/30);
    votingControls.setBackgroundHeight((height*34/40)/2);
    votingControls.setWidth(width/6);
    votingControls.setBarHeight(height/40);   
  }
  
  //
  // Creates Grid Controls
  //
  void createGridControls(){
    // RandomizeGridButton
    controlP5.addBang(controlP5, RandomizeGrid, RandomizeGrid, 0, 0, width/36, width/36).setGroup(gridControls)
                                                                                      .setFont(SmallerUIFont)
                                                                                      .getCaptionLabel()
                                                                                      .setColor(0);
    // Clear Grid                                                                                                                   
    controlP5.addBang(controlP5, ClearGrid, ClearGrid, width*2/36, 0, width/36, width/36).setGroup(gridControls)
                                                                                       .setFont(SmallerUIFont)
                                                                                       .getCaptionLabel()
                                                                                       .setColor(0);     
    // % Chance of Being Alive Slider
    controlP5.addSlider(ChanceOfCellsBeingAlive, 1, 100, probabilityOfCellsBeingAlive, 0, width*2/36 , width/10, height/36).setGroup(gridControls)
                                                                                                                           .setFont(SmallerUIFont)
                                                                                                                           .setNumberOfTickMarks(100)
                                                                                                                           .showTickMarks(false)
                                                                                                                           .getCaptionLabel()
                                                                                                                           .setColor(0);    
    // Cells Per Row Slider
    controlP5.addSlider(CellsPerRowController, 10, 150, 10, 0, width*3/36 , width/10, height/36).setGroup(gridControls)
                                                                                              .setFont(SmallerUIFont)
                                                                                              .setNumberOfTickMarks(maxCellsPerRow-9)
                                                                                              .showTickMarks(false)
                                                                                              .getCaptionLabel()
                                                                                              .setColor(0); 
    // Cells Per Column Slider
    controlP5.addSlider(CellsPerColumnController, 10, 150, 10, 0, width*4/36 , width/10, height/36).setGroup(gridControls)
                                                                                              .setFont(SmallerUIFont)
                                                                                              .setNumberOfTickMarks(maxCellsPerColumn-9)
                                                                                              .showTickMarks(false)
                                                                                              .getCaptionLabel()
                                                                                              .setColor(0); 
                                                                                       
  }
  
  
  //
  // Creates Game of Life Controls
  //
  void createGameOfLifeControls(){
    // Add iteration text
    controlP5.addTextlabel("Iterations Text", "Iterations:", 0, 0).setGroup(gameOfLifeControls)
                                                                                           .setFont(SmallerUIFont)
                                                                                           .setColor(0); ;
    
    // One iteration                                                                                                                  
    controlP5.addBang(controlP5, OneIteration, OneIteration, 0, width/72, width/36, width/36).setGroup(gameOfLifeControls)
                                                                                           .setFont(SmallerUIFont)
                                                                                           .getCaptionLabel()
                                                                                           .setColor(0);   
                                                                                           
    // Multiple iterations                                                                                                                 
    controlP5.addBang(controlP5, MultipleIterations, MultipleIterations, width*2/36, width/72, width/36, width/36).setGroup(gameOfLifeControls)
                                                                                           .setFont(SmallerUIFont)
                                                                                           .getCaptionLabel()
                                                                                           .setColor(0);        
                                                                                               
    // Iterate forever toggle    
    controlP5.addToggle(controlP5, InfiniteIterations, InfiniteIterations, false, width*4/36, width/72, width/36, width/36).setGroup(gameOfLifeControls)
                                                                                                                             .setColorForeground(hoveredToggleColor)
                                                                                                                             .setColorBackground(inactiveToggleColor)
                                                                                                                             .setColorActive(activeToggleColor)
                                                                                                                             .setFont(SmallerUIFont)
                                                                                                                             .getCaptionLabel()
                                                                                                                             .setColor(0);
                                                                                                                             
    // Stop Iterating                                                                                                                
    controlP5.addBang(controlP5, StopIterating, StopIterating, width*6/36, width/72, width/36, width/36).setGroup(gameOfLifeControls)
                                                                                                           .setFont(SmallerUIFont)
                                                                                                           .getCaptionLabel()
                                                                                                           .setColor(0);                                                                                                                              
    // Number of iterations slider
    controlP5.addSlider(TotalIterations, 1, 100, 1, 0, width*5/72 , width/10, height*2/72).setGroup(gameOfLifeControls)
                                                                                        .setFont(SmallerUIFont)
                                                                                        .setNumberOfTickMarks(100)
                                                                                        .showTickMarks(false)
                                                                                        .getCaptionLabel()
                                                                                        .setColor(0); 
    // Time between iterations slider
    controlP5.addSlider(TimeBetweenIterations, .01, 5, 1, 0, width*7/72 , width/10, height*2/72).setGroup(gameOfLifeControls)
                                                                                              .setFont(SmallerUIFont)
                                                                                              .setNumberOfTickMarks(500)
                                                                                              .showTickMarks(false)
                                                                                              .getCaptionLabel()
                                                                                              .setColor(0);
                                                                                              
   
  }
  
  
  //
  // Creates Audio Controls
  //
  void createAudioControls(){
    // Play Notes                                                                                                                  
    controlP5.addBang(controlP5, PlayNotes, PlayNotes, 0, 0, width/36, width/36).setGroup(audioControls)
                                                                                       .setFont(SmallerUIFont)
                                                                                       .getCaptionLabel()
                                                                                       .setColor(0);  
    // Save notes to track 1
    controlP5.addBang(controlP5, AddToTrack, AddToTrack, 0, width*2/36, width/36, width/36).setGroup(audioControls)
                                                                                       .setFont(SmallerUIFont)
                                                                                       .getCaptionLabel()
                                                                                       .setColor(0); 
  }
  
  
  //
  // Create Voting Controls
  //
  void createVotingControls(){
    // Counting Neighbors Toggle 
    controlP5.addToggle(controlP5, ShowingNeighbors, ShowingNeighbors, false, 0,0, width/36, width/36).setGroup(votingControls)
                                                                                                                             .setColorForeground(hoveredToggleColor)
                                                                                                                             .setColorBackground(inactiveToggleColor)
                                                                                                                             .setColorActive(activeToggleColor)
                                                                                                                             .setFont(SmallerUIFont)
                                                                                                                             .getCaptionLabel()
                                                                                                                             .setColor(0); 
    // Allow more than one winner per column toggle   
    controlP5.addToggle(controlP5, AllowMoreThanOneWinner, AllowMoreThanOneWinner, false, 0, width*2/36, width/36, width/36).setGroup(votingControls)
                                                                                                                             .setColorForeground(hoveredToggleColor)
                                                                                                                             .setColorBackground(inactiveToggleColor)
                                                                                                                             .setColorActive(activeToggleColor)
                                                                                                                             .setFont(SmallerUIFont)
                                                                                                                             .getCaptionLabel()
                                                                                                                             .setColor(0);

  }
  
  
  // Event handler for all controller events
  void newControlEvent(ControlEvent theEvent){
    if(theEvent.isController()){ // Checking to make sure the ControlEvent corresponds to a controller
      
      //
      // GRID CONTROLS
      //
      
      if(theEvent.getController().getName() == RandomizeGrid){ // Randomizing Grid
        gridController.generateRandomCells();
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
        gridController.clearGrid();
        iteratingForever = false;
        countNeighbors(); // Count and mark the cells with the most neighbors
      }
      else if(theEvent.getController().getName() == CellsPerRowController){ // Adjusts number of cells per row
        gridController.resizeGrid((int)controlP5.getController(CellsPerRowController).getValue(), cellsPerColumn);
      }   
      else if(theEvent.getController().getName() == CellsPerColumnController){ // Adjusts number of cells per column
        gridController.resizeGrid(cellsPerRow, (int)controlP5.getController(CellsPerColumnController).getValue());
      }   
      
      //
      // GAME OF LIFE CONTROLS
      //
      
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
      else if(theEvent.getController().getName() == StopIterating){ // Stop Iterating
         totalNumberOfIterations = currentNumberOfIterations;
      }
      
      //
      // AUDIO CONTROLS
      //
      
      else if(theEvent.getController().getName() == PlayNotes){ // PlayNotes
        playNotes();
      }
      else if(theEvent.getController().getName() == AddToTrack){ // Save to AudioTrack1
        saveNotes();
      }    
      //
      // VOTING CONTROLS
      //
      
      else if(theEvent.getController().getName() == ShowingNeighbors){ // Count Neighbors
         showingNeighborVotes = !showingNeighborVotes;
      }
      else if(theEvent.getController().getName() == AllowMoreThanOneWinner){ // Allow more than one winner per column
         allowMoreThanOneWinnerPerColumn = !allowMoreThanOneWinnerPerColumn;
         countNeighbors(); //
      }       
    }
  }
}
