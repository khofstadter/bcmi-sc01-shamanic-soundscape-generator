
// -------------------
// PREP
// -------------------
// in sc:
// LOWER VOLUME:
// test 4 speakers with sinwaves
// (performance code is 1243 instead of 1234)

// 1h BEFORE PRESENTATION:
// no screensaver;
// bluetooth,dropbox off (wifi on for presentation)
// system pref: ultralight as audio in/out
// audio sampling rate: 48k (set all in/out)
// motu app: 1in + out (with sm57 setting)

// change batteries in OpenBCI - test


// 30min BEFORE PRESENTATION:
// put on cap and test impedance;


// PRESENTATION
// lights?
// camera + phone + h1 recording;

// 1. TALKING
// questions with orientation page + ?
// one soundscape: shamanic journeying
// explain one test with mama (youtube)
// what is different between the tests and this performance?
// there is not much gaming element to this performance - why?
// 15 / 30 minutes;
// how shall you listen today?
// listen to the digital shamans (drums annd chakapa) or my live drumming or the other sounds, watch the screen or not?
// how much would you like me to explain before the performance - maybe later?
// I would listen to the static/monotone elements the digital shaman (drumming from the speakers)
// eyes closed
// no intent - no journey :)
// we can draw after the 15 minutes;




//  2.PERFORMANCE (15 min)
// - wifi off;
// 1. screenrecord (screen and internal mic only)
// 2. timeseries, check impedance (seperate file)
// 3. read EEG (with fft plot + nf with coherance)


// supercollider audio -3.1



//-----------------------------
// phase sync
(
~cMatAmp= 0 ! 8 ! 8; //coherence matrix
~syncArray= 0 ! 25; //instead of 250hz we will use the sample rate of the fft window, this means we are below tracking how phase syncronisation changes every second i.e. in a 1 second window;
~syncArray2= 0 ! 25;
~phaseSync1= 0;
~phaseSync2= 0;
//~coh1Arr= [0,0];
//~coh1= 0;
//~coh2= 0;
r= Routine.run({inf.do{
	~cMatAmp.size.do{ |i|
		~bandEnergyAvg.size.do{ |x|
			~cMatAmp[i][x]= (~bandEnergyAvg[i]-~bandEnergyAvg[x]);
		}
	};
	~syncArray= ~syncArray.rotate(-1);
	~syncArray2= ~syncArray2.rotate(-1);
	//~coh1Arr= ~coh1Arr.rotate(-1);
	~syncArray[~syncArray.size-1]= ~cMatAmp[6][7]; //P3 and P4 (left - right)
	~syncArray2[~syncArray2.size-1]= ~cMatAmp[5][7]; //F4 and P4 (front - back)
	~phaseSync1= ~syncArray.mean.round(0.01);
	~phaseSync2= ~syncArray2.mean.round(0.01);
	//~coh1Arr[~coh1Arr.size-1]= ~phaseSync1;
	//~coh1= ~coh1Arr[0]-~coh1Arr[1];
	//~coh2= ~coh2+~coh1;
	0.04.wait; //same as 1/fps for the fft window
	//~coh2.postln
	//~phaseSync1.postln;
	//~phaseSync2.postln;
}});
);

//r.stop;



//-----------------------------
// main music files:
(
Server.killAll;
s.options.memSize = 2.pow(20); // for mome memory allocation
//s.options.memSize;
s.options.numOutputBusChannels= 4;
s.options.numInputBusChannels= 1;
s.reboot;
s.meter;
s.waitForBoot {
	~pathway= thisProcess.nowExecutingPath.dirname;
	(~pathway++"/ndefs04.scd").load;
	(~pathway++"/shaman02.scd").load;
	(~pathway++"/forest05.scd").load;
	(~pathway++"/reward04.scd").load;
	// start a new tempoClock
	// cannot rely on default tempoClock in the background
	t= TempoClock.new(4,16);
};
//s.plotTree;
NdefMixer(s);
)




//-----------------------------
// record 4 channels in sc;
(
r = Recorder(s);
r.record(numChannels:4);
)




//-----------------------------
//adjust computer volume to max




//-----------------------------
// record raw EEG and music data:
// enter the forest
(
var recorder= DataRecord(~openbci);
recorder.extra=[~hiBandEnergy,~bandEnergyAvg[0],~bandEnergyAvg[1],~bandEnergyAvg[2],~bandEnergyAvg[3],~bandEnergyAvg[4],~bandEnergyAvg[5],~bandEnergyAvg[6],~bandEnergyAvg[7],~phaseSync1,~phaseSync2,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]];
~rec= recorder.start;

~forestDepth2.valueArray(~forest[0]);//no drumming;
~reward.play;
//make instruments live:
Ndef(\wind).play; //fade in wind;
Ndef(\wind2).fadeTime = 5;
Ndef(\wind2).play; //environment wind
Ndef(\theta).play; //chakapa;
Ndef(\numbers).play; //voice
Ndef(\0).play;Ndef(\1).play;Ndef(\2).play; //digital shaman
)





//-----------------------------
// additional live mic DSP"
// mic with delay and grain;
(
Ndef(\live, {HPF.ar(Pan4.ar(SoundIn.ar, MouseX.kr(-1, 1), MouseY.kr(-1, 1)),50)});  //quad
Ndef(\live).vol= 0;
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
Ndef(\grain, {|rate= 1.68, dur= 0.1, panlr=0, panfb=0|
	LPF.ar(HPF.ar(Pan4.ar(
		(TGrains.ar(1, Dust.kr(4), g, rate, LFNoise2.kr(0.1)+1/2, dur, 0, 3)), panlr, panfb)
	,50),16000);
});
Ndef(\grain).vol= 0.4;
);
Ndef(\delay).play;
Ndef(\grain).play;
Ndef(\live2).play;
//Ndef(\live).play;
)





//-----------------------------
// spatialise wind2 with phasesync1 (p3-p4) and phasesync2 (f4-p4)
(
(
k= Routine.run({inf.do{
	Ndef(\grain).set(\panlr, ~phaseSync1, \panfb, ~phaseSync2);
	Ndef(\delay).set(\panlr, ~phaseSync1, \panfb, ~phaseSync2);
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
//adjust threshold manually:
~hiBandEnergy=  1.5;





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
}); //tripplets (triplets)

)




//-----------------------------
// 3. Q/A and drawing

// limitless options for mapping eeg to sound - but it needs to be meaningful and in line with training;
// explain timer variables that could be used for more gaming type of rewarding/changes;
