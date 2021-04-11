S.loadSynths;
S.transport;
Q.start;
Q.view;
App.recdir;
S.printSynths;


Ndef(\pedal1).play;
(
Ndef(\pedal1).filter(100, {|in|

    var sig;
    var delay, rev, squiz, ps, sig2;

    // delay
    delay = {|in|
        var delL = \delL.kr(3).lag(0.1) * 4.reciprocal;
        var delR = \delR.kr(4).lag(0.1) * 4.reciprocal;
        FbC({|fb|
            fb.reverse * \fb.kr(0.3) + in
        }, 1, [delL, delR])
    };

    //squiz
    squiz = {|in|
        Squiz.ar(in,
            pitchratio: 2,
            zcperchunk: \zcp.kr(10).lag(0.1)
        );
    };

    // reverb
    rev = {|in|
        JPverb.ar(in,
            t60: \t60.kr(1),
            size: \size.kr(1)
        )
    };

    // pitchshift
    ps = {|in|
        var psL = \psL.kr(1.5);
        var psR = \psR.kr(2);
        PitchShift.ar(in, 2, [psL, psR], 0.01, 0.01)
    };

    // route
    sig = in.blend(delay.(in), \delay.kr(0.4));
    sig = sig.blend(squiz.(sig),\squiz.kr(0.4));

    sig2 = in.blend(rev.(in), \rev.kr(0.4));
    sig2 = sig2.blend(ps.(sig2), \ps.kr(0.3));

    Splay.ar([sig, sig2].sum - in);

});
)

(
Pdef(\pedaltest,

    Pchannel(\pedal1)
    <> Pmono(\plaits_mono,
        \trig, 1,
        \root, 2,
        \scale, Scale.ritusen
    )
    <> Pdef(\pset,
        Pbind(
            \engine, 11,
            \amp, -3.dbamp
        )
    )
)
)

Pdef(\pedaltest).play;
Pdef(\pedaltest).stop;

(
Pbindef(\pset,

    \degree, Ppatlace([
        [0, -1].pseq,
        [2, 4, 6].pseq
    ], inf),
    \octave, 4,
    \dur, 0.5,
    \harm, 1,
    \morph, 0.5,
    \mtranspose, [0, 1, 2, -2].pseq.stutter(4),

    // control fx
    \fb, 0.6,
    \t60, 3,
    \size, 3,
    \rev, 0.1,
    \squiz, 0.3,
    \ps, 0.4,
    \zcp, Pseries(5, 0.5).fold(5, 30),
    \delay, 0.4,
    \delL, [1, 2, 3].pseq.stutter(2 * 2),
    \delR, [3, 2, 1].pseq.stutter(3 * 2),
    \wet100, 0.75,
    \psL, 4,
    \psR, 2
);
)

