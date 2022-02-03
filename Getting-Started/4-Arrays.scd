// An Array is a particular type of Collection: An ordered collection of limited maximum size.
/*
Arrays are also used to implement multichannel audio!
How many channels depends on the size of the Array.
*/
(
~array = ["Bob", "Alice"];
~array.at(0);
~array.at(1);
~array[1];
)

// Stereo Baby!!
(
var leftChannel, rightChannel;
leftChannel = {
	SinOsc.ar(440, 0, 0.2);
};
rightChannel = {
	SinOsc.ar(442, 0, 0.2);
};
{ [leftChannel, rightChannel] }.play;
)

/*
We've replaced the frequency argument with an Array. This causes something called 'multichannel expansion', which means that if you plug an Array into one of a UGen's arguments, you get an Array of that UGen instead of a single one.
*/
{ SinOsc.ar([440, 442], 0, 0.2) }.play;

/*
.choose randomly selects one of the elements of an Array.
In this case the result may be a single number or another Array. In the case of the latter you'll get stereo output, in the case of the former, monophonic.
*/
(
{ var frequency;
	frequency = [[660, 880], [440, 660], 1320, 880].choose;
	SinOsc.ar(frequency, 0, 0.2);
}.play;
)

// Panning Baby!
{ Pan2.ar(PinkNoise.ar(0.2), SinOsc.kr(0.5)) }.play;
{ Pan2.ar(SinOsc.ar([660, 880]), SinOsc.kr(0.5)) }.play;
{ Pan2.ar(PinkNoise.ar(0.2), -0.3) }.play;    // Slightly to the left

/*
Pan2 takes an input (what to play) and a position (where to play it) as arguments and returns an Array of two elements, the left and right or first and second channels.
Here, our input is PinkNoise (a noise generator with a signle argument: mul) and our position is SinOsc (outputing values from -1 to 1, thus, the fading in panning).
*/