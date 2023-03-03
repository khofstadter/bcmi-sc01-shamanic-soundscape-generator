// TODO could we have one general function with more arguments?
// TODO if bjork0 - add 0 to notes as well

~forest = 0 ! 12;
//depth,bps,bpb,bjorkdum,bjorkaccent,shamanvol,windlpf
~forest[0] = [0,4,16,0,0,0.01,19000];   //level 0
~forest[1] = [1,6.0,55,7,4,0.4,13000];  //level 10
~forest[2] = [2,5.9,34,5,3,0.4,10000];  //level 9
~forest[3] = [3,5.8,21,3,4,0.4,8000];   //level 8
~forest[4] = [4,5.7,16,2,8,0.4,5000];   //level 7
~forest[5] = [5,5.6,16,4,8,0.4,4000];   //level 6
~forest[6] = [6,5.5,8,4,0,0.4,3000];    //level 5
~forest[7] = [7,5.4,8,4,2,0.4,2000];    //level 4
~forest[8] = [8,5.3,8,4,4,0.4,1100];    //level 3
~forest[9] = [9,5.2,4,4,2,0.4,900];     //level 2
~forest[10] = [10,5.1,4,4,4,0.4,700];   //level 1
~forest[11] = [11,4.5,4,8,3,0.5,100,0.04,0.2,700]; //call back

(
~forestDepth2 = { |depth,bps,bpb,bjorkdum,bjorkaccent,shamanvol,windlpf|
	//reset time:
	//nf settings:
	~timer= [0,0,0,0];
	a= t.elapsedBeats.postln;
	b= t.nextBar.postln;
	c= (b-a)*(1/bps); //beats from next bar * lenght of beats
	c.postln;
	t.sched(0, {
		Ndef(\wind).spawn([\sustain, c]); //retrigger
		t.playNextBar {
			//forest:
			"enter forest depth:".postln;
			~currentForestDepth = depth.postln;
			~timer = [0,0,0,0];
			Ndef(\wind2).xset(\windlpf, windlpf);
			//shaman:
			~shamanVol = shamanvol;
			~gen.value(bpb,bjorkdum,bjorkaccent);
			~shaman.value(bps,bpb);
			//feedback

			(~currentForestDepth !== 0).if {
				Ndef(\numbers).spawn([\buffer, ~numberBufs[(~currentForestDepth-(~forest.size-1);).abs], \amp, 0.4, \pan, 0]); //retrigger
			}
		};
	}
	)
};
);

//~forestFlow= nil ! 18;
~currentForestFlowDepth= 0;