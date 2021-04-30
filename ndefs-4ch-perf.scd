// mic with delay and grain;
Ndef(\live, {HPF.ar(Pan4.ar(SoundIn.ar(2), MouseX.kr(-1, 1), MouseY.kr(-1, 1)),50)});
Ndef(\delay, {|decay= 7, delHz= 0.1, delMin= 0.05, delMax= 0.8|
	var sig= Ndef.ar(\live);
	HPF.ar(CombC.ar(sig, 0.5, SinOsc.kr(delHz*[1, 0.9, 0.8, 0.7]).exprange(delMin, delMax), decay),50);
});

//grain
g.free; g= Buffer.alloc(s, 3*s.sampleRate);
Ndef(\live2, {|t_trig= 0| HPF.ar(RecordBuf.ar(SoundIn.ar, g, loop:1, trigger: t_trig),50)}); //loop: 1 is live feed; loop: 0 is with capture;
//Ndef(\playback, {Pan2.ar(PlayBuf.ar(1, g, loop:1))}).play(vol:0.0);
Ndef(\live2).set(\t_trig, 1); //run this line every time
//then of course you can add more 'players' that read form the same buffer...
Ndef(\grain, {|rate= 1.68, dur= 0.1, panlr=0, panfb=0|
	LPF.ar(HPF.ar(Pan4.ar(
		(TGrains.ar(1, Dust.kr(4), g, rate, LFNoise2.kr(0.1)+1/2, dur, 0, 3)), panlr, panfb)
	,50),16000);
});

//adjustments
Ndef(\live).vol= 0;
Ndef(\delay).vol= 0.5;
Ndef(\live2).vol= 1;
Ndef(\grain).vol= 0.4;
Ndef(\delay).play;
Ndef(\grain).play;
Ndef(\live2).play;
//Ndef(\live).play;