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