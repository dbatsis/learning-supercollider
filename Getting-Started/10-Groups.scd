/*
Synths on the Server are called 'nodes'. Another type of node are groups.
Groups are simply collections of nodes, and can contain synths, other groups, or combinations of both.
They are useful in two ways:
1. Controlling order.
1. Group together nodes and send them messages all at once.
*/

// ********************
// Groups as Ordering Tools

~group1 = Group.new;
~group2 = Group.before(~group1);
~group1.free; ~group2.free;

// Using groups with our reverb example from BufferDemo.
(
SynthDef(\DecaySin,
	{
		arg outBus = 0, effectBus, direct = 0.5, freq = 329.63;
		var source;

		source = Pan2.ar(
			in:Decay2.ar(
				in:Impulse.ar(freq:Rand(0.3, 1), mul:0.125),
				attackTime:0.3,
				decayTime:1,
				mul:SinOsc.ar(SinOsc.kr(0.2, 0, 110, freq))
			),
			pos:Rand(-1.0, 1.0)
		);

		Out.ar(outBus, source * direct);
		Out.ar(effectBus, source * (1 - direct));
	}
).add;

SynthDef(\Reverb,
	{
		arg outBus = 0, inBus;
		var input;

		input = In.ar(bus:inBus, numChannels:2);

		16.do(
			{
				input = AllpassC.ar(
					in:input,
					maxdelaytime:0.04,
					delaytime:Rand(0.001, 0.04),
					decaytime:3
				)
			}
		);

		Out.ar(bus:outBus, channelsArray:input);
	}
).add;
)

(
~sources = Group.new;
~effects = Group.after(~sources);
// Our stereo effects Bus
~bus = Bus.audio(s, numChannels:2);
)

(
~reverbSynth = Synth(\Reverb, [\inBus, ~bus]);
// The default addAction is \addToHead.
~decaySinSynth = Synth(\DecaySin, [\effectBus, ~bus, \outBus, 0], target:~sources);
~decaySinSynth392 = Synth(\DecaySin, [\effectBus, ~bus, \outBus, 0, \freq, 392], ~sources);
)

(
~sources.free; ~effects.free;
~bus.free;
currentEnvironment.clear;
)

// ********************
// All the addActions

/*
\addToHead : Add the receiver to the beginning of the group. Executes first.
\addToTail : Add the receiver to the end of the group. Executes last.
*/

(
~group1 = Group.new;
~group2 = Group.head(~group1);  // Add ~group2 to the head of ~group1.
~group3 = Group.tail(~group2, \default);  // Add ~group3 to the tail of ~group2.
)
s.queryAllNodes;  // Post a representation of the node hierarchy.
~group1.free; ~group2.free; ~group3.free;

// ********************
// 'queryAllNodes' and node IDs

