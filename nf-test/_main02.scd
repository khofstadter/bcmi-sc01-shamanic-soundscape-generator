/* todo:
hardware:
software:
soundscape
- look into auto threshold later;
!- need to perhaps average the theta signal for 30s 1m for the 50-70% success;
!- noise a bit too laud - maybe OK to be noise at the very beginning to clear the ears, later perhaps it should be less noisy;
- ask participant to focus on the drumming and nothing else (I don't know whether to tell them that this is neuro-feeback as than they might try too hard!)
!- perhaps that 30s/1m averaged signal could be used to give some feedback as welll
!- timethreshold is probably fine to keep;
!- other counters should be used to give minimal feedback as well;
ok.
// last leven should stay for longer (something wrong with (~currentDepth < ~forest.size).if {
// refine Ndef code, they don't have the same sytax, how to add one reverb to all?
// add max ~currentDepth - perhaps needs to be inline with levelNb;
// add 	~hiThetaEnergy = 10; ~timeThreshold = 10; to forest Function as value;
// add new variable to decide when to move;
// remove change from all synths (ndef2,100,0.04,2600];
// make mixer: perhaps only two outs: drums, forest
// switch off audio input;
// forest add breating guide wave: first faster in & out synced to paradiddle, later slower breathing, encourage the space between;
// make fade is swooshy sound (fades in with end on first beat,100,0.04,2600];
// make ten stages;
// make timer that moves up and down in the 10 stages;
// make a timer that counts the whole things?
*/

(
Server.killAll;
s.options.numOutputBusChannels= 2;
s.options.numInputBusChannels= 0;
s.reboot;
s.meter;
s.waitForBoot {
	~pathway= thisProcess.nowExecutingPath.dirname;
	(~pathway++"/ndefs03.scd").load;
	(~pathway++"/shaman02.scd").load;
	(~pathway++"/forest04.scd").load;
	(~pathway++"/reward02.scd").load;
	// start a new tempoClock
	// cannot rely on default tempoClock in the background
	t= TempoClock.new(4,16);
};
//s.plotTree;
//NdefMixer(s);
)

// read eeg data or
//~energyTheta= 16; //if no eeg is measured
//~hiThetaEnergy= 19; //set theta threshold


(
//start recording eeg and extra data:
var recorder= DataRecord(~openbci);
recorder.extra=[~energyTheta,~hiThetaEnergy,~currentForestDepth,~timer];
~rec= recorder.start;

// just forest, no shaman
~forestDepth2.valueArray(~forest[0]);//no drumming;
~reward.play;
)


// is file saved with extra?
~rec.path.openOS;  //open file we just recorded in text editor

//adjust threshold manually:
~hiThetaEnergy= 1.5;


//schedule the movements in the forest:

(

var schedCurve= [ 0, 4, 8, 16, 32, 64, 128, 256, 512, 700, 850, 1000, 1200, 1400, 1600, 1700 ];
//var schedCurve= Array.exprand((~forest.size)-3, 1, 1800).round.sort;
// -> [ 1.0, 2.0, 4.0, 9.0, 101.0, 133.0, 173.0, 225.0, 287.0, 526.0, 550.0, 877.0, 1163.0, 1507.0, 1521.0, 1656.0 ]

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
SystemClock.sched(1800,{ ~forestDepth2.valueArray(~forest[15]);}); //tripplets (triplets)
SystemClock.sched(1820,{
	~forestDepth2.valueArray(~forest[16]); //stop drums, fade out wind;
	~reward.stop;//stop
	~timer = [0,0,0,0];});//reset - perhaps better to write something more distinct in here?
)

// when music finished, wait for a few minutes.

// CMD + .= stop recording, and reading;
// questionaire + drawing;
// swith EEG off