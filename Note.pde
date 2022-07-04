// Note class with methods pertaining to creation and modification of notes
// This makes it easy to store the notes in arrays for later re-use

public class Note{
  float noteStartTime; // Note start time, in ms
  float noteDuration; // Note duration, in seconds
  SineInstrument sineInstrument; // Sine Instrument
  
  // Constructor for sine instrument note
  public Note(float noteStartTime, float noteDuration, SineInstrument sineInstrument){
    this.noteStartTime = noteStartTime;
    this.noteDuration = noteDuration;
    this.sineInstrument = sineInstrument;
  }
  
  
  // getNoteStartTime returns noteStartTime
  float getNoteStartTime(){
   return noteStartTime; 
  }
  
  // getNoteDuration returns noteDuration
  float getNoteDuration(){
    return noteDuration;
  }
  
  // getSineInstrument returns sineInstrument
  SineInstrument getSineInstrument(){
   return sineInstrument; 
  }
  
  
  
}
