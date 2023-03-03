//start file for bcmi-soundscapes by khofstadter 2020
//https://github.com/krisztian-hofstadter-tedor/bcmi-soundscape-01
//dependency: Bjorklund quark

//-----------------------------
//read FFT
// - with coherence

// select audio in
ServerOptions.inDevices.postln;

// check samplerate
s.sampleRate;
s.options.sampleRate= 48000;


//-----------------------------
//1. main music files
(
//Server.default.options.inDevice_("H1");
Server.default.options.inDevice_("Built-in Microph");
Server.killAll;
s.options.memSize = 2.pow(20); //for mome memory allocation
//s.options.memSize;
s.options.numOutputBusChannels= 2;
s.options.numInputBusChannels= 1; //live input off/on
s.reboot;
s.meter;
s.waitForBoot {
	~pathway= thisProcess.nowExecutingPath.dirname;
	(~pathway++"/ndefs-2ch-test.scd").load;
	(~pathway++"/ndefs-2ch-perf-new.scd").load;
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
//2. enter forest and record data
(
//2.1 enter forest ONLY
(
//enter forest
~toThreshold= 0;
~threshold= 0;
~currentForestDepth= 0;
~forestDepth2.valueArray(~forest[0]);
~reward.play;

// play instruments and adjust their volume
Ndef(\wind2).fadeTime = 5;
Ndef(\wind2).vol=0.4; //shaker;
Ndef(\wind2).play; //environment wind
Ndef(\theta).vol=0.2; //shaker;
Ndef(\theta).play; //shaker;
Ndef(\numbers).vol=0.8; //voice;
Ndef(\numbers).play; //voice
Ndef(\0).play;Ndef(\1).play;Ndef(\2).play; //digital shaman
Ndef(\wind).play; //fade in wind (horn)
Ndef(\grain).vol= 0.2;
Ndef(\grain).play;
Ndef(\delay).vol= 0.1;
Ndef(\delay).play;
Ndef(\live2).stop;
);

//record data
(
r= 0!2;
//record raw EEG and extra data into a text file
~recorder= DataRecord(~openbci);
~rec= ~recorder.start;
~thresholds[12][1]= (~threshold= 1.5).postln; //pre-adjust threshold

//update DataRecord extra
r[0]= Routine.run({inf.do{
	~rec.extra= [~bandEnergyAvg[12],~thresholds[12][1],~class2,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]];

~toThreshold= ~bandEnergyAvg[12]; //select which signal will be used for NFT

	0.25.wait}});
//r[0].stop;

//record audio
//r[1] = Recorder(s);
//r[1].record(numChannels:2); //stereo
//r[1].record(numChannels:4); //quad
)
)

/*
//update signal sent to reward if above Routine is not executed;
(
g= Routine.run({inf.do{
~toThreshold= ~bandEnergyAvg[0]; //select which signal will be used for NFT
0.25.wait}});
);
*/





//-----------------------------------------------------
//3. adjust threshold manually for classified signal 1
(
~thresholds[12][1]= (~threshold= 2);
//~toThreshold.postln; //the classified signal (theta Fz)


// spatialise shakers sounds 2 speakers (without brain signals)
(
o= Routine.run({inf.do{ |i|
	var p1 = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1,0,-0.1,-0.2,-0.3,-0.4,-0.5,-0.6,-0.7,-0.8,-0.9,-1,-0.9,-0.8,-0.7,-0.6,-0.5,-0.4,-0.3,-0.2,-0.1];
	Ndef(\theta).set(\panlr, p1[i%p1.size]);
	1.wait;
}});
);
//o.stop;
)



//-----------------------------------------------------
//4. test spatialisation with classified data 2 (

// test coherence to spatialisation mapping (grain and delay)
k.stop; // MUST STOP before testing new value
~testClass02= 1; //in case EEG is not running (-1 left; 0 middle; 1 right)

(
k= Routine.run({inf.do{
	Ndef(\grain).set(\panlr, ~testClass02);
	Ndef(\delay).set(\panlr, ~testClass02);
	0.04.wait; //same as 1/fps for the fft window
}});
);



// with real classified brain signal
k.stop //must stop before adding real-time signal
(
k= Routine.run({inf.do{
	Ndef(\grain).set(\panlr, ~class2*10); //scaled up by 10 for this test
	Ndef(\delay).set(\panlr, ~class2*10); //scaled up by 10 for this test
	("class2:"+~class2).postln;
	0.05.wait; //same as 1/fps for the fft window
}});
);







//-----------------------------
//5. start moving inwards
//300 seconds for this test (5 min)
(
var schedCurve= Array.geom(((~forest.size)-1), 1, 1.25).normalize(0,300).asInt; //adjust lenght of time in seconds
//var schedCurve= Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 900).asInt;
// Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 900); //15 min
// Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 1200); //20 min
//Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 1800).plot; //30 min
//Array.geom(((~forest.size)-1), 1, 1.25).normalize(0, 2400).plot; //40 min?

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