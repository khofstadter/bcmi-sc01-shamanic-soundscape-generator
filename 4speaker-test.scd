// list devices:
ServerOptions.inDevices
ServerOptions.outDevices;

(
Server.killAll;
s.options.numOutputBusChannels= 4;
s.options.numInputBusChannels= 1;
s.reboot;
s.meter;
s.boot;
)

// synthDef for testing
(
SynthDef("help-out", { arg out=0, freq=440;
    var source;
        source = SinOsc.ar(freq, 0, 0.1);

        // write to the bus, adding to previous contents
        Out.ar(out, source);

}).add;
)


// MAKE SURE OUTPUT VOLUME IN SC IS LOW!!!:
Synth("help-out", [\out, 0, \freq, 200]);
Synth("help-out", [\out, 1, \freq, 400]);
Synth("help-out", [\out, 2, \freq, 600]);
Synth("help-out", [\out, 3, \freq, 800]);

// test 2:
{ Pan4.ar(PinkNoise.ar, FSinOsc.kr(2), FSinOsc.kr(1.2), 0.3) }.play;