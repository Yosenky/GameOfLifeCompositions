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
