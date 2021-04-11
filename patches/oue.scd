W.transport;

TempoClock.default.tempo = 50/60;


~oue = S();
~oue.synth({|freq, gate, aeg|
	var bufpos = \bufpos.kr(0);
    var sig = SinOscFB.ar(freq, -0.7);// * 0.5;
	//var sig = VarSaw.ar(freq, width:Rand(0.3, 0.8));
	sig = RLPF.ar(sig, aeg.linlin(0, 1, 180, 2100), 0.7);
	sig;
});
~oue.fx(10, 'delay/fb', 0.5);

(
~oue << Pspawner({|sp|

	var seq = Pbind(\degree, [1, 0].pseq, \dur, [1, 0.5, 0.5, 2].pseq).asStream;

	inf.do({|i|
		var next = seq.next(Event.default);
		var degree = next[\degree];
		var dur = next[\dur];
		var inner = dur * [0.25, 0.5, 1].pwrand([3, 2, 1]);
		sp.seq(
			Pbind(
				\degree, degree,
				\dur, inner,
				//\legato, Pwhite(0.3, 0.7),
				\sustain, 0.1,
				\dec, 0.1,
				\suslevel, 0.5,
				\rel, 0.1, //Pkey(\dur),
				\harmonic, 1,
				\octave, Pbjorklund(3, 11).linlin(0, 1, 5, 6)-1,
                \delL, Pfunc({
                    TempoClock.default.beatDur * (3/4)
                }),
                \delR, Pfunc({
                    TempoClock.default.beatDur * (4/4)
                }),
				//\mtranspose, [0, 2, 0, 0, 0].pseq.stutter(3),
				//\vel, Pkey(\octave).linlin(4, 5, 0.8, 1),
			).finDur(dur)
		);
	});
})
)

~oue.play;
~oue.stop;


