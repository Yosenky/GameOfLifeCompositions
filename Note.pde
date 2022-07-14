// Note class with methods pertaining to creation and modification of notes
// This makes it easy to store the notes in arrays for later re-use

public class Note{
  float noteStartTime; // Note start time, in ms
  float noteDuration; // Note duration, in seconds
  ToneInstrument toneInstrument; // Sine Instrument
  
  // Constructor for sine instrument note
  public Note(float noteStartTime, float noteDuration, ToneInstrument toneInstrument){
    this.noteStartTime = noteStartTime;
    this.noteDuration = noteDuration;
    this.toneInstrument = toneInstrument;
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
  ToneInstrument getToneInstrument(){
   return toneInstrument; 
  }
  
  
  
}
