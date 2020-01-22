/*
# bcmi-soundscape-01
## nf_test
### main

TODO:
- check max ~currentDepth, it might need to be inline with levelNb;
- ~hiThetaEnergy = 10; ~timeThreshold = 10; to forest Function as value;
- would ten stages be enough?
- make timer that can move between stages;
- add a timer for the whole session - or is this not necessary as the raw file already saves 256 samples per sec?

### SESSION AGENDA
before session
- is there enough space on the hdd?
- is wifi/dropbox off;

session:
- participant fills in top of questionnaire (I start preparing EEG cap with wet electrodes)
- prep iPhone (airplane mode, silent, wifi-BLU off, auto lock: never, lock iPhone camera screen)
- start up Screenflow (don't start recording)
- all audio to 48k
- start screen-recording [configure] iphone + internal mic, computer audio, screen
- check timeseries and impedance - adjust impedance, close this file
- start neurofeedback example with 8 channels, reduce 50hz noise, show only bandwidths signal [No Data]
- start _main
- start reward play with forest 0 (no drumming)
	+ DataRecord
- check that extra is saved in text file;
- manually adjust threshold for theta/gamma
- schedule all cues;
*/

// 1. read EEG data
// use'openbci_gui_fftplot_with_neurofeedback-2ch.scd'

// 2. load tools for soundscape
(
Server.killAll;
s.options.numOutputBusChannels= 2;
s.options.numInputBusChannels= 0; //no need for audio input;
s.reboot;
s.meter;
s.waitForBoot {
	~pathway= thisProcess.nowExecutingPath.dirname;
	(~pathway++"/ndefs03.scd").load;
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

// 3. record raw and extra EEG data and start the soundscape
(
//start recording eeg and extra data:
var recorder= DataRecord(~openbci);
recorder.extra=[~energyTheta,~hiThetaEnergy,~currentForestDepth,~timer];
~rec= recorder.start;

// start the soundscape by moving into the first layer of the forest (just forest sounds, no shaman sounds)
~forestDepth2.valueArray(~forest[0]);//no drumming;
~reward.play;
)
)

// is file saved with extra?
//~rec.path.openOS;  //open file we just recorded in text editor

//adjust threshold manually:
~hiThetaEnergy= 1.0;

(
// enter a deper level:
//var schedCurve= [ 0, 4, 8, 16, 32, 64, 128, 256, 512, 700, 850, 1000, 1200, 1400, 1600, 1700 ];
var schedCurve= Array.exprand((~forest.size)-3, 1, 1800).round.sort;
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

// after music finished, wait for a few minutes to record more EEG;

// 'CMD + .' to stop recording file and reading EEG;
// questionaire + drawing (optional);
// switch EEG off, take cap off;




/* Creating random scheduling times for the levels (forestDepths):
by f.olofsson

// this can also help make the soundscape sound always a tiny bit different to previous sessions if needed;

//here 1.5 is exponent
Array.geom(16, 1, 1.5).normalize(0, 1800).plot

//with some randomness added...
(Array.geom(16, 1, 1.5).normalize(0, 1800)+{0.gauss(50)}.dup(16)).plot

//or, more advanced, scale randomness depending on position in the curve
(Array.geom(16, 1, 1.5).normalize(0, 1800)+{|i| 0.gauss(i.linlin(15, 0, 100, 1))}.dup(16)).plot

((0..1799).collect{|x| x.linexp(0, 1799, 1, 1800)+0.gauss(10)}).plot

({|i| 2**i/16}.dup(16).normalize(0, 1)).plot
*/