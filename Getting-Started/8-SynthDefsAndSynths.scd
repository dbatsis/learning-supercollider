(
SynthDef.new("tutorial-SinOsc", {
	/* SynthDef has an extra UGen called Out.
	Out writes out an ar or kr signal to one of the server's busses,
	which can be thought of as mixer channels or outputs. */
	|out|    // out argument provides a SynthDef control input.
	Out.ar(out, SinOsc.ar(120, 0, 0.2))
}).play;
)

// ******************************

(
~x = SynthDef.new("tutorial-SinOsc-stereo", { |out|
	var outArray;
	outArray = [SinOsc.ar(261.626, 0, 0.5), SinOsc.ar(329.63, 0, 0.5)];
	Out.ar(out, outArray);
}).play;

~x.free;
)

// ******************************

// send the corresponding byte code to the server app without immediately creating a synth.
// In almost all cases, use 'add' instead of 'play'.
SynthDef.new("tutorial-add-synth-to-server", { |out|
	Out.ar(out, PinkNoise.ar(0.3))
}).add;

~pinkNoise = Synth.new("tutorial-add-synth-to-server");
~pinkNoise.free;

// ******************************

(
/* the UGen Graph Function in a SynthDef is evaluated once and only once, when the SynthDef is created. So, no randomness. */

SynthDef("tutorial-NoRand", { |out|
	Out.ar(out, SinOsc.ar(440 + 200.rand, 0, 0.2)) }).add;
x = Synth("tutorial-NoRand");
y = Synth("tutorial-NoRand");
z = Synth("tutorial-NoRand");
x.free; y.free; z.free;
)

// ******************************
// One way to set variable (args) values at runtime.
(
SynthDef.new("tutorial-args", { arg freq = 261.626, out = 0;
	Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
x = Synth("tutorial-args");    // No args -> Default values.
y = Synth("tutorial-args", ["freq", 660]);    // Change freq.
z = Synth("tutorial-args", ["freq", 880, "out", 1]);
x.free;
y.free;
z.free;

// ******************************
// Another way to set variable (args) values at runtime.
s.boot;
(
SynthDef.new("tutorial-synth-set", { arg freq = 261.626, out = 0;
	Out.ar(out, SinOsc.ar(freq, 0, 0.5));
}).add;
)
s.scope;
x = Synth.new("tutorial-synth-set");
x.set("freq", 660);
x.set("freq", 880, "out", 1);
x.free;

// ******************************
