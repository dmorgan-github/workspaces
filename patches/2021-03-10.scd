(
SynthDef(\s1, {
    var freq = \freq.kr(261);
    var gate = \gate.kr(1);
    var mod = SinOscFB.ar(freq * \mratio.kr(1), \fb.kr(0)) * Env.perc(0.01, 0.1).ar(gate:gate);
    var sig = SinOsc.ar(freq, (mod * \m.kr(1)).mod(2pi));
    var aeg = Env.adsr(
        \atk.kr(0.01),
        \dec.kr(0.3),
        \suslevel.kr(0.5),
        \rel.kr(1),
        curve:\curve.kr(-4)
    ).ar(doneAction:Done.freeSelf, gate: gate);
    sig = sig * AmpCompA.kr(freq) * aeg * \amp.kr(-6.dbamp) * \vel.kr(1);
    sig = Splay.ar(sig, \spread.kr(1), center:\pan.kr(0));
    Out.ar(\out.kr(0), sig);
}).add;
)

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

Pdef(\base, Pbind(\root, 2, \amp, -6.dbamp, \scale, Scale.ritusen));

~sig = (Signal.sineFill(32, { rrand(0.1, 1.0)}.dup(8)) * 2).fold(-1, 1).linlin(-1, 1, -3, 9).round;
~sig.plot;

(
Pdef(\s1, Pspawner({|sp|


    inf.do({|i|

        var degree = ~sig.wrapAt(i);

        if (i.mod(3) == 0 or: {i.mod(4) == 0}) {

            sp.par(
                'a/out'.out
                <> Pbind(
                    \instrument, \s1,
                    \degree, degree,
                    \legato, 0.1,
                    \rel, 0.1
                ).finDur(0.5) <> Pdef(\base)
            );

        };

        if (i.mod(5) == 0) {

            sp.par(
                'b/out'.out
                <> Pbind(
                    \instrument, \s1,
                    \degree, degree,
                    \legato, 0.1,
                    \rel, 0.1,
                    \octave, 6
                ).finDur(0.5) <> Pdef(\base)
            );
        };

        sp.wait(0.25);
    });

}))
)

Pdef(\s1).play;
Pdef(\s1).stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

Ndef('a/out').play;
Ndef('b/out').play;

(
Ndef('a/out').filter(100, {|in|
    var sig = FbC({|fb|
        fb.reverse * 0.3 + in
    }, 1, [3/8, 5/8]);
    sig;
}).set(\wet100, 0.4);
)

(
Ndef('b/out').filter(100, {|in|
    var sig = JPverb.ar(in, 5, 0, 5);
    sig;
}).set(\wet100, 0.5);
)

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

(
Pdef(\s1_play,

    Ptpar([

        0, Pseq([
            Pdef(\s1).finDur(16),
            Pbind(
                \mtranspose, 1,
            ).finDur(16) <> Pstretch(0.5, Pdef(\s1))
        ], 2),

        8, Pseq([
            Pbind(
                \octave, Pkey(\octave) - 1,
                \mtranspose, -2,
                \fb, 0.5
            ).finDur(16) <> Pdef(\s1),

            Pbind(
                \mtranspose, -3,
                \octave, Pkey(\octave) - 1,
                \mratio, 2,
                \fb, 0.5
            ).finDur(16) <> Pstretch(2, Pdef(\s1))
        ], 2),

        12, Pbind(
            \atk, 1,
            \rel, 8,
            \degree, Pkey(\degree).clump(2),
            \octave, 5,
            \harmonic, [1, 1.5],
            \mratio, 0.5,
            \m, 0.2,
            \vel, 0.5,
            \fb, 0.1
        ).finDur(96) <> Pstretch(4, Pdef(\s1))
    ])
)
)

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
App.recdir
S.transport(t);

Pdef(\s1_play).play(argClock: TempoClock.default, quant:[4.0]);
Pdef(\s1_play).stop;
