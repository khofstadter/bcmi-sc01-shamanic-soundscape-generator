//shaman drum samples:
~sampleBufs = [[List.newClear(0), List.newClear(0)],[List.newClear(0), List.newClear(0)],[List.newClear(0), List.newClear(0)]];
PathName(~pathway++"/sounds/0/0").files.do{arg file;
		~sampleBufs[0][0].add(Buffer.read(s, file.fullPath));};
	PathName(~pathway++"/sounds/0/1").files.do{arg file;
		~sampleBufs[0][1].add(Buffer.read(s, file.fullPath));};
	PathName(~pathway++"/sounds/1/0").files.do{arg file;
		~sampleBufs[1][0].add(Buffer.read(s, file.fullPath));};
	PathName(~pathway++"/sounds/1/1").files.do{arg file;
		~sampleBufs[1][1].add(Buffer.read(s, file.fullPath));};
	PathName(~pathway++"/sounds/2/0").files.do{arg file;
		~sampleBufs[2][0].add(Buffer.read(s, file.fullPath));};
	PathName(~pathway++"/sounds/2/1").files.do{arg file;
		~sampleBufs[2][1].add(Buffer.read(s, file.fullPath));};

//numbers samples:
~numberBufs = List.newClear(0);
PathName(~pathway++"/sounds/numbers").files.do{arg file; ~numberBufs.add(Buffer.read(s, file.fullPath));};


// frame drum fingers
Ndef(\0, {|rate= 1, amp= 1, buffer, panlr= 0, t_trig=1|
	Pan2.ar(
		PlayBuf.ar(1, buffer, rate*BufRateScale.ir(buffer), t_trig),
		panlr,
		amp * EnvGen.ar(Env.perc(0.01, 2, 1, -8), t_trig, doneAction:2)
)});

Ndef(\1, {|rate= 1, amp= 1, buffer, panlr= 0, t_trig=1|
	Pan2.ar(
		PlayBuf.ar(1, buffer, rate*BufRateScale.ir(buffer), t_trig),
		panlr,
		amp * EnvGen.ar(Env.perc(0.01, 2, 1, -8), t_trig, doneAction:2)
)});

Ndef(\2, {|rate= 1, amp= 1, buffer, panlr= 0, t_trig=1|
	Pan2.ar(
		PlayBuf.ar(1, buffer, rate*BufRateScale.ir(buffer), t_trig),
		panlr,
		amp * EnvGen.ar(Env.perc(0.01, 2, 1, -8), t_trig, doneAction:2)
)});

//numbers
Ndef(\numbers, {|rate= 1, amp= 0.7, buffer, panlr= 0, t_trig=1|
	Pan2.ar(
		PlayBuf.ar(1, buffer, rate*BufRateScale.ir(buffer), t_trig, doneAction:2),
		panlr,
		amp
)});

// wind
Ndef(\wind, {|panlr=0, amp=0.2, sustain=3|
	var snd;
	snd= PinkNoise.ar(0.1);
	snd = snd * EnvGen.ar(Env.perc(sustain, 0.01, 1, 1), doneAction:2);
	snd = Pan2.ar(snd*amp, panlr);
	snd = HPF.ar(snd, 50);
	snd = LPF.ar(snd, 5000);
});

// wind2
Ndef(\wind2, {|amp=0.1, panlr=0, windlpf=10000|
	var snd;
	snd= BrownNoise.ar(0.1);
	snd = Pan2.ar(snd*amp,panlr);
	snd = HPF.ar(snd, 100);
	snd = LPF.ar(snd, windlpf);
});

// theta
Ndef(\theta, {|panlr=0, amp=0.1, sustain, decay|
	var snd;
	snd = ClipNoise.ar(amp);
	snd = amp * snd * EnvGen.ar(Env.perc(0.01, sustain, decay, rrand(-16,-4)), doneAction:2);
	snd = Pan2.ar(snd,panlr);
	snd = HPF.ar(snd, 50);
	snd = LPF.ar(snd, 19000);
	snd = FreeVerb.ar(snd, 0.3, 1);
});

Ndef(\theta).vol= 0.4;