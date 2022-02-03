// Mix doesn't actually create Mix objects, it just returns the results of its summing, either a BinaryOpUGen or an Array of them.

// Combine two channels in a single one.
(
{
	var left_channel = SinOsc.ar(200, 0, 0.2);
	var right_channel = Saw.ar(666, 0.2);

	Mix.new(left_channel, right_channel).postln;
}.play;
)

// Combine two stereo channels in a single one.
(
{
	var left_channel1 = SinOsc.ar(250, 0, 0.2);
	var right_channel1 = Saw.ar(666, 0.2);

	var left_channel2 = SinOsc.ar(100, 0, 0.2);
	var right_channel2 = Saw.ar(1665, 0.2);

	var stereo1 = [left_channel1, right_channel1];
	var stereo2 = [left_channel2, right_channel2];

	Mix([stereo1, stereo2]);
}.play;
)

// This sounds like the devil...
(
{
	var number_of_evaluations = 8;
	var function = {
		SinOsc.ar(500 + 500.0.rand, 0, 0.05);
	};

	Mix.fill(number_of_evaluations, function);
}.play;
)

(
var number_of_evaluations = 32;
var function = {
	arg index;    // Holds the iteration number.
	var freq;

	index.postln;
	freq = 100 + index;
	freq.postln;

	SinOsc.ar(freq, 0, 1 / number_of_evaluations);
};
var panning = true;
{
	if (
		panning == true,
		{Pan2.ar(Mix.fill(number_of_evaluations, function), SinOsc.kr(0.8))},
		{Mix.fill(number_of_evaluations, function)}
	)

}.play;
)

(
~throbbing = {
	arg number_of_evaluations, base_freq, panning;

	var throb = {
		arg index;
		var freq;

		freq = base_freq + index;
		SinOsc.ar(freq, 0, 1 / number_of_evaluations);
	};

	if (
		panning == true,
		{{Pan2.ar(Mix.fill(number_of_evaluations, throb), SinOsc.kr(0.8))}.play},
		{{Mix.fill(number_of_evaluations, throb)}.play}
	)
};

~throbbing.value(32, 100, true);
~throbbing.value(64, 98, false);
)