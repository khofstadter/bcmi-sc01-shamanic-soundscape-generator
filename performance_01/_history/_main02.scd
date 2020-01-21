// change noise to normal noise
// make it shorter (20 min?)

/* todo:
- charge batteries;
- make saline water;
- clear Android phone;
- test camera;
- make transition sound;
- add environmental sounds;
- check how to group Ndefs;
- try recording 4 channels in sc while recording with Screenflow and data;
r = Recorder(s);
r.record(numChannels:4);
r.stopRecording;


mix/sounds
- lower noise volume in the mix;
- mix with EQ and Freqscope;
- how to group Ndefs?
- maybe two main groups: 1) shaman 2) forest
- perhaps a visual mixer for the instruments would be nice;
- forest add breating guide wave: first faster in & out synced to paradiddle, later slower breathing, encourage the space between;
- make fade is swooshy sound (fades in with end on first beat,100,0.04,2600];

nf:
- phase syncrony is when the number (p3-p4).abs is stays close; (how close, does location distance matter);
- signal coherence is when the number (p3-p4).abs does not change over time much (it can be 1 or 0.1 or 11, but it should not change much from this number over time) - so two signals can be coherent evern if their phase is out of sync (my understanding is that their phase is still locked, but can be out of sync - their relationship remains the same - again, what about distance?_
- caclulate average theta in 30s > use for 50% threshold > and sound feedback;
- l/r coherance > sound feedback if more coherent;
- Fz theta wave  > straight mapping to sound (very subtle)
- other couters to change sound?


programming
- if I get rid of Accel data in DataRecord, will OpenBCI gui still read the file?
- make an if in reward that saves data in ~rec.extra only if EEG is on;
 - refine Ndef code, they don't have the same sytax
- do we need two t_trigs in the Ndef?
*/


// 1 - read EEG

//2
(
Server.killAll;
s.options.numOutputBusChannels= 4;
s.options.numInputBusChannels= 1;
s.reboot;
s.meter;
s.waitForBoot {
	~pathway= thisProcess.nowExecutingPath.dirname;
	(~pathway++"/ndefs04.scd").load;
	(~pathway++"/shaman02.scd").load;
	(~pathway++"/forest04.scd").load;
	(~pathway++"/reward03.scd").load;
	// start a new tempoClock
	// cannot rely on default tempoClock in the background
	t= TempoClock.new(4,16);
};
//s.plotTree;
//NdefMixer(s);
)

// record EEG and music data:
//!!!! rewise data format e.g. shall we write coherance measurements in here?
(
//start recording eeg and extra data:
var recorder= DataRecord(~openbci);
recorder.extra=[~energyTheta,~hiThetaEnergy,~energyTheta,~hiThetaEnergy,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]];
~rec= recorder.start;

// just forest, no shaman
~forestDepth2.valueArray(~forest[0]);//no drumming;
~reward.play;
)

// is file saved with extra?
~rec.path.openOS;  //open file we just recorded in text editor




//adjust threshold manually:
~hiThetaEnergy=  10;


//schedule the movements in the forest:

(

var schedCurve= Array.geom(15, 1, 1.25).normalize(0, 1800).asInt;
//Array.geom(15, 1, 1.25).normalize(0, 1800).plot;
// > [ 0, 20, 46, 78, 119, 169, 233, 312, 410, 534, 688, 881, 1122, 1423, 1800 ]

SystemClock.sched(schedCurve[0],{ ~forestDepth2.valueArray(~forest[1]);});
SystemClock.sched(schedCurve[1],{ ~forestDepth2.valueArray(~forest[2]);});
SystemClock.sched(schedCurve[2],{ ~forestDepth2.valueArray(~forest[3]);});
SystemClock.sched(schedCurve[3],{ ~forestDepth2.valueArray(~forest[4]);});
SystemClock.sched(schedCurve[4],{ ~forestDepth2.valueArray(~forest[5]);});
SystemClock.sched(schedCurve[5],{ ~forestDepth2.valueArray(~forest[6]);});
SystemClock.sched(schedCurve[6],{ ~forestDepth2.valueArray(~forest[7]);});
SystemClock.sched(schedCurve[7],{ ~forestDepth2.valueArray(~forest[8]);});
SystemClock.sched(schedCurve[8],{ ~forestDepth2.valueArray(~forest[9]);});
SystemClock.sched(schedCurve[9],{ ~forestDepth2.valueArray(~forest[10]);});
SystemClock.sched(schedCurve[10],{ ~forestDepth2.valueArray(~forest[11]);});
SystemClock.sched(schedCurve[11],{ ~forestDepth2.valueArray(~forest[12]);});
SystemClock.sched(schedCurve[12],{ ~forestDepth2.valueArray(~forest[13]);});
SystemClock.sched(schedCurve[13],{ ~forestDepth2.valueArray(~forest[14]);});
SystemClock.sched(schedCurve[14],{
	~forestDepth2.valueArray(~forest[15]);
	SystemClock.sched(16,{
	~forestDepth2.valueArray(~forest[16]); //stop drums, fade out wind;
	~reward.stop;//stop
	~timer = [0,0,0,0];});//reset - perhaps better to write something more distinct in here?
}); //tripplets (triplets)

)


// additional live mic DSP

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
Ndef(\grain, {|rate= 1.68, dur= 0.1|
	Pan4.ar(
		(TGrains.ar(1, Dust.kr(4), g, rate, LFNoise2.kr(0.1)+1/2, dur, 0, 3)), MouseX.kr(-1, 1), MouseY.kr(-1, 1))
});
Ndef(\grain).vol= 0;
)

)
