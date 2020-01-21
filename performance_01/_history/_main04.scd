// -------------------
// FRIDAY
// -------------------

// is ~phaseSync1 and ~coh2 accurate? post;
// nf mapping: spatialise noise with phase sync/coherence (perhaps the speed it goes around slows down, or becomes more central);
// nf mapping: spatialise shaman with phase sync/coherence (perhaps the speed it goes around slows down, or becomes more central);
// Fz amp (average) map to some sound (which sound - new sound?)
// try some compressor an final end (how?)
// record one go with cameras;

// -------------------
// SATURDAY
// -------------------

// BEFORE PRESENTATION:
// no screensaver;
// bluetooth,dropbox off (wifi on for presentation)
// camera + phone + h1 recording;
// system pref: ultralight as audio in/out
// audio sampling rate: 48k (set all in/out)
// motu app: 1in + out (with sm57 setting)

// in sc:
// LOWER VOLUME:
// test 4 speakers with sinwaves
// (performance code is 1243 instead of 1234)

// 30 MIN BEFORE PRESENTATION:
// put on cap and test impedance;

// PRESENTATION:
// talking:
// questions with orientation? + shamanism
// exlpain one test with mama (youtube)
// what is different between the tests and this performance?
// there is not much gaming element to this performance as perhaps that helps letting go;
// how shall you listen? it's not ambent,
// analytical vs letting go;
// listen to the digital shaman or the live drumming or the other sounds?

// PERFORMANCE:
// - wifi off;
// 1. screenrecord:
// record screen + internal mic;
// 2. timeseries, check impedance (seperate file)
// 3. read EEG with fft plot + nf with coherance (seperate file)
// 4. coherence Routine:

(
~cMatAmp= 0 ! 8 ! 8; //coherence matrix
~syncArray= 0 ! 25; //instead of 250hz we will use the sample rate of the fft window, this means we are below tracking how phase syncronisation changes every second i.e. in a 1 second window;
~phaseSync1= 0;
//~coh1Arr= [0,0];
//~coh1= 0;
//~coh2= 0;
r= Routine.run({inf.do{
	~cMatAmp.size.do{ |i|
		~bandEnergyAvg.size.do{ |x|
			~cMatAmp[i][x]= (~bandEnergyAvg[i]-~bandEnergyAvg[x]).abs;
		}
	};
	~syncArray= ~syncArray.rotate(-1);
	//~coh1Arr= ~coh1Arr.rotate(-1);
	~syncArray[~syncArray.size-1]= ~cMatAmp[6][7]; //P3 and P4
	~phaseSync1= ~syncArray.mean.round(0.01);
	//~coh1Arr[~coh1Arr.size-1]= ~phaseSync1;
	//~coh1= ~coh1Arr[0]-~coh1Arr[1];
	//~coh2= ~coh2+~coh1;
	0.04.wait; //same as 1/fps for the fft window
	//~coh2.postln
	//~phaseSync1.postln;
}});
)

r.stop;

// maybe:
//s.options.memSize;
s.options.memSize = 2.pow(20); // for mome memory allocation ???;

// main music files:
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
	(~pathway++"/forest05.scd").load;
	(~pathway++"/reward03.scd").load;
	// start a new tempoClock
	// cannot rely on default tempoClock in the background
	t= TempoClock.new(4,16);
};
//s.plotTree;
NdefMixer(s);
)

// record 4 channels in sc;
(
r = Recorder(s);
r.record(numChannels:4);
)



// adjust main volume in sc
// 0.5db


//adjust computer volume to max


// record raw EEG and music data:
// enter the forest
(
//start recording eeg and extra data:
var recorder= DataRecord(~openbci);
recorder.extra=[~hiBandEnergy,~bandEnergyAvg[0],~bandEnergyAvg[1],~bandEnergyAvg[2],~bandEnergyAvg[3],~bandEnergyAvg[4],~bandEnergyAvg[5],~bandEnergyAvg[6],~bandEnergyAvg[7],~phaseSync1,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]];
~rec= recorder.start;

//
~forestDepth2.valueArray(~forest[0]);//no drumming;
~reward.play;
//make instruments live:
Ndef(\wind).play; //fade in wind;
Ndef(\wind2).fadeTime = 1;
Ndef(\wind2).play; //environment wind
Ndef(\theta).play; //chakapa;
Ndef(\numbers).play; //voice
Ndef(\0).play;Ndef(\1).play;Ndef(\2).play; //digital shaman
)

// check if file saved with extra:
~rec.path.openOS;  //open file we just recorded in text editor


// additional live mic DSP"
// mic with delay and grain;
(
Ndef(\live, {HPF.ar(Pan4.ar(SoundIn.ar, MouseX.kr(-1, 1), MouseY.kr(-1, 1)),50)});  //quad
Ndef(\live).vol= 0.3;
Ndef(\delay, {|decay= 7, delHz= 0.1, delMin= 0.05, delMax= 0.8|
	var sig= Ndef.ar(\live);
	HPF.ar(CombC.ar(sig, 0.5, SinOsc.kr(delHz*[1, 0.9, 0.8, 0.7]).exprange(delMin, delMax), decay),50);
});
Ndef(\delay).vol= 0.5;


//grain
(
g.free; g= Buffer.alloc(s, 3*s.sampleRate);
Ndef(\live2, {|t_trig= 0| HPF.ar(RecordBuf.ar(SoundIn.ar, g, loop:1, trigger: t_trig),50)}); //loop: 1 is live feed; loop: 0 is with capture;
Ndef(\live2).vol= 1;
//Ndef(\playback, {Pan2.ar(PlayBuf.ar(1, g, loop:1))}).play(vol:0.0);
);

(
Ndef(\live2).set(\t_trig, 1); //run this line every time
//then of course you can add more 'players' that read form the same buffer...
Ndef(\grain, {|rate= 1.68, dur= 0.1|
	LPF.ar(HPF.ar(Pan4.ar(
		(TGrains.ar(1, Dust.kr(4), g, rate, LFNoise2.kr(0.1)+1/2, dur, 0, 3)), MouseX.kr(-1, 1), MouseY.kr(-1, 1))
	,50),16000);
});
Ndef(\grain).vol= 0.4;
);

Ndef(\delay).play;
Ndef(\grain).play;
Ndef(\live2).play;
Ndef(\live).play;
)


//adjust threshold manually:
~hiBandEnergy=  1.5;


//schedule the movements in the forest:

(

var schedCurve= Array.geom(15, 1, 1.25).normalize(0, 1200).asInt;
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
}); //tripplets (triplets)

)

// limitless options for mapping eeg to sound - but it needs to be meaningful and in line with training;
// explain timer variables that could be used for more gaming type of rewarding/changes;
