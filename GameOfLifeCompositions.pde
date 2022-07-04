import netP5.*;
import oscP5.*;

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
// COMMUNICATION VARIABLES
//
OscP5 oscP5;
NetAddress myRemoteLocation;

boolean receivingMessages = false; // If true, allow messages to be received

//
// GRID VARIABLES
//

// Parameters for grid size
int cellsPerRow    = 50;
int cellsPerColumn = 50;
float cellWidth;
float cellHeight;
int halfwayLineX; // X coordinate for line that cuts screen in half
int maxCellsPerRow = 150;
int maxCellsPerColumn = 150;
int minCellsPerRow = 8;
int minCellsPerColumn = 8;

// Cell Arrays
Cell[][] cells;
Cell[][] cellsBuffer;

// Cell colors
color aliveColor = color(103,102,165);
color deadColor = color(227,124,124);

// Grid Generation
int probabilityOfCellsBeingAlive = 20; // In percent, default is 15

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
boolean showingAliveCells = true; // If false, hides alive cells
boolean iteratingThenPlaying = false; // If true, iterates the set amount, then plays all notes at once
float noteStartTime = 0; // Note start time, used when iterating then playing

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
String IterateThenPlay = "Iterate then play";

// Audio Controls
String PlayNotes = "Play selected tracks";
String NoteDuration = "Note Duration(s)";
String AddToTrack1 = "Save to track 1";
String AddToTrack2 = "Save to track 2";
String ToggleTrack1 = "Track 1";
String ToggleTrack2 = "Track 2";
String PlayCurrentGrid = "Play current grid";

// Voting Controls
String ShowingNeighbors = "Show Most Neighbors";
String AllowMoreThanOneWinner = "Allow more than one winner per column";
String ShowAliveCells = "Show alive cells";

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

//
// AUDIO VARIABLES
//
Minim minim;
AudioOutput out;

float noteDuration = .25; // Duration of each note, in seconds
Note[] track1 = new Note[maxCellsPerRow];
Note[] track2 = new Note[maxCellsPerRow];

//
// OBJECT VARIABLES
//
GridController gridController; // Contains methods for manipulating the grid of cells
ControlsController controlsController; // Contains methods for generation of controls and handling of events
AudioController audioController; // Contains methods for generating and playing audio
GameOfLifeController gameOfLifeController; // Contains methods pertaining to the game of life
CommunicationController communicationController; // Contains methods pertaining to communication with other programs



void setup(){
  //fullScreen();
  size(1800,950);
  
  // OBJECT INITIALIZATION
  gridController = new GridController();
  controlsController = new ControlsController();
  audioController = new AudioController();
  gameOfLifeController = new GameOfLifeController();
  communicationController = new CommunicationController();
  
  
  // Initializing grid
  gridController.initializeGrid();

  // ControlP5 initialization
  controlP5 = new ControlP5(this);
  controlsController.setupControls();
  
  // Minim initialization
  minim = new Minim(this);
  out = minim.getLineOut();
  
  // OscP5 initialization
  oscP5 = new OscP5(this,12000); // Starts oscP5, listening for incoming messages at port 12000
  myRemoteLocation = new NetAddress("127.0.1.1", 12000); // IP address and port number for this program
}


void draw(){  
  background(200);
  // Draws line to cut screen in half for controls
  strokeWeight(8);
  line(halfwayLineX,0,halfwayLineX,height);
  strokeWeight(1);
  
  // Drawing grid
  gridController.drawGrid();
 
  // Checking for user input
  gridController.checkForInput();
  
  // Game Of Life iteration timer
  gameOfLifeController.iterationTimer();
  
  // Displays iteration text
  gameOfLifeController.displayIterationText();
}



// Event handler for all getControllers
void controlEvent(ControlEvent theEvent){
  controlsController.newControlEvent(theEvent);
}


// Osc message handler for all oscP5 messages
void oscEvent(OscMessage theOscMessage){
  if(receivingMessages){ 
   communicationController.receiveMessage(theOscMessage); 
  }
}
