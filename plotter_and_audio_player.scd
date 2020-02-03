//plotter with audio player example for bcmi-soundscapes by khofstadter 2020
//https://github.com/krisztian-hofstadter-tedor/bcmi-soundscape-01
//thanks to f.olofsson for adding the audio player
//TODO normalise audio

/*
--extra data saved with DataRecord
[~bandEnergyAvg[0],~bandEnergyAvg[1],~bandEnergyAvg[2],~bandEnergyAvg[3],~bandEnergyAvg[4],~bandEnergyAvg[5],~bandEnergyAvg[6],~bandEnergyAvg[7],~hiBandEnergy,~phaseCalcFuncVal,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]];

--column in raw eeg file
#0 index
#1-8 ch1-ch8 raw data
#9-11 accel
#12-19 ch1-ch2 theta median
#20 nf-threshold
#21 ~phaseCalcFuncVal
#22 level nb
#23- timer 1 (0)
#24- timer 2 (0)
#25- timer 3 (0)
#26- timer 4 (0)
#27- timestamp1 (11:02:46.832)
#28- timestamp2 (1569492166832)
*/

//--plotter and audio player
// to change: links to raw text and audio file, correct data to plot;
(
s.waitForBoot{
	var limiter= 20;
	var alphaColor= 100;

	var plotterA, plotterB, plotterC;
	var datasetA, datasetB, datasetC;
	var colors= [
		Color.new255(129, 129, 129),
		Color.new255(124, 75, 141, alphaColor),
		Color.new255(54, 87, 158, alphaColor),
		Color.new255(49, 113, 89, alphaColor),
		Color.new255(221, 178, 13, alphaColor),
		Color.new255(253, 94, 52, alphaColor),
		Color.new255(224, 56, 45, alphaColor),
		Color.new255(162, 82, 49, alphaColor)
	];
	var window= Window.new("Plotter Example", Rect(0,0,1024,600)).front;
	window.view.layout_(VLayout(
		//the plotters
		(plotterA= Plotter("PlotterA",nil,View())).interactionView.minSize_(500@300).canFocus_(false),
		(plotterB= Plotter("PlotterB",nil,View())).interactionView.minSize_(500@150).canFocus_(false),
		(plotterC= Plotter("PlotterC",nil,View())).interactionView.minSize_(500@150).canFocus_(false),
		(w= PlayFileDiskView(PlayFileDiskStereo(), controls:false)).view
	));
	w.focus;

	//CHANGE THIS:
	//(need to reboot interpreter in case new file is plotted)
	if(x.isKindOf(Array).not, {
		x= CSVFileReader.read("/Users/khofstadter/Library/Application Support/SuperCollider/downloaded-quarks/OpenBCI-SuperCollider/savedData/OpenBCI-RAW-2020-01-31_20-55-55_sc.txt");
		6.do{x.removeAt(0)};
	});

	//CHANGE THIS:
	w.read("/Users/khofstadter/Music/SuperCollider Recordings/SC_200131_161125.aiff");

	p= 0 ! (x.size/256) ! 16;

	a= 0;
	b= 0;
	c= 0;
	d= 0 ! 20;
	e= 0;

	x.size.do{|i|
		if (x[i][0] == "0",
			{
				p[0][a]= x[i][12].asFloat.min(limiter); //FZ theta median
				p[1][a]= x[i][13].asFloat.min(limiter); //PZ theta median
				p[2][a]= x[i][14].asFloat.min(limiter); //FP1 theta median
				p[3][a]= x[i][15].asFloat.min(limiter); //FP2 theta median
				p[4][a]= x[i][16].asFloat.min(limiter); //F3 theta median
				p[5][a]= x[i][17].asFloat.min(limiter); //F4 theta median
				p[6][a]= x[i][18].asFloat.min(limiter); //P3 theta median
				p[7][a]= x[i][19].asFloat.min(limiter); //P4 theta median

				p[8][a]= x[i][22].asInt; //level
				p[9][a]= x[i][23].asInt; //current time
				p[10][a]= x[i][24].asInt; //above nf-threshold
				p[12][a]= x[i][20].asFloat; //threshold

				p[13][a]= x[i][21].asFloat.min(1); //~phaseCalcFuncVal

				if (p[8][a]!== p[8][a-1],
					{ if (p[8][a]!== 0,
						{

							("level: "++((p[8][a])-1)).postln;
							b= p[9][a-5];
							("level start: "++(a-b)).postln;
							("level lenght: "++b++"sec").postln;
							c= p[10][a-5];
							("total above ~threshold: "++c++"sec").postln;
							d= (c*100/b).asInt;
							("above threshold: "++d++"%").postln;
							//[a-4] looks at downsampled matrix 4 seconds in the past;
							// this needs to be fixed in the reward.scd file;
							b.do{ |f| p[11].put((a-b)+f,d)};
						}
					);
					}
				);
				a= a+1;
			}
		);
	}.value;

	p[15]= 1 ! p[0].size; //constant horizontal line to indicate max. coherence (+1)

	//--the datasets to visualize
	datasetA= [
		p[1],
		(p[8]/3).neg,
		((p[9]/50)+(p[8]/3)).neg,
		((p[10]/50)+(p[8]/3)).neg,
		p[12]
	];

	datasetB= [
		p[11]
	];

	datasetC= [
		p[6],p[7],
		p[13],
		p[15]
	];

	//--load datasets and customise plotters
	plotterA.value_(datasetA); //load dataset
	plotterA.plotMode= \linear;
	plotterA.superpose_(true); //allow channels overlay
	plotterA.setProperties( //customize appearence
		\plotColor, [
			colors[0],
			Color.fromHexString("#5C73F2"),
			Color.fromHexString("#5C73F2"),
			Color.new255(0, 100, 0, 200),
			Color.new255(205, 92, 92)
		], //plot colors
		\backgroundColor, Color.white, //background color
		\gridColorX, Color.grey, //gridX color
		//\gridColorY, Color.yellow, //gridY color
		\gridOnX, false, //horizontal grid
		\gridOnY, false //vertical grid
	);

	plotterB.value_(datasetB);
	plotterB.plotMode= \steps;
	plotterB.superpose_(true);
	plotterB.specs= [[0, 100, \lin, 1]];
	plotterB.setProperties(
		\plotColor, [
			Color.new255(0, 100, 0, 200)
		],
		\backgroundColor, Color.white,
		\gridColorX, Color.grey,
		//\gridColorY, Color.yellow,
		\gridOnX, false,
		\gridOnY, true
	);

	plotterC.value_(datasetC);
	plotterC.plotMode= \linear;
	plotterC.superpose_(true);
	plotterC.setProperties(
		\plotColor, [
			colors[5],colors[7],
			Color.new255(0, 100, 0, 200),
			Color.black
		],
		\backgroundColor, Color.white,
		\gridColorX, Color.grey,
		//\gridColorY, Color.yellow,
		\gridOnX, true,
		\gridOnY, false
	);
};
)

//more for audio plotting
w.read;
//or
w.read("/Users/khofstadter/Music/SuperCollider Recordings/SC_200131_205555.aiff")

w.play  //or 'space' or doubleclick
w.stop
w.yZoom= 0.125  //only zooming, not normalizing - smaller is more magnification (need a higher maximum?)
w.controls= true  //show controls
w.controls= false  //hide
w.background= Color.white
w.rmsColor= Color.red
w.waveColor= Color.black
w.timeCursorColor= Color.blue