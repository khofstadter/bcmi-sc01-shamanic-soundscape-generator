/*
todo:
how to play 3 ndefs together, needs grouping?
could we have one general function with more arguments?
if bjork0 - add 0 to notes as well
*/


~forest = nil ! 17;
//bps,bpb,bjorkdum,bjorkaccent,enterfreq,enteramp,windlpf
~forest[0] = [0,4,16,0,0,0.0,100,0.01,0.2,500];
~forest[1] = [1,6.6,16,7,4,0.4,100,0.04,0.2,600];
~forest[2] = [2,6.5,16,5,3,0.4,100,0.04,0.2,700];
~forest[3] = [3,6.4,16,3,4,0.4,100,0.04,0.2,800];
~forest[4] = [4,6.3,16,2,8,0.4,100,0.04,0.2,900];
~forest[5] = [5,6.1,16,1,8,0.4,100,0.04,0.2,1000];
~forest[6] = [6,5.8,12,1,4,0.4,100,0.04,0.2,1200];
~forest[7] = [7,5.6,8,1,0,0.4,100,0.04,0.2,1200];
~forest[8] = [8,5.5,8,2,0,0.4,100,0.04,0.2,1300];
~forest[9] = [9,5.4,8,4,0,0.4,100,0.04,0.2,1400];
~forest[10] = [10,4.9,8,8,0,0.5,100,0.04,0.2,1500];
~forest[11] = [11,4.8,8,8,1,0.5,100,0.04,0.2,1600];
~forest[12] = [12,4.7,8,8,2,0.5,100,0.04,0.2,1700];
~forest[13] = [13,4.6,8,8,4,0.5,100,0.04,0.2,1800];
~forest[14] = [14,4.5,8,8,8,0.5,100,0.04,0.2,1900]; //last
~forest[15] = [15,2,4,8,3,0.5,100,0.04,0.2,700]; //triplets
~forest[16] = [16,2,4,8,3,0.0,50,0.01,0.0,400]; //stop

~forestDepth2 = { |depth,bps,bpb,bjorkdum,bjorkaccent,shamanvol,enterfreq,enteramp,windamp, windlpf|
	//reset time:
	//nf settings:
	~timer = [0,0,0,0];
	//~hiThetaEnergy = 10;
	//~timeThreshold = 10;
	// add reward points to move
	t.playNextBar {
		//forest:
		"enter forest depth:".postln;
		~currentForestDepth = depth.postln;
		~timer = [0,0,0,0];
		Ndef(\wind).play;
		Ndef(\wind).spawn([\freq, enterfreq, \amp, enteramp, \sustain, 8]); //retrigger
		Ndef(\wind2).play;
		Ndef(\wind2).fadeTime = 7;
		Ndef(\wind2).xset(\amp, windamp, \lpf, windlpf);
		//shaman:
		~shamanVol = shamanvol;
		~gen.value(bpb,bjorkdum,bjorkaccent);
		Ndef(\0).play;Ndef(\1).play;Ndef(\2).play;
		~shaman.value(bps,bpb);
		//feedback
		Ndef(\theta).play;
	};
};


~forestFlow= nil ! 18;
~currentForestFlowDepth= 0;