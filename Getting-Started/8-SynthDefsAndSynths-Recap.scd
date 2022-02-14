/*The server doesn't understand Functions, or OOP, or the SC language. It wants information on how to create audio output in a special form called a synth definition. A synth definition is data about UGens and how they're interconnected.*/

/*Whenever you use any of Function's audio creating methods what happens is that a corresponding instance of SynthDef is created 'behind the scenes', so to speak, and the necessary byte code is generated and sent to the server, where a synth is created to play the desired audio.*/

// ********************

// Function
{ SinOsc.ar(440, 0, 0.2) }.play;

// The equivalent SynthDef
SynthDef.new("tutorial-SinOsc",
	{
	arg out;
	Out.ar(out, SinOsc.ar(440, 0, 0.2))
	}
).play;
/*The |out| argument defines a SynthDef control input, which is then used as the first input to Out.ar.
The extra UGen called Out writes an ar or kr signal to one of the server's busses, which can be thought of as mixer channel or output.*/

// ********************

/*Out takes two arguments: The first is the index number of the bus to write out on. These start from 0, which on a stereo setup is usually the left output channel. The second is either a UGen or an Array of UGens.*/
(
SynthDef.new("tutorial-SinOsc-stereo",
	{
		arg out;
		var outArray;
		outArray = [SinOsc.ar(440, 0, 0.2), SinOsc.ar(220, 0, 0.2)];
		Out.ar(out, outArray)
	}
).play;
)

// ********************

// Assign a Function to a variable
~func = { SinOsc.ar(440, 0, 0.2) }.play;

// Assign a SynthDef to a variable
~synthDef = SynthDef.new("tutorial-SinOsc",
	{
		|out|
		Out.ar(out, SinOsc.ar(440, 0, 0.2))
	}
).play;
~func.free;
~synthDef.free;

// ********************

/*To create the SynthDef (send it to the Server), without immediately playing it, use .add; instead of .play;*/
SynthDef.new("tutorial-add",
	{
		|out|
		Out.ar(out, SinOsc.ar(440, 0, 0.2))
	}
).add;
~mySynthDef = Synth.new("tutorial-add");
~mySynthDef.free;

// ********************

/*SynthDefs are evaluated only once.
Compare the following two examples.*/

// Everytime play is called, a new random frequency is chosen.
~func = { SinOsc.ar(220 + 200.rand, 0, 0.2) };
x = ~func.play;
y = ~func.play;
z = ~func.play;
x.free; y.free; z.free;

/*Each time you create a new Synth based on the def, the frequency is the same. This is because the Function (and thus 200.rand) is only evaluated only once, when the SynthDef is created.*/
SynthDef.new("tutorial-evaluated-once",
	{
		|out|
		Out.ar(out, SinOsc.ar(220 + 200.rand, 0, 0.2))
	}
).add;
x = Synth("tutorial-evaluated-once");
y = Synth("tutorial-evaluated-once");
z = Synth("tutorial-evaluated-once");
x.free; y.free; z.free;

// ********************

SynthDef.new("tutorial-random-with-UGen",
	{
		|out|
		Out.ar(out, SinOsc.ar(Rand(220, 440), 0, 0.2))
	}
).add;
x = Synth("tutorial-random-with-UGen");
y = Synth("tutorial-random-with-UGen");
z = Synth("tutorial-random-with-UGen");
x.free; y.free; z.free;

// ********************

SynthDef.new("tutorial-passing-arguments",
	{
		arg freq = 220, out = 0;
		Out.ar(out, SinOsc.ar(freq, 0, 0.2))
	}
).add;
~synth_no_parameters = Synth("tutorial-passing-arguments");
~synth_with_parameters = Synth("tutorial-passing-arguments", ["freq", 440, "out", 1]);
~synth_no_parameters.free; ~synth_with_parameters.free;

// ********************

s.boot;
SynthDef.new("tutorial-passing-arguments-2",
	{
		arg freq = 440, out = 0;
		Out.ar(out, SinOsc.ar(freq, 0, 0.2))
	}
).add;
s.scope;
~synth = Synth("tutorial-passing-arguments-2");
~synth.set("freq", 220);
~synth.set("out", 1);
~synth.free;

