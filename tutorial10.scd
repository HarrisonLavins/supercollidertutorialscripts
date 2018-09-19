// The scripts used in Eli Fieldsteel's
// SuperCollider Tutorial: 10. Patterns
// https://www.youtube.com/watch?v=nB_bVJ1c1Rg&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=11

// Example 1 - Demonstrates basic usage of Pbind
// (This basic template is expanded upon in tutorial video)
(
SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\freq, Pseq([330, 247, 370], inf).trace,
// Revision: if you'd rather specify notes by their MIDI note num:
// \midinote, Pseq([60, 65, 67, 74], inf).trace
).play;
)

// Example 2 - Demonstrates basic usage of Pbind with random-value parameters
// (Uses the same SynthDef from above)
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\freq, Pexprand(50, 4000, inf).trace,
// Revision: we can align the frequency with the harmonic series
//	\midinote, 33,
//	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
// Revision, we can have one pattern depend on an earlier pattern
//  \amp, Pkey(\harmonic).reciprocal * 0.3,
	\pan, Pwhite(-0.8, 0.8, inf),
).play;
)

// Example 3 - Demonstrates use of Pdef to control patterns in real-time
// Just change the values while playing, then re-evaluate the Pdef
(
Pdef(
	\sinepat,
    Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([33], inf).trace,
		\harmonic, Pexprand(1, 80, inf).round,
		\atk, Pwhite(2.0, 3.0, inf),
		\rel, Pwhite(5.0, 10.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).play;
)

// ---------------------------------------------------------
