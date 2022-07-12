// Controls Controller Class
// Object for use controlling the controlP5 objects and events
// Contains methods for creating and using controlP5 controls



public class ControlsController{
  
  public ControlsController(){} // Empty constructor
  
 
  // Sets up all controls
  void setupControls(){
    createFonts();
    createControlGroups();
    createGridControls();
    createGameOfLifeControls();
    createMinimControls();
    createBeadsControls();
    createVotingControls(); 
    createCommunicationControls();
  }
  
  
  // Creates all fonts for use in UI
  void createFonts(){
    BarFont       = createFont("unispaceregular.ttf",width/96);
    UIFont        = createFont("Candal.ttf",24);
    SmallerUIFont = createFont("MonospaceTypewriter.ttf", 14);
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
    
    // Minim controls
    minimControls = controlP5.addGroup("Minim Controls", halfwayLineX + 15, height*20/30);
    minimControls.setBackgroundHeight((height*34/40)/2);
    minimControls.setWidth(width/6);
    minimControls.setBarHeight(height/40);    

    // Voting controls
    votingControls = controlP5.addGroup("Voting Controls", halfwayLineX * 3/2, height*2/30);
    votingControls.setBackgroundHeight((height*34/40)/2);
    votingControls.setWidth(width/6);
    votingControls.setBarHeight(height/40); 
    
    // Communication Controls
    communicationControls = controlP5.addGroup("Communication Controls", halfwayLineX * 3/2, height*10/30);
    communicationControls.setBackgroundHeight((height*34/40)/2);
    communicationControls.setWidth(width/6);
    communicationControls.setBarHeight(height/40); 
    
    // Beads controls
    beadsControls = controlP5.addGroup("Beads Controls", halfwayLineX * 3/2, height*20/30);
    beadsControls.setBackgroundHeight((height*34/40)/2);
    beadsControls.setWidth(width/6);
    beadsControls.setBarHeight(height/40); 
  }
  
  //
  // Creates Grid Controls
  //
  void createGridControls(){
    // RandomizeGridButton
    controlP5.addBang(RandomizeGrid)
             .setBroadcast(false) // Prevents controller from sending events when program starts
             .setPosition(0,0)
             .setSize(width/36,width/36)
             .setGroup(gridControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);
             
    // Clear Grid                                                                                                                   
    controlP5.addBang(ClearGrid)
             .setBroadcast(false)
             .setPosition(width*2/36, 0)
             .setSize(width/36,width/36)
             .setGroup(gridControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);  
             
    // % Chance of Being Alive Slider
    controlP5.addSlider(ChanceOfCellsBeingAlive)
             .setBroadcast(false)
             .setPosition(0,width*2/36)
             .setSize(width/10, height/36)
             .setRange(1,100)
             .setValue(probabilityOfCellsBeingAlive)
             .setGroup(gridControls)
             .setFont(SmallerUIFont)
             .setNumberOfTickMarks(100)
             .showTickMarks(false)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);  
             
