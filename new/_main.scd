//main file for bcmi-soundscapes by khofstadter 2020
//https://github.com/krisztian-hofstadter-tedor/bcmi-soundscape-01

//-----------------------------
//read FFT
// - with coherence


//-----------------------------
//main music files
(
Server.killAll;
s.options.memSize = 2.pow(20); //for mome memory allocation
//s.options.memSize;
s.options.numOutputBusChannels= 2;
s.options.numInputBusChannels= 0; //live input off
s.reboot;
s.meter;
s.waitForBoot {
	~pathway= thisProcess.nowExecutingPath.dirname;
	(~pathway++"/ndefs-2ch-test.scd").load;
	//(~pathway++"/ndefs-2ch-perf.scd").load;
	//(~pathway++"/ndefs-4ch-test.scd").load;
	//(~pathway++"/ndefs-4ch-perf.scd").load;
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
//enter forest
//and record (only with EEG date)
//select 'enter forest' only if no EEG data is used
(
(
//enter forest
~toThreshold= 0;
~threshold= 2;
~currentForestDepth= 0;
~forestDepth2.valueArray(~forest[0]);
~reward.play;

//instrument adjustments
Ndef(\wind).play; //fade in wind
Ndef(\wind2).fadeTime = 5;
Ndef(\wind2).play; //environment wind
Ndef(\theta).play; //chakapa;
Ndef(\numbers).play; //voice
Ndef(\0).play;Ndef(\1).play;Ndef(\2).play; //digital shaman
);

//record (only with EEG date)
(
r= 0!2;
//record raw EEG and extra data into a text file
~recorder= DataRecord(~openbci);
~toThreshold= ~bandEnergyAvg[1]; //select which signal will be used for NFT
~threshold= ~hiBandEnergy;
~rec= ~recorder.start;

//update DataRecord extra
r[0]= Routine.run({inf.do{
	~rec.extra= [~bandEnergyAvg[0],~bandEnergyAvg[1],~bandEnergyAvg[2],~bandEnergyAvg[3],~bandEnergyAvg[4],~bandEnergyAvg[5],~bandEnergyAvg[6],~bandEnergyAvg[7],~hiBandEnergy,~phaseCalcFuncVal,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]];
	0.25.wait}});
//r[0].stop;

//record audio
r[1] = Recorder(s);
r[1].record(numChannels:2); //stereo
//r[1].record(numChannels:4); //quad
)
)


//-----------------------------
//adjust threshold manually:
~hiBandEnergy=  1.3; ~threshold= 1.3; //for plot and reward

//-----------------------------
// spatialise sound
(
~phaseCalcFuncVal= 0; //in case EEG is not running
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
//start moving inwards
(
var schedCurve= Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 200).asInt; //adjust lenght of time in seconds
//var schedCurve= Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 900).asInt;
// Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 900); //15 min
// Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 1200); //20 min
//Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 1800).plot; //30 min

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
SystemClock.sched(schedCurve[10],{ ~forestDepth2.valueArray(~forest[11]); //callback
	SystemClock.sched(15,{ //after 15 sec - this perhaps should aligned to the bar
		~forestDepth2.valueArray(~forest[0]); //stop drums
		~reward.stop; //stop
		~timer = [0,0,0,0];}); //reset - perhaps better to write something more distinct in here?
});
)

// finish with CMD+.
