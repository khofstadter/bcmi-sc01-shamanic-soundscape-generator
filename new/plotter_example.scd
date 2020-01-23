//plotter example
//TODO rewrite this to simple format, no timer needed, this should follow the format example given in DataRecord.schelp;
//TODO this DataRecord example info to 'openbci_gui_fftplot_with_neurofeedback-2ch.scd'
//TODO this DataRecord example info to 'openbci_gui_fftplot_with_neurofeedback-8ch.scd'
//TODO add all column info in comments below
//TODO rewrite comments where necessary
//TODO threshold really should be saved in column and then it can be plotted as normal (not written manually in an Array;

/* two parts:
1. plotting raw eeg data with .extra colums
- change raw file file location below
2.playing and plotting audio
change audio file location below

used function for extra data:

recorder.extra=[~hiBandEnergy,~bandEnergyAvg[0],~bandEnergyAvg[1],~bandEnergyAvg[2],~bandEnergyAvg[3],~bandEnergyAvg[4],~bandEnergyAvg[5],~bandEnergyAvg[6],~bandEnergyAvg[7],~phaseSync1,~phaseSync2,~currentForestDepth,~timer[0],~timer[1],~timer[2],~timer[3]];

#0 index
#1-9 ch1-ch8 raw data
#10-12 accel
#13 nfth (set below manualy in var 1.5)
#14 ch1 theta median (FZ)
#15 ch2 theta median (PZ)
#16 ch3 theta median (FP1)
#17 ch4
#18 ch5
#19 ch6
#20 ch7
#21 ch8 theta median (P4)
#22 ~phaseCalcFuncVal ?
#23- level
#24- timer 1 (0)
#25- timer 2 (0)
#26- timer 3 (0)
#27- timer 4 (0)
#28- timestamp1 (11:02:46.832)
#29- timestamp2 (1569492166832)
*/

