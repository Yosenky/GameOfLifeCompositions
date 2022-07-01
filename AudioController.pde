// Audio Controller Class
// Object containing methods related to audio output and audio generation

//
// AUDIO VARIABLES
//
Minim minim;
AudioOutput out;

float noteDuration = .25; // Duration of each note, in seconds

public class AudioController{
 
  public AudioController(){} // Empty constructor
  
  
  // Saves notes to an audio track
  void saveNotes(){
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
  }
  
  
  // Plays notes based on neighbors
  void playNotes(){
    out.resumeNotes();
  }
  
  
  // Changes the note duration
  void setNoteDuration(float newNoteDuration){
    noteDuration = newNoteDuration;
  }
    
}
