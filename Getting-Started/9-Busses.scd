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

/*Private Busses are anything besides the input and output chennels. All control busses are private.*/

// ********************

s.reboot;  // This will restart the server and thus reset the bus allocators.

// b is a 2 channel control Bus. It uses indices 0 and 1 (so 2 in number).
b = Bus.control(s, 2);
b.index;
b.numChannels;

// c is a single channel private control Bus. It uses index 2 (one in number).
c = Bus.control(s);
c.index;
c.numChannels;
c.free;  // Free the index! You can't use this Bus object after that.

/*But wait, what are indices used for?
They are used to pick the right bus.
"The first few busses are the output and input channels. Consider our server app with 2 output and 2 input channels. The first private audio bus is index 4. (0, 1, 2, 3 ... 4!)"*/

// ********************

// Busses in Action

(
SynthDef("tutorial-inFreq",
	{
		arg bus, out, freqOffset = 0;
		// This will add freqOffset to whatever is read in from the bus.
		Out.ar(out, SinOsc.ar(In.kr(bus) + freqOffset, 0, 0.5));
	}
).add;

SynthDef("tutorial-outFreq",
	{
		arg bus, freq = 440;
		Out.kr(bus, SinOsc.kr(1, 0, freq/40, freq));
	}
).add;

~myBus = Bus.control(s, 1);
)

(
~synthOut = Synth.new("tutorial-outFreq", [\bus, ~myBus]);
~synthIn = Synth.after(~synthOut, "tutorial-inFreq", [\bus, ~myBus]);
~synthInOffset = Synth.after(~synthOut, "tutorial-inFreq", [\bus, ~myBus, \freqOffset, 200]);
)
~synthOut.free; ~synthIn.free; ~synthInOffset.free; ~myBus.free;

// ********************
// More Fun with Control Busses


