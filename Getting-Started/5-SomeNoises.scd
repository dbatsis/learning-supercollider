// Band Limited sawtooth wave generator.
(play(
	{
		Saw.ar([100, 250], 0.1)
	}
);)


(
{ SinOsc.ar(XLine.kr(8000, 400, 5), mul:0.01) }.play;
)

(
play({ SinOsc.ar(XLine.kr(200, 17000, 10), 0, 0.01) });
)

(
{
	PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2)
}.play;
)

(
play( {SinOsc.ar(200) } );
)

(
play({ RLPF.ar(SinOsc.ar(200)) });
)

(
{
	// Two band limited sawtooth waves through a resonant low pass filter.
	RLPF.ar(Saw.ar([100, 250], 0.1), XLine.kr(8000, 400, 5), 0.05)
}.play;
)

(
{
	var saw = Saw.ar([100, 250], 0.1);
	var xline = XLine.kr(500, 200, 5);
	var amplitude = 0.05;

	var sound = RLPF.ar(saw, xline, amplitude);
	var pan = SinOsc.kr(0.5);

	Pan2.ar(sound, pan);
}.play;
)

(
play(
	{
		var ct1 = RLPF.ar(Saw.ar(5, 0.1), 25, 0.03);
		SinOsc.ar(ct1 * 200 + 400) * 0.01;
	}
);
)

// Move your mouse!
(
{
	var saw = Saw.ar([100, 250], mul:0.1);
	var mousex = MouseX.kr(2, 200, 1);
	var mousey = MouseY.kr(0.01, 1, 1);

	var filtered_sound = RLPF.ar(saw, mousex, mousey);
	SinOsc.ar(filtered_sound * 200 + 100) * 0.2;
}.play;
)