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

/*Private Busses can be anything besides input and output channels. All control busses are private.*/

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

(
// Create 2 control rate busses.
// Use the .set method to assign constant values to them.
~busOne = Bus.control(s, 1); ~busOne.set(329.63);
~busTwo = Bus.control(s, 1); ~busTwo.set(392);

~synth = SynthDef("MappingSynth",
	{
		arg freq1 = 440, freq2 = 440, out;

		Out.ar(out, SinOsc.ar([freq1, freq2], mul:0.1));
	}
).play(s);
)

// Here we map ~synth arguments freq1, freq2 to read from the two busses.
~synth.map(\freq1, ~busOne, \freq2, ~busTwo);

(
// Write a control rate signal to busOne.
// This creates a fluctuation in frequency.
~writeToBus = {
	Out.kr(~busOne, SinOsc.kr(1, 0, 50, 329.63))
}.play(addAction: \addToHead);
)
// When we free this, ~busOne holds the last value assigned to it
// (resulting from the above mentioned fluctuation).
~writeToBus.free;

// Use .get method to poll bus's value.
// We use a function called 'Action Function' allowing us to do something with the returned value. Here we store it in a global variable to access it later.
~busOne.get({ arg val; val.postln; f = val;	});

// Setting freq2 unmaps it from busTwo.
~synth.set(\freq2, f / 2);

~synth.free; ~busOne.free; ~busTwo.free;

// ********************
// A few words on latency

/*
Earlier in bus's .get method we used a function to acquire it's current value.
We used a function because the Server needs a little time to respond with the value.
This is our latency. Consider the following example:
*/
~bus = Bus.control(s, 1); ~bus.set(329.63);

(
f = nil;
~bus.get({ arg val; f = val; });
f.postln;
)
// The above returns nil.

f.postln;  // This returns 329.63.

// ********************
// Getting it all in the Right Order

/*
As a general rule, when you are connecting synths together using busses it is important that synths which write signals to busses are earlier in the server's order than synths which read those signals from those busses.
*/

~firstSynth = Synth("default", [\freq, 300]);
~secondSynth = Synth("default", [\freq, 450], ~firstSynth, \addAfter);

// Another way of doing the same thing:
~firstSynth = Synth("default", [\freq, 300]);
~secondSynth = Synth.after(~firstSynth, "default", [\freq, 450]);

~firstSynth.free; ~secondSynth.free;