// 1. plotting raw eeg data with .extra colums
(
s.waitForBoot{
	var limiter= 5;
	var nfth= 1.5;
	var alphaColor= 100;

	var plotterA, plotterB, plotterC, plotterD;
	var datasetA, datasetB, datasetC, datasetD;
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
	var window= Window.new("Plotter Example", Rect(0,0,1024,835)).front;
	window.view.layout_(VLayout(

		// the plotters
		(plotterA= Plotter("PlotterA",nil,View())).interactionView.minSize_(500@150).canFocus_(false),
		(plotterB= Plotter("PlotterB",nil,View())).interactionView.minSize_(500@150).canFocus_(false),
		(plotterC= Plotter("PlotterC",nil,View())).interactionView.minSize_(500@150).canFocus_(false),
		(plotterD= Plotter("PlotterD",nil,View())).interactionView.minSize_(500@150).canFocus_(false),
		(w= PlayFileDiskView(PlayFileDiskStereo(), controls:false)).view
	));
	w.focus;

	// CHANGE THIS:
	// need to recompile sc in case new file is plotted
	if(x.isKindOf(Array).not, {
		x= CSVFileReader.read("/Users/khofstadter/Library/Application Support/SuperCollider/downloaded-quarks/OpenBCI-SuperCollider/savedData/OpenBCI-RAW-2020-01-23_13-55-11_sc.txt");
		6.do{x.removeAt(0)};
	});

	p= 0 ! (x.size/256) ! 16;

	a= 0;
	b= 0;
	c= 0;
	d= 0 ! 20;
	e= 0;
	x.size.do{|i|
		if (x[i][0] == "0",
			{
				p[0][a]= x[i][14].asFloat.min(limiter); //FZ theta median
				p[1][a]= x[i][15].asFloat.min(limiter); //PZ theta median
				p[2][a]= x[i][16].asFloat.min(limiter); //FP1 theta median
				p[3][a]= x[i][17].asFloat.min(limiter); //FP2 theta median
				p[4][a]= x[i][18].asFloat.min(limiter); //F3 theta median
				p[5][a]= x[i][19].asFloat.min(limiter); //F4 theta median
				p[6][a]= x[i][20].asFloat.min(limiter); //P3 theta median
				p[7][a]= x[i][21].asFloat.min(limiter); //P4 theta median

				p[8][a]= x[i][23].asInt; //level
				p[9][a]= x[i][24].asInt; //current time
				p[10][a]= x[i][25].asInt; //above nf-threshold

				p[13][a]= x[i][22].asFloat.min(1); //phaseSync1 (it's amp Sync atm)

				if (p[8][a]!== p[8][a-1],
					{ if (p[8][a]!== 0,
						{

							("level: "++((p[8][a])-1)).postln;
							//b= p[9][a-5];
							//("level start: "++(a-b)).postln;
							//("level lenght: "++b++"sec").postln;
							//c= p[10][a-5];
							//("total above ~threshold: "++c++"sec").postln;
							//d= (c*100/b).asInt;
							//("above threshold: "++d++"%").postln;
							//[a-4] looks at downsampled matrix 4 seconds in the past;
							// this needs to be fixed in the reward.scd file;

							//b.do{ |f| p[11].put((a-b)+f,d)};


						}

					);
					}
				);


				a= a+1;
			}
		);
	}.value;



});

	// make an array for the nf threshold
	p[12]= nfth ! p[0].size;
	//use in case nf threshold was changed manually
	//p[4][0..(234520/256)]= 2.0;
	//p[4][(234520/256)..p[4].size-1]= 1.5;

	p[15]= 0 ! p[0].size; //black line for 0;

	// the datasets to visualize
	datasetA= [
		p[0],
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

	datasetD= [
		p[5],p[7],
		p[13], //incorrect as p[14] needs calculating;
		p[15]
	];

	// setup and customize plotterA
	plotterA.value_(datasetA);       // load dataset
	plotterA.plotMode= \linear;
	plotterA.superpose_(true);   // allow channels overlay
	plotterA.setProperties(          // customize appearence
		\plotColor, [
			colors[0],
			Color.fromHexString("#5C73F2"),
			Color.fromHexString("#5C73F2"),
			Color.new255(0, 100, 0, 200),
			Color.new255(205, 92, 92)

		], // plot colors
		\backgroundColor, Color.white, // background color
		\gridColorX, Color.grey,  	   // gridX color
		//\gridColorY, Color.yellow,   // gridY color
		\gridOnX, true,              // no horizontal grid
		\gridOnY, false            // no vertical grid
	);


	// setup and customize plotterA
	plotterB.value_(datasetB);       // load dataset
	plotterB.plotMode= \steps;
	plotterB.superpose_(true);   // allow channels overlay
	plotterB.specs= [[0, 100, \lin, 1]];
	plotterB.setProperties(          // customize appearence
		\plotColor, [
			Color.new255(0, 100, 0, 200)
		], // plot colors
		\backgroundColor, Color.white, // background color
		\gridColorX, Color.grey,  	   // gridX color
		//\gridColorY, Color.yellow,   // gridY color
		\gridOnX, false,              // no horizontal grid
		\gridOnY, true            // no vertical grid
	);

	plotterC.value_(datasetC);       // load dataset
	plotterC.plotMode= \linear;
	plotterC.superpose_(true);   // allow channels overlay
	plotterC.setProperties(          // customize appearence
		\plotColor, [
			colors[5],colors[7],
			Color.new255(0, 100, 0, 200),
			Color.black
		], // plot colors
		\backgroundColor, Color.white, // background color
		\gridColorX, Color.grey,  	   // gridX color
		//\gridColorY, Color.yellow,   // gridY color
		\gridOnX, true,              // no horizontal grid
		\gridOnY, false            // no vertical grid
	);

	plotterD.value_(datasetD);       // load dataset
	plotterD.plotMode= \linear;
	plotterD.superpose_(true);   // allow channels overlay
	plotterD.setProperties(          // customize appearence
		\plotColor, [
			colors[5],colors[7],
			Color.new255(0, 100, 0, 200),
			Color.black
		], // plot colors
		\backgroundColor, Color.white, // background color
		\gridColorX, Color.grey,  	   // gridX color
		//\gridColorY, Color.yellow,   // gridY color
		\gridOnX, true,              // no horizontal grid
		\gridOnY, false            // no vertical grid
	);
};
)



//2.playing and plotting audio
w.read;
//or
w.read("~/Desktop/20191026-cambridge-festival-of-ideas/20191025/SC_191025_205331.aiff")

w.play  //or 'space' or doubleclick
w.stop
w.yZoom= 0.125  //only zooming, not normalizing - smaller is more magnification (need a higher maximum?)
w.controls= true  //show controls
w.controls= false  //hide
w.background= Color.white
w.rmsColor= Color.red
w.waveColor= Color.black
w.timeCursorColor= Color.blue
