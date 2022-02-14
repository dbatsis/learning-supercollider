/*Busses are named after the busses or sends in analog mixing desks, and they serve a similar purpose: routing signals from one place to another.
-> In SC, this means to or from the audio hardware, or between different synths.
-> They come in two types: audio rate and control rate. As you've probably guessed, the former routes audio rate signals and the latter routes control rate signals.

If we imagine a server with two output channels and two input channels (i.e. stereo in and out) then the first two audio busses (index 0 and index 1) will be the outputs, and the two immediately following those (index 2 and index 3) will be the inputs.

The number of control and audio busses available, as well as the number of input and output channels, is set at the time the server app is booted (see ServerOptions).
*/

// ********************

// To read in from a bus you use another UGen: In.
In.ar(0, 1);
In.ar(0, 4);

/*In's 'ar' method also takes two arguments: an index, and the number of channels to read in. If the number of channels is greater than one, than In's output will be an Array.*/

// ********************

// When multiple Synths write to the same bus, their output is summed (i.e. mixed).
(
SynthDef.new("SinOsc-Synth",
	{
		arg freq = 220, out = 0;
		Out.ar(out, SinOsc.ar(freq, 0, 0.2))
	}
).add;
)
~synth_264 = Synth("SinOsc-Synth", ["out", 1, "freq", 264]);
~synth_452 = Synth("SinOsc-Synth", ["out", 1, "freq", 452]);

// ********************

/*Creating a Bus Object:
Just as many UGens have ar and kr methods, Bus has two commonly used creation methods: Bus-audio and Bus-control. These each take two arguments: a Server object, and the number of channels.*/

b = Bus.control(s, 2);  // Two channel control Bus
c = Bus.audio(s)  // One channel private audio Bus