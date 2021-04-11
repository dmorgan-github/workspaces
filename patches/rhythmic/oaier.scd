TempoClock.default.tempo = 45/60;
W.transport;


~oaier = S();
~oaier.synth(\pm2op);
~oaier.fx(10, 'delay/fb', 0.6);
~oaier.fx(20, {|in| PitchShift.ar(in, 2, 1.5, 0.01, 0.01);}, 0.4);

(
~oaier << Pspawner({|sp|

    var seq = Pbind(\degree, [1, 0, 2].pseq, \dur, Pbjorklund2(3, 8, inf) * 0.25, \vdepth, 0.01).asStream;
    inf.do({|i|
        var next = seq.next(Event.default);
        var dur = next[\dur];
        sp.seq(
            (
                Pseq([

                    Pbind(
                        \octave, Pmap(3, 8, 5, 6),
                        \dur, 0.1,
                        \legato, 1,
                        \harmonic, [1, 1.5],
                        \rel, 0.5, //durmul.linlin(1, 2.5, 2, 0.1),
                        \op1_m2, 0.6,
                        \op2ratio, 1,
                        //\degree, Pkey(\degree) + [0, 1, 2].pseq,
                        \fb, 0.2,
                        \delL, Pfunc({
                            TempoClock.default.beatDur * 3/4
                        }),
                        \delR, Pfunc({
                            TempoClock.default.beatDur * 4/4
                        }),
                        \amp, -6.dbamp
                    ).fin(1),

                    Pbind(
                        \stretch, Prand([0.5, 0.25, 1/3], inf),
                        \octave, 7,
                        \legato, 0.2,
                        \rel, 0.1, //durmul.linlin(1, 2.5, 2, 0.1),
                        \op1_m2, 1,
                        \op2ratio, 4,
                        //\degree, Pkey(\degree) + [0, 1, 2].pseq,
                        \fb, 0.2,
                        \delL, Pfunc({
                            TempoClock.default.beatDur * 3/4
                        }),
                        \delR, Pfunc({
                            TempoClock.default.beatDur * 4/4
                        }),
                        \amp, -10.dbamp
                    )

                ], inf)

                <> next
            ).finDur(dur);
        );
    });
})
)

~oaier.play;
~oaier.stop;