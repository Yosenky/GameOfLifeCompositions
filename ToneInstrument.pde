// Copied from GridMusic/Minim documentation and then modified by jrkm
// Controls instruments for audio output

class ToneInstrument implements Instrument
{
  Oscil oscillator;
  ddf.minim.ugens.ADSR adsr; // Have to specify that it's minim's adsr
  
  ToneInstrument( float frequency, float amplitude, AudioOutput output, float[] opts, Waveform wf)
  {
    out = output;
    oscillator = new Oscil( frequency, amplitude, wf);
    adsr = new ddf.minim.ugens.ADSR( 0.1, opts[0], opts[1], opts[2], opts[3]);
    oscillator.patch(adsr);
  }
 
  void noteOn(float dur)
  { 
    adsr.patch(out);
    adsr.noteOn();
  }
 
  void noteOff()
  { 
    adsr.noteOff();
    adsr.unpatchAfterRelease(out); 
  }
}
