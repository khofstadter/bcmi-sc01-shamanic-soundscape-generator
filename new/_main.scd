//TODO better way to choose between 2 or 4 channels: perhaps two vars 1: [st~quad] 2: [test~perf] that changes all settings in all files?
//TODO plotting with audio
//TODO reduce nb of levels
//TODO timer that can move between levels
//TODO add timer that counts whole session?

/*
--------------------
PERSONAL TEST AGENDA
--------------------
1. before session
- make space on hdd
- switch wifi/dropbox/screensaver off
- prep iPhone (airplane mode, silent, wifi-BLU off, auto lock: never, lock iPhone camera screen)

2. session:
- top of questionnaire while putting EEG cap on
- start up Screenflow (don't start recording)
- all audio to 48k in Audio Midi
- start screen-recording [configure] iphone + internal mic, computer audio, screen
- check timeseries and impedance - adjust impedance, close this file
- start 'openbci_gui_fftplot_with_neurofeedback-2ch.scd', reduce 50hz noise, show only bandwidths signal
- start
- start reward play with forest 0 (no drumming)
	+ DataRecord
- check that extra is saved in text file
- manually adjust threshold for theta/gamma
- schedule all cues

--------------------
 PERFORMANCE AGENDA
--------------------
in sc
- adjust volume
- test 4 speakers with sinwaves (performance code is 1243 instead of 1234)

1h BEFORE PRESENTATION:
- no screensaver;
- bluetooth,dropbox off (wifi on for presentation)
- system pref: ultralight as audio in/out
- audio sampling rate: 48k (set all in/out)
- motu app: 1in + out (with sm57 setting)
- change batteries in OpenBCI and test connection


30min BEFORE PRESENTATION:
- put on wet cap and test impedance

PRESENTATION (50 min)
- adjust lights in the room
- turn on recording on camera + phone + h1 zoom

1. TALKING (20 min)
- questions with orientation page
- one soundscape: shamanic journeying
- explain one test with mama (youtube)
- what is different between the tests and this performance?
- there is not much gaming element to this performance - why?
- 15 or 30 minutes
- how shall you listen today? Suggestion: listen to the digital shamans (drums annd chakapa) or my live drumming or the other sounds, watch or do not watch the screen
- how much would you like me to explain about the mapping before the performance, maybe afte is better.
- listen to the static/monotone elements the digital shaman (drumming from the speakers)
- eyes open/closed
- no intent - no journey :)
- we can draw after the 15 minutes;


2.PERFORMANCE (15 min)
- turn wifi off;
1. screenrecord (screen and internal mic only)
2. with timeseries, check impedance
3. read EEG (with fft plot + nf with coherance)

- adjust supercollider audio to -3.1
- adjust file below between 2-4 ch and test or perf settings;

*/

//-----------------------------
//read FFT
// - with coherence;

//-----------------------------
//main music files:
(
Server.killAll;
s.options.memSize = 2.pow(20); //for mome memory allocation
//s.options.memSize;
s.options.numOutputBusChannels= 4;
s.options.numInputBusChannels= 1; //0 if not performance;
s.reboot;
s.meter;
s.waitForBoot {
	~pathway= thisProcess.nowExecutingPath.dirname;
	//(~pathway++"/ndefs-2ch-test.scd").load;
	//(~pathway++"/ndefs-2ch-perf.scd").load;
	(~pathway++"/ndefs-4ch-test.scd").load;
	(~pathway++"/ndefs-4ch-perf.scd").load;
	(~pathway++"/shaman.scd").load;
	(~pathway++"/forest.scd").load;
	(~pathway++"/reward.scd").load;
	//start a new tempoClock
	//cannot rely on default tempoClock in the background
	t= TempoClock.new(4,16);
};
//s.plotTree;
NdefMixer(s);
)

//-----------------------------
//adjust computer volume to max


//-----------------------------
//forest and record (only with EEG)
(
(
// enter the forest
~toThreshold= 1;
~threshold= 2;
~forestDepth2.valueArray(~forest[0]);//no drumming
~reward.play;

//make instruments live
Ndef(\wind).play; //fade in wind
Ndef(\wind2).fadeTime = 5;
Ndef(\wind2).play; //environment wind
Ndef(\theta).play; //chakapa;
Ndef(\numbers).play; //voice
Ndef(\0).play;Ndef(\1).play;Ndef(\2).play; //digital shaman
);

// if EEG is on do this:
(
//record raw EEG and extra data
~recorder= DataRecord(~openbci);
~toThreshold= ~bandEnergyAvg[0];
~threshold= ~hiBandEnergy;
~rec= ~recorder.start;

r= Routine.run({inf.do{
	~rec.extra= [~hiBandEnergy,~bandEnergyAvg[0],~bandEnergyAvg[1],~bandEnergyAvg[2],~bandEnergyAvg[3],~bandEnergyAvg[4],~bandEnergyAvg[5],~bandEnergyAvg[6],~bandEnergyAvg[7],~phaseCalcFuncVal,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]]; //update DataRecord;
	0.25.wait}});
//r.stop;

//record 4 audio channels in sc
r = Recorder(s);
//r.record(numChannels:2);
r.record(numChannels:4);
)
)


//-----------------------------
// nf mappings

//-----------------------------
//adjust threshold manually:
~hiBandEnergy=  8.0; //for plot
~threshold= 1.0; //for reward

//-----------------------------
// spatialise wind2
(
~phaseCalcFuncVal= 0;
(
k= Routine.run({inf.do{
	Ndef(\grain).set(\panlr, ~phaseCalcFuncVal, \panfb, ~phaseCalcFuncVal);
	Ndef(\delay).set(\panlr, ~phaseCalcFuncVal, \panfb, ~phaseCalcFuncVal);
	0.04.wait; //same as 1/fps for the fft window

}});
);
//k.stop;


// spatialise chakapa
(
o= Routine.run({inf.do{ |i|
	var p1 = [0,1,1,1,0,-1,-1,-1];
	var p2 = [1,1,0,-1,-1,-1,0,1];
	Ndef(\theta).set(\panlr, p1[i%8], \panfb, p2[i%8]);
	5.wait; //same as 1/fps for the fft window

}});
);
//o.stop;
)




//-----------------------------
//schedule the movements in the forest:
(
var schedCurve= Array.geom(15, 1, 1.25).normalize(0, 900).asInt;
// Array.geom(15, 1, 1.25).normalize(0, 900); //15 min
// Array.geom(15, 1, 1.25).normalize(0, 1200); //20 min
//Array.geom(15, 1, 1.25).normalize(0, 1800).plot; //30 min
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
});
)

//-----------------------------
// 3. Q/A and drawing

// limitless options for mapping eeg to sound - but it needs to be meaningful and in line with training;
// explain timer variables that could be used for more gaming type of rewarding/changes;



//-----------------------------
// 4. plotting with audio
//TODO: read raw text file from savedData folder (Audio Support)
//TODO: read audio file from music/superCollider folder

