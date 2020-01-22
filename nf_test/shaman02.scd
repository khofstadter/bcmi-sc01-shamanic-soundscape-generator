/*TODO
- have new type of if's
- try withouth Bjorklund dependency;
*/

//shaman
~pan= 0.1; //stereo width

//generate ~notes for the shaman to play
~gen = { |bpb,bjorkdum,bjorkaccent|
	var para;
	var bjork1;
	var bjork2;
	~notes = Array.fill3D(3, bpb, 5, nil); //nb. of instruments, beatsPerBar, note metadata, values
	/* note metadata:
	//0 - freq/playback rate
	//1 - amplitude
	//2 - sustain
	//3 - panning
	4 - sample library
	*/

	//paradiddle
	1.do{
		if(bpb < 32,
			{
				a = nil ! (bpb/2); //first half of the paradiddle (maybe the divider can be an argument as well)
				a.size.asInt.do{ |i|
					if(i<((bpb/2)-1), //relationship between 8%3,12%5,16&7
						{a[i] = i%2;}, //write 0 and 1 after each other
						{a[i] = a[0];} //only write 0 from now on
					);
				};

				b = 1 - a; //flip all ones and zeros
				para = a ++ b; //concatenate the results
				para.postln
			},

			{
				para = Array.fill(bpb, { arg i; i%2 });
				para.postln // 1st step
			};
		);
	};


	//Euclidean

	bjork1 = Bjorklund(bjorkdum,bpb);
	bpb.do{ |i|
		if(bjork1[i]==1,
			{
				para[i] = 2;
			}
		)
	};

	para.postln; //2nd step

	bjork2 = Bjorklund(bjorkaccent,bpb);
	bjork2.postln; //3rd step

	bpb.do{ |x|

		case
		{para[x]==0}
		{
			~notes[0][x][0] = 1; //freq
			//~notes[0][x][1] = 1; //amp
			//~notes[i][x][2] =
			//~notes[0][x][3] = ~panning[0]; //right

			// improve: can case be replaced with something faster?
			case
			{bjork2[x]==0}
			{~notes[0][x][4] = ~sampleBufs[0][0]}

			{bjork2[x]==1}
			{~notes[0][x][4] = ~sampleBufs[0][1]}
		}

		{para[x]==1}

		{

			~notes[1][x][0] = 1;
			//~notes[1][x][1] = 1;
			//~notes[i][x][2] =
			//~notes[1][x][3] = ~panning[1]; //left

			case
			{bjork2[x]==0}
			{~notes[1][x][4] = ~sampleBufs[1][0]}

			{bjork2[x]==1}
			{~notes[1][x][4] = ~sampleBufs[1][1]}

		}

		{para[x]==2}

		{
			~notes[2][x][0] = 1;
			//~notes[2][x][1] = 1;
			//~notes[i][x][2] =
			//~notes[2][x][3] = 0; //center

			case
			{bjork2[x]==0}
			{~notes[2][x][4] = ~sampleBufs[2][0]}

			{bjork2[x]==1}
			{~notes[2][x][4] = ~sampleBufs[2][1]}

		};

	};
};

// variation
~shaman = { |bps,bpb|
	t.clear;
	t.tempo_(bps);
	t.schedAbs(0,{t.beatsPerBar=bpb;});
	t.play({
		x = (t.beats%bpb).round;
		if (~notes[0][(x).round][4] != nil, // 0 left
			{
				Ndef(\0).spawn([\buffer, (~notes[0][x][4]).choose, \amp, ~shamanVol, \pan, ~pan],); //retrigger
			}
		);
		if (~notes[1][(x).round][4] != nil, // 1 right
			{
				Ndef(\1).spawn([\buffer, (~notes[1][x][4]).choose, \amp, ~shamanVol, \pan, ~pan.neg]); //retrigger
			}
		);
		if (~notes[2][(x).round][4] != nil, // 2 middle
			{
				Ndef(\2).spawn([\buffer, (~notes[2][x][4]).choose, \amp, ~shamanVol, \pan, 0]); //retrigger
			}
		);

		if (~timer[2] !== 0, // 2 middle
			{
				Ndef(\theta).spawn([\sustain, (3.rand+1)/10, \decay, (2.rand+1), \pan, ((5.rand)-2.5)/10]); //retrigger
			}
		);
		1
	});
};