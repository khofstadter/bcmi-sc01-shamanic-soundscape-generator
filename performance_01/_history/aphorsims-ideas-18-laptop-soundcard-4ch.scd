/*todo:
- make/print recital hall signs;
- chairs;
- batteries?
- p3-s1 and ps3-s2 (seperate stems in Reaper);
- fade out p3-s1;
- add Limiter to delay and grain;
*/


/* start;
mac volume on max (computer vol control on in MOTU);
all sample rate on 44.1Hz;
ULTRALIGHT selected as in and out as default audio;
*/

Server.killAll;
Ndef.clear;

// 1 -
(
s.options.numOutputBusChannels= 4;
s.options.sampleRate = 44100; //same as above audio devices (AUDIO MIDI SETUP);
s.reboot;
s.meter;
NdefMixer(s);
)

// 2 - mic and delay and grain;
( // mic and delay, needs to be played as well - used editor?;
Ndef(\live, {Pan4.ar(SoundIn.ar, MouseX.kr(-1, 1), MouseY.kr(-1, 1))});  //quad
Ndef(\live).vol= 0;
Ndef(\delay, {|decay= 7, delHz= 0.1, delMin= 0.05, delMax= 0.8|
	var sig= Ndef.ar(\live);
	CombC.ar(sig, 0.5, SinOsc.kr(delHz*[1, 0.9, 0.8, 0.7]).exprange(delMin, delMax), decay);
});
Ndef(\delay).vol= 0;


//grain
(
g.free; g= Buffer.alloc(s, 3*s.sampleRate);
Ndef(\live2, {|t_trig= 0| RecordBuf.ar(SoundIn.ar, g, loop:1, trigger: t_trig)}); //loop: 1 is live feed; loop: 0 is with capture;
Ndef(\live2).vol= 0;
//Ndef(\playback, {Pan2.ar(PlayBuf.ar(1, g, loop:1))}).play(vol:0.0);
);

(
Ndef(\live2).set(\t_trig, 1); //run this line every time
//then of course you can add more 'players' that read form the same buffer...
Ndef(\grain, {|rate= 1, dur= 0.05|
	Pan4.ar(
		(TGrains.ar(1, Dust.kr(4), g, rate, LFNoise2.kr(0.1)+1/2, dur, 0, 3)), MouseX.kr(-1, 1), MouseY.kr(-1, 1))
});
Ndef(\grain).vol= 0;
)

)

// 3 - Function to play samples:
(
~playSample = { |name, buf, v, l|
	Ndef((\++~whichPart++name).asSymbol).vol= v;
	Ndef((\++~whichPart++name).asSymbol, {Pan4.ar(PlayBuf.ar(2, buf, loop: l), MouseX.kr(-1, 1), MouseY.kr(-1, 1)) }).play;
	if(l==0,
		{ Routine {
			(buf.duration.postln).wait;
		Ndef((\++~whichPart++name).asSymbol).stop
		}.play},
		{} // if looped (1) don't stop;
	);
}
)
)

// ----------------------------------------
// part 2
// ----------------------------------------
// 1. READ BUFFERS;
(
~whichPart = "p2_s";
// read buffers:
a.free; a = Buffer.read(s, "sounds/p2-s2-whispering-v01.wav".resolveRelative);
b.free; b = Buffer.read(s, "sounds/p2-s3-words-spaces-random-rx-v01.wav".resolveRelative);
)

// PLAY WHEN NEEDED:
~playSample.value(2,a,0.07,0); //name, bufnum, volume, loop;
~playSample.value(3,b,0.05,0); //name, bufnum, volume, looped - 2x;

// ----------------------------------------
// part 3
// ----------------------------------------
// 1. READ BUFFERS;
(
~whichPart = "p3_s";
// read buffers:
c.free; c = Buffer.read(s, "sounds/p3-s1-crackling-bowl-words-v02-st.wav".resolveRelative);
d.free; d = Buffer.read(s, "sounds/p3-s2-bowl-singing-v01-st.wav".resolveRelative);
)


// these make the sounds:
~playSample.value(1,c,0.1,0); //name, bufnum, volume, loop;
~playSample.value(2,d,0.1,0); //name, bufnum, volume, loop;