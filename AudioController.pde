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
          out.playNote( noteStartTime, noteDuration, new SineInstrument( 300 + 20*j) );
          noteStartTime += noteDuration;
          println(noteStartTime);
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
    
}
