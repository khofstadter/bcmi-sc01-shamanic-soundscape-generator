
// TODO how to play 3 ndefs together, needs grouping?
// TODO could we have one general function with more arguments?
// TODO if bjork0 - add 0 to notes as well


~forest = 0 ! 12;
//depth,bps,bpb,bjorkdum,bjorkaccent,shamanvol,windlpf
~forest[0] = [0,4,16,0,0,0.01,19000];
~forest[1] = [1,6.6,16,7,4,0.1,13000];
~forest[2] = [2,6.5,16,5,3,0.2,10000];
~forest[3] = [3,6.4,16,3,4,0.3,8000];
~forest[4] = [4,6.3,16,2,8,0.4,5000];
~forest[5] = [5,6.1,16,1,8,0.4,4000];
~forest[6] = [6,5.8,12,1,4,0.4,3000];
~forest[7] = [7,5.6,8,1,0,0.4,2000];
~forest[8] = [8,5.5,8,2,0,0.4,1100];
~forest[9] = [9,5.4,8,4,0,0.4,900];
~forest[10] = [10,4.9,8,8,0,0.5,700];
~forest[11] = [11,2,4,8,3,0.5,100,0.04,0.2,700];

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