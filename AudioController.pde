// Audio Controller Class
// Object containing methods related to audio output and audio generation



public class AudioController{
 
  public AudioController(){} // Empty constructor
  
  
  // Saves notes to an audio track
  void saveNotes(Note[] noteArray){
    float noteTime = 0;
    for(int i  = 0; i < cellsPerRow; i++){
      for(int j = 0; j < cellsPerColumn; j++){
        if(cells[i][j].getHasMaximumNeighbors()){
          noteArray[i] = new Note(noteTime, noteDuration, new SineInstrument(300 + 20*j));
          noteTime += noteDuration;
        }
      }
    }  
  }
  
  
  // Plays notes for the specified track based on their neighbors
  void playNotes(Note[] track){
    out.pauseNotes();
    for(int i = 0; i < cellsPerRow; i++){
      out.playNote(track[i].getNoteStartTime(), track[i].getNoteDuration(), track[i].getSineInstrument());
    }
    out.resumeNotes();
  }
  
  // Queues notes to be played later
  void queueNotes(){
   for(int i  = 0; i < cellsPerRow; i++){
      for(int j = 0; j < cellsPerColumn; j++){
        if(cells[i][j].getHasMaximumNeighbors()){
          out.playNote( noteStartTime, noteDuration, new SineInstrument( 300 + 20*j) ); // Add notes in each column to output, don't play yet
          noteStartTime += noteDuration;
        }
      }
    }  
  }
  
  
  // Plays ONLY the current grid's notes
  void playCurrentNotes(){
    out.pauseNotes();
    float noteTime = 0;
    for(int i  = 0; i < cellsPerRow; i++){
      for(int j = 0; j < cellsPerColumn; j++){
        if(cells[i][j].getHasMaximumNeighbors()){
          out.playNote( noteTime, noteDuration, new SineInstrument( 300 + 20*j) );
          noteTime += noteDuration;
        }
      }
    }
    out.resumeNotes();
  }
  
  
  // Changes the note duration
  void setNoteDuration(float newNoteDuration){
    noteDuration = newNoteDuration;
  }
  
  
  // Sets up the variables for the BEADS library
  void setupBeads(){
    ac = AudioContext.getDefaultContext();
    frequencyEnvelope = new Envelope(250);
    wp = new WavePlayer(frequencyEnvelope, Buffer.SINE); 
    masterGain = new beads.Gain(1,1);
    masterGain.addInput(wp);
  }
  
  // Plays the current grid using the BEADS library
  void playBeads(){
    for(int i  = 0; i < cellsPerRow; i++){
      for(int j = 0; j < cellsPerColumn; j++){
        if(cells[i][j].getHasMaximumNeighbors()){
          //if(cells[i][j].getNumberOfNeighbors() == 2){ // If cell has exactly 2 neighbors, use a tremolo on the note
           // Tremolo??
          //} else {
          frequencyEnvelope.addSegment(500 - 50*j, controlP5.getController(BeadsNotesTransitionTimes).getValue() * 1000);
          //}
        }
      }
    }
    frequencyEnvelope.addSegment(0,500);
    ac.out.addInput(masterGain);
    ac.start();
  }
    
}
