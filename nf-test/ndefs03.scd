~sampleBufs = [[List.newClear(0), List.newClear(0)],[List.newClear(0), List.newClear(0)],[List.newClear(0), List.newClear(0)]];
	PathName("/Users/khofstadter/Dropbox/PhD/Focus2019/focus_2.1/sounds/0/0").files.do{arg file;
		~sampleBufs[0][0].add(Buffer.read(s, file.fullPath));};
	PathName("/Users/khofstadter/Dropbox/PhD/Focus2019/focus_2.1/sounds/0/1").files.do{arg file;
		~sampleBufs[0][1].add(Buffer.read(s, file.fullPath));};
	PathName("/Users/khofstadter/Dropbox/PhD/Focus2019/focus_2.1/sounds/1/0").files.do{arg file;
		~sampleBufs[1][0].add(Buffer.read(s, file.fullPath));};
	PathName("/Users/khofstadter/Dropbox/PhD/Focus2019/focus_2.1/sounds/1/1").files.do{arg file;
		~sampleBufs[1][1].add(Buffer.read(s, file.fullPath));};
	PathName("/Users/khofstadter/Dropbox/PhD/Focus2019/focus_2.1/sounds/2/0").files.do{arg file;
		~sampleBufs[2][0].add(Buffer.read(s, file.fullPath));};
	PathName("/Users/khofstadter/Dropbox/PhD/Focus2019/focus_2.1/sounds/2/1").files.do{arg file;
		~sampleBufs[2][1].add(Buffer.read(s, file.fullPath));};

// frame drum fingers
Ndef(\0, {|rate= 1, amp= 1, buffer, pan= 0, t_trig=1|
	Pan2.ar(
		PlayBuf.ar(1, buffer, rate*BufRateScale.ir(buffer), t_trig),
		pan,
		amp * EnvGen.ar(Env.perc(0.01, 2, 1, -8), t_trig, doneAction:2)
)});

Ndef(\1, {|rate= 1, amp= 1, buffer, pan= 0, t_trig=1|
	Pan2.ar(
		PlayBuf.ar(1, buffer, rate*BufRateScale.ir(buffer), t_trig),
		pan,
		amp * EnvGen.ar(Env.perc(0.01, 2, 1, -8), t_trig, doneAction:2)
)});

Ndef(\2, {|rate= 1, amp= 1, buffer, pan= 0, t_trig=1|
	Pan2.ar(
		PlayBuf.ar(1, buffer, rate*BufRateScale.ir(buffer), t_trig),
		pan,
		amp * EnvGen.ar(Env.perc(0.01, 2, 1, -8), t_trig, doneAction:2)
)});

// wind
Ndef(\wind, {|freq=37, pan=0, amp=0.0, sustain=5.25|
	var freqs, ringtimes, snd;
	freqs = Control.names([\freqs.midicps]).kr([1,1,1,1]);
	ringtimes = Control.names([\ringtimes]).kr([1,1,1,1]);
	snd = DynKlank.ar(`[freqs, nil, ringtimes ], ClipNoise.ar(0.003), freq);
	snd = snd * EnvGen.ar(Env.perc(0.01, sustain, 1, -8), doneAction:2);
	snd = Pan2.ar(snd*amp, pan);
	snd = HPF.ar(snd, 50);
	snd = LPF.ar(snd, 5000);
});

(
// wind2
Ndef(\wind2, {|freq=37, pan=0, amp=0.0, lpf=2000|
	var freqs, ringtimes, snd;
	freqs = Control.names([\freqs.midicps]).kr([1,1.1,1.2,1.3]);
	ringtimes = Control.names([\ringtimes]).kr([1,1.1,1.2,1.3]);
	snd = DynKlank.ar(`[freqs, nil, ringtimes], ClipNoise.ar(0.002), freq);
	snd = Pan2.ar(snd*amp, pan);
	snd = HPF.ar(snd, 50);
	snd = LPF.ar(snd, lpf);
});
);

(
// theta
Ndef(\theta, {|pan=0, amp=0.02, sustain, decay|
	var snd;
	snd = ClipNoise.ar(amp);
	snd = amp * snd * EnvGen.ar(Env.perc(0.01, sustain, decay, -8), doneAction:2);
	snd = Pan2.ar(snd,pan);
	snd = HPF.ar(snd, 50);
	snd = LPF.ar(snd, 19000);
	snd = FreeVerb.ar(snd, 0.3, 1);
});
);

/*
Ndef(\theta, {|change0=0, change1=0, freq=37, pan = 0, amp=0.1, sustain=0.25|
	var snd = Pulse.ar(freq.midicps*change0.linlin(0,1,1,1.05), 0.1, 4);
	snd = HPF.ar(snd, 300);
	snd = Limiter.ar(snd);
	snd = snd * EnvGen.ar(Env.perc(0.01,sustain, 1, -8), doneAction:2);
	snd = Pan2.ar(snd * amp, pan);
	snd = HPF.ar(snd, 100);
	snd = GVerb.ar(snd, 5, 2);
}).add;
*/