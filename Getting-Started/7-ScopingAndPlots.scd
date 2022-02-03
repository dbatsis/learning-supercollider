// This makes a graph of the signal produced by the output of the Function.
(
{
	PinkNoise.ar(0.2) + SinOsc.ar(100, 0, 0.2) + Saw.ar(250, 0.2)
}.plot;
)

// Specify the duration
(
{
	PinkNoise.ar(0.2) + SinOsc.ar(100, 0, 0.2) + Saw.ar(250, 0.2)
}.plot(1);
)

// Function-scope, shows an oscilloscope-like display of the Function's output.
(
{
	PinkNoise.ar(0.2) + SinOsc.ar(100, 0, 0.2) + Saw.ar(250, 0.2)
}.scope;
)

// Works for stereo, higher zoom values zoom out.
{[SinOsc.ar(100, 0, 0.2), SinOsc.ar(250, 0, 0.2)]}.scope(zoom: 10);