    // Cells Per Row Slider
    controlP5.addSlider(CellsPerRow)
             .setBroadcast(false)
             .setPosition( 0, width*3/36 )
             .setSize(width/10, height/36)
             .setRange(minCellsPerRow, maxCellsPerRow)
             .setValue(cellsPerRow)
             .setGroup(gridControls)
             .setFont(SmallerUIFont)
             .setNumberOfTickMarks((maxCellsPerRow-minCellsPerRow)+1)
             .showTickMarks(false)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0); 
             
    // Cells Per Column Slider
    controlP5.addSlider(CellsPerColumn)
             .setBroadcast(false)
             .setPosition( 0, width*4/36 )
             .setSize(width/10, height/36)
             .setRange(minCellsPerRow, maxCellsPerRow)
             .setValue(cellsPerColumn)
             .setGroup(gridControls)
             .setFont(SmallerUIFont)
             .setNumberOfTickMarks((maxCellsPerRow-minCellsPerRow)+1)
             .showTickMarks(false)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);                                                                                        
  }
  
  
  //
  // Creates Game of Life Controls
  //
  void createGameOfLifeControls(){
    // Add iteration text
    controlP5.addTextlabel(IterationsText)
             .setBroadcast(false)
             .setPosition(0,0)
             .setValue(IterationsText)
             .setGroup(gameOfLifeControls)
             .setFont(SmallerUIFont)
             .setColor(0)
             .setBroadcast(true);
    
    // One iteration 
    controlP5.addBang(OneIteration)
             .setBroadcast(false)
             .setPosition(0, width/72)
             .setSize(width/36,width/36)
             .setGroup(gameOfLifeControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);       
                                                                                           
    // Multiple iterations
    controlP5.addBang(MultipleIterations)
             .setBroadcast(false)
             .setPosition(width*2/36, width/72)
             .setSize(width/36,width/36)
             .setGroup(gameOfLifeControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);           
                                                                                        
    // Iterate forever toggle    
    controlP5.addToggle(InfiniteIterations)
             .setBroadcast(false)
             .setValue(false)
             .setPosition(width*4/36,width/72)
             .setSize(width/36,width/36)
             .setGroup(gameOfLifeControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);
                                                                                                                             
    // Stop Iterating  
    controlP5.addBang(StopIterating)
             .setBroadcast(false)
             .setPosition(width*6/36, width/72)
             .setSize(width/36,width/36)
             .setGroup(gameOfLifeControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);   
                                                                                                                              
    // Number of iterations slider
    controlP5.addSlider(TotalIterations)
             .setBroadcast(false)
             .setPosition(0, width*5/72)
             .setSize(width/10, height*2/72)
             .setRange(1,100)
             .setValue(1)
             .setGroup(gameOfLifeControls)
             .setFont(SmallerUIFont)
             .setNumberOfTickMarks(100)
             .showTickMarks(false)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);

    // Time between iterations slider
    controlP5.addSlider(IterationLength)
             .setBroadcast(false)
             .setPosition(0, width*7/72)
             .setSize(width/10, height*2/72)
             .setRange(.01, 5)
             .setValue(1)
             .setGroup(gameOfLifeControls)
             .setFont(SmallerUIFont)
             .setNumberOfTickMarks(500)
             .showTickMarks(false)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);   
             
    // Iterate then play 
    controlP5.addBang(IterateThenPlay)
             .setBroadcast(false)
             .setPosition(0, width*17/144)
             .setSize(width/36,width/36)
             .setGroup(gameOfLifeControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);                
  }
  
  
  //
  // Creates Minim Controls
  //
  void createMinimControls(){
    // Play Notes
    controlP5.addBang(PlayNotes)
             .setBroadcast(false)
             .setPosition(0,0)
             .setSize(width/50,width/50)
             .setGroup(minimControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);      
 
    // Save notes to track 1
    controlP5.addBang(AddToTrack1)
             .setBroadcast(false)
             .setPosition(0, width*2/50)
             .setSize(width/50,width/50)
             .setGroup(minimControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0); 

    // Save notes to track 2
    controlP5.addBang(AddToTrack2)
             .setBroadcast(false)
             .setPosition(width*4/36, width*2/50)
             .setSize(width/50,width/50)
             .setGroup(minimControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);  
             
    // Toggle Track1
    controlP5.addToggle(ToggleTrack1)
             .setBroadcast(false)
             .setValue(false)
             .setPosition(0,width*4/50)
             .setSize(width/50,width/50)
             .setGroup(minimControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);
             
    // Toggle Track2
    controlP5.addToggle(ToggleTrack2)
             .setBroadcast(false)
             .setValue(false)
             .setPosition(width*4/36,width*4/50)
             .setSize(width/50,width/50)
             .setGroup(minimControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);             
             
    // Play current grid's notes
    controlP5.addBang(PlayCurrentGrid)
             .setBroadcast(false)
             .setPosition(width*4/36,0)
             .setSize(width/50,width/50)
             .setGroup(minimControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);           
             
    // Note duration slider
    controlP5.addSlider(NoteDuration)
             .setBroadcast(false)
             .setPosition(0, width*6/50)
             .setSize(width/10, height/36)
             .setRange(.05, 2)
             .setValue(.25)
             .setGroup(minimControls)
             .setFont(SmallerUIFont)
             .setNumberOfTickMarks(40)
             .showTickMarks(false)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);  
             
  }
  
  
  //
  // Create Beads Controls
  //
  void createBeadsControls(){
    // Play grid using beads
    controlP5.addBang(PlayGridUsingBeads)
             .setBroadcast(false)
             .setPosition(0,0)
             .setSize(width/50,width/50)
             .setGroup(beadsControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0); 
             
    // Adjust transition time between notes
    controlP5.addSlider(BeadsNotesTransitionTimes)
             .setBroadcast(false)
             .setPosition(0, width*2/50)
             .setSize(width/10, height/36)
             .setRange(.5, 3)
             .setValue(1)
             .setGroup(beadsControls)
             .setFont(SmallerUIFont)
             .setNumberOfTickMarks(6)
             .showTickMarks(false)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);  
  }

  
  //
  // Create Voting Controls
  //
  void createVotingControls(){
    // Counting Neighbors Toggle 
    controlP5.addToggle(ShowingNeighbors)
             .setBroadcast(false)
             .setValue(false)
             .setPosition( 0,0)
             .setSize(width/36,width/36)
             .setGroup(votingControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);
             
    // Showing alive cells toggle
    controlP5.addToggle(ShowAliveCells)
             .setBroadcast(false)
             .setValue(true)
             .setPosition(width*4/36,0)
             .setSize(width/36,width/36)
             .setGroup(votingControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);             
 
    // Allow more than one winner per column toggle
    controlP5.addToggle(AllowMoreThanOneWinner)
             .setBroadcast(false)
             .setValue(false)
             .setPosition(0, width*2/36)
             .setSize(width/36,width/36)
             .setGroup(votingControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0); 
  }
  
  
  //
  // Create Communication Controls
  //
  void createCommunicationControls(){
    // Receiving messages toggle
    controlP5.addToggle(ReceivingMessages)
             .setBroadcast(false)
             .setValue(false)
             .setPosition(0, 0)
             .setSize(width/36,width/36)
             .setGroup(communicationControls)
             .setColorForeground(hoveredToggleColor)
             .setColorBackground(inactiveToggleColor)
             .setColorActive(activeToggleColor)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
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
        gameOfLifeController.countNeighbors();
        currentNumberOfIterations = 0;
        totalNumberOfIterations = 0;
        gameOfLifeController.countNeighbors(); // Count and mark the cells with the most neighbors
      }
      else if(theEvent.getController().getName() == ChanceOfCellsBeingAlive){ // Changing % of cells that are likely to be alive
        probabilityOfCellsBeingAlive = (int)controlP5.getController(ChanceOfCellsBeingAlive).getValue();
      }
      else if(theEvent.getController().getName() == ClearGrid){ // Clear Grid
        currentNumberOfIterations = 0;
        totalNumberOfIterations = 0;
        gridController.clearGrid();
        iteratingForever = false;
        controlP5.getController(InfiniteIterations).setValue(0);
        gameOfLifeController.countNeighbors(); // Count and mark the cells with the most neighbors
      }
      else if(theEvent.getController().getName() == CellsPerRow){ // Adjusts number of cells per row
        gridController.resizeGrid((int)controlP5.getController(CellsPerRow).getValue(), cellsPerColumn);
        iteratingForever = false;
        controlP5.getController(InfiniteIterations).setValue(0);
      }   
      else if(theEvent.getController().getName() == CellsPerColumn){ // Adjusts number of cells per column
        gridController.resizeGrid(cellsPerRow, (int)controlP5.getController(CellsPerColumn).getValue());
        iteratingForever = false;
        controlP5.getController(InfiniteIterations).setValue(0);
      }   
      
      //
      // GAME OF LIFE CONTROLS
      //
      
      else if(theEvent.getController().getName() == OneIteration){ // Single iteration
        currentNumberOfIterations = 1;
        totalNumberOfIterations = 1;
        gameOfLifeController.gameOfLife();
        lastRecordedTime = millis();
      }
      else if(theEvent.getController().getName() == MultipleIterations){ // Multiple Iterations
        currentNumberOfIterations = 0;
        currentNumberOfIterations++;
        gameOfLifeController.gameOfLife();
        totalNumberOfIterations = (int)controlP5.getController(TotalIterations).getValue();
        lastRecordedTime = millis();    
      }
      else if(theEvent.getController().getName() == IterationLength){ // Time between iterations
        timeBetweenIterations = controlP5.getController(IterationLength).getValue() * 1000;
      }    
      else if(theEvent.getController().getName() == InfiniteIterations){ // Iterate Forever
         iteratingForever = controlP5.getController(InfiniteIterations).getValue() == 1; // If == 1, is true, else is false
      }
      else if(theEvent.getController().getName() == StopIterating){ // Stop Iterating
         totalNumberOfIterations = currentNumberOfIterations;
         controlP5.getController(InfiniteIterations).setValue(0);
      }
      else if(theEvent.getController().getName() == IterateThenPlay){ // Iterate the set amount of iterations, then play all notes that resulted
        currentNumberOfIterations = 0;
        currentNumberOfIterations++;
        gameOfLifeController.gameOfLife();
        totalNumberOfIterations = (int)controlP5.getController(TotalIterations).getValue();
        lastRecordedTime = millis();  
        iteratingThenPlaying = true;
        noteStartTime = 0; // resets the start time for the first note
        out.pauseNotes();
      }      
      //
      // MINIM CONTROLS
      //
      
      else if(theEvent.getController().getName() == PlayNotes){ // Play selected tracks
        if(controlP5.getController(ToggleTrack1).getValue() == 1){
          audioController.playNotes(track1);
        }
        if(controlP5.getController(ToggleTrack2).getValue() == 1){
          audioController.playNotes(track2);
        }
      }
      else if(theEvent.getController().getName() == AddToTrack1){ // Save notes to Track1
        audioController.saveNotes(track1);
      }
      else if(theEvent.getController().getName() == AddToTrack2){ // Save notes to Track2
        audioController.saveNotes(track2);
      }     
      else if(theEvent.getController().getName() == PlayCurrentGrid){ // Play the notes on the current grid
        audioController.playCurrentNotes();
      }        
      else if(theEvent.getController().getName() == PlayGridUsingBeads){ // Play the notes on the current grid using BEADS library
        audioController.playBeads();
      } 
      else if(theEvent.getController().getName() == NoteDuration){ // Time between iterations
        audioController.setNoteDuration(controlP5.getController(NoteDuration).getValue());
      }
      //
      // BEADS CONTROLS
      //
      
      //
      // VOTING CONTROLS
      //
      
      else if(theEvent.getController().getName() == ShowingNeighbors){ // Count Neighbors
         showingNeighborVotes = !showingNeighborVotes;
      }
      else if(theEvent.getController().getName() == ShowAliveCells){ // Shows alive cells(use for only seeing winners)
         showingAliveCells = controlP5.getController(ShowAliveCells).getValue() == 1;
      }
      else if(theEvent.getController().getName() == AllowMoreThanOneWinner){ // Allow more than one winner per column
         allowMoreThanOneWinnerPerColumn = !allowMoreThanOneWinnerPerColumn;
         gameOfLifeController.countNeighbors(); // Counts the neighbors of each cell and colors all winners
      }
      
      //
      // COMMUNICATION CONTROLS
      //
      else if(theEvent.getController().getName() == ReceivingMessages){ // Count Neighbors
         receivingMessages = !receivingMessages;
         println("Receiving messages = " + receivingMessages);
      }
    }
  }
}
