//TODO why is \live2 panned to left?

// mic with delay and grain;
Ndef(\live, {HPF.ar(Pan2.ar(SoundIn.ar([0,1]), 0.0),50)}); //SoundIn probably needs to be 1 for two channels and 2 for 4 channels


Ndef(\delay, {|decay= 7, delHz= 0.1, delMin= 0.05, delMax= 0.8, panlr=0|
	var sig= Ndef.ar(\live);
	HPF.ar(Pan2.ar(CombC.ar(sig, 0.5, SinOsc.kr(delHz*[1, 0.9, 0.8, 0.7]).exprange(delMin, delMax), decay),panlr),50);
});

//grain
g.free; g= Buffer.alloc(s, 3*s.sampleRate);
Ndef(\live2, {|t_trig= 0| HPF.ar(RecordBuf.ar(SoundIn.ar, g, loop:1, trigger: t_trig),50)}); //loop: 1 is live feed; loop: 0 is with capture;
//Ndef(\playback, {Pan2.ar(PlayBuf.ar(1, g, loop:1))}).play(vol:0.0);
Ndef(\live2).set(\t_trig, 1); //run this line every time
//then of course you can add more 'players' that read form the same buffer...
Ndef(\grain, {|rate= 1.68, dur= 0.1, panlr=0|
	LPF.ar(HPF.ar(Pan2.ar(
		(TGrains.ar(1, Dust.kr(4), g, rate, LFNoise2.kr(0.1)+1/2, dur, 0, 3)), panlr)
	,50),16000);
});
