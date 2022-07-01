// Controls Controller Class
// Object for use controlling the controlP5 objects and events
// Contains methods for creating and using controlP5 controls

//
// CONTROL P5 VARIABLES
//
ControlP5 controlP5;


//
// STRINGS FOR CONTROLLER NAMES
//

// Grid Controls
String RandomizeGrid = "Randomize";
String ChanceOfCellsBeingAlive = "Chance of life(%)";
String ClearGrid = "Clear";
String CellsPerRow = "Cells Per Row";
String CellsPerColumn = "Cells Per Column";

// Game of Life Controls
String OneIteration = "One";
String MultipleIterations = "Multiple";
String TotalIterations = "Iterations to queue";
String IterationLength = "Iteration length(s)";
String InfiniteIterations = "Infinite";
String StopIterating = "Stop";
String IterationsText = "Current Iteration: ";

// Audio Controls
String PlayNotes = "Play Notes";
String NoteDuration = "Note Duration(s)";
String AddToTrack = "Save to track";

// Voting Controls
String ShowingNeighbors = "Show Most Neighbors";
String AllowMoreThanOneWinner = "Allow more than one winner per column";

// Communication Controls
String ReceivingMessages = "Receive Messages";

// Colors
color activeToggleColor = color(14,220,55); // Color when toggle is active
color inactiveToggleColor = color(0,0,0); // Color when toggle is inactive
color hoveredToggleColor = color(80,80,80); // Color when toggle is being hovered over

// UI Fonts
PFont BarFont; // Font for bars at top of control groups
PFont UIFont; // Regular UI Font
PFont SmallerUIFont; // Smaller version of UI Font

// Control Groups
ControlGroup gridControls;
ControlGroup gameOfLifeControls;
ControlGroup audioControls;
ControlGroup votingControls;
ControlGroup communicationControls;


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
    createCommunicationControls();
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
    
    // Communication Controls
    communicationControls = controlP5.addGroup("Communication Controls", halfwayLineX * 3/2, height*10/30);
    communicationControls.setBackgroundHeight((height*34/40)/2);
    communicationControls.setWidth(width/6);
    communicationControls.setBarHeight(height/40);   
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
  }
  
  
  //
  // Creates Audio Controls
  //
  void createAudioControls(){
    // Play Notes
    controlP5.addBang(PlayNotes)
             .setBroadcast(false)
             .setPosition(0,0)
             .setSize(width/36,width/36)
             .setGroup(audioControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0);      
 
    // Save notes to track 1
    controlP5.addBang(AddToTrack)
             .setBroadcast(false)
             .setPosition(0, width*2/36)
             .setSize(width/36,width/36)
             .setGroup(audioControls)
             .setFont(SmallerUIFont)
             .setBroadcast(true)
             .getCaptionLabel()
             .setColor(0); 
             
    // Note duration slider
    controlP5.addSlider(NoteDuration)
             .setBroadcast(false)
             .setPosition(0, width*4/36)
             .setSize(width/10, height/36)
             .setRange(.05, 2)
             .setValue(.25)
             .setGroup(audioControls)
             .setFont(SmallerUIFont)
             .setNumberOfTickMarks(40)
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
        gameOfLifeController.countNeighbors(); // Count and mark the cells with the most neighbors
      }
      else if(theEvent.getController().getName() == CellsPerRow){ // Adjusts number of cells per row
        gridController.resizeGrid((int)controlP5.getController(CellsPerRow).getValue(), cellsPerColumn);
      }   
      else if(theEvent.getController().getName() == CellsPerColumn){ // Adjusts number of cells per column
        gridController.resizeGrid(cellsPerRow, (int)controlP5.getController(CellsPerColumn).getValue());
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
      
      //
      // AUDIO CONTROLS
      //
      
      else if(theEvent.getController().getName() == PlayNotes){ // PlayNotes
        audioController.playNotes();
      }
      else if(theEvent.getController().getName() == AddToTrack){ // Save to AudioTrack1
        audioController.saveNotes();
      }    
      else if(theEvent.getController().getName() == NoteDuration){ // Time between iterations
        audioController.setNoteDuration(controlP5.getController(NoteDuration).getValue());
      }    
      //
      // VOTING CONTROLS
      //
      
      else if(theEvent.getController().getName() == ShowingNeighbors){ // Count Neighbors
         showingNeighborVotes = !showingNeighborVotes;
      }
      else if(theEvent.getController().getName() == AllowMoreThanOneWinner){ // Allow more than one winner per column
         allowMoreThanOneWinnerPerColumn = !allowMoreThanOneWinnerPerColumn;
         gameOfLifeController.countNeighbors(); //
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