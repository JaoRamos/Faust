import("stdfaust.lib");

// para detectar MIDI
freq = vgroup("[6]MIDI", nentry("freq", 220, 20, 5000, 0.001));
gain = vgroup("[6]MIDI", nentry("gain", 0.0, 0.0, 1.0, 0.001));
gate = vgroup("[6]MIDI", nentry("gate", 0.0, 0.0, 1.0, 1.0));
escala = waveform{-1, 0, 2, 3, 5, 7, 9, 11, 12};

//nota(s) = ba.midikey2hz(36 + int(ba.hz2midikey(s : an.amp_follower(0.1) * 100)));


nota(f) = escala, int(min(f : an.amp_follower(0.1) * 15, 8)) : rdtable;



oscilador(s) = os.sawtooth(ba.midikey2hz(48 + nota(s))) *0.05;
  
process(s) = oscilador(s) * an.amp_follower(0.1) <: _, _;