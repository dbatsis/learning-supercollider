/*
Some notes on UGen arguments
freq: frequency of the oscillator in Hertz (Hz), or cycles per second (cps).
phase: where it will start in the cycle of its waveform
(values between 0 and 2 * pi).
mul: a value or signal by which the output of the UGen will be multiplied.
In the case of audio signals, this affects the amplitude of the signal, or how loud it is. The default mul of most UGens is 1, which means that the signal will oscillate between 1 and -1.
add: something which is added to the output signal.
*/

({
	SinOsc.ar(440)
}.play;)

(
{ var ampOsc;
	// ampOsc is our Amplitude Envelope.
	/*
	Frequency is set to 0.5 cps, which means that it will complete one cycle every 2 seconds.
	If by default SinOsc goes between 1 and -1, then a mul of 0.5 will scale that down to between 0.5 and -0.5. Adding 0.5 to that brings it to between 0 and 1.
	The phase of 1.5pi (this just means 1.5 * pi) means 3/4 of the way through its cycle or, the lowest point.
	*/
	ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
	SinOsc.ar(300, 0, ampOsc);
}.play;
)

// Stereo Baby!
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