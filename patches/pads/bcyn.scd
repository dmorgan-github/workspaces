W.transport;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~bcyn = S();
~bcyn.synth(\fm7_algo30);
~bcyn.fx(10, {|in|

    var sig = in;
    var del, ps, raum;

    del = {|in|
        FbC({|fb|
            PitchShift.ar(fb.reverse, 0.3, [2, 1.5], 0.01, 0.01) * \delfb.kr(0.5) + in;
        }, 1, [3/9, 4/8] + SinOsc.ar(1/25).range(0.01, 0.06));
    };

    ps = {|in|
        PitchShift.ar(in, 2, 2, 0.01, 0.01);
    };

    sig = sig.blend(del.(sig), 0.6);
    sig = sig.blend(ps.(sig), 0.6);

    sig = DCompressor.ar(sig);

    sig = Limiter.ar(sig, -6.dbamp);

    sig;

});

~bcyn.set(
    \op1ratio, 1,
    \op2ratio, 1,

    \op3ratio, 4,
    \op3suslevel, 1, //Pseg([0, 0.2, 0].pseq, [32, 32, 32].pseq, \lin, inf),
    \op3dec, 0.2,
    \op3rel, 2,

    \op4ratio, 1,
    \op5ratio, 1,

    \op6ratio, 8,
    \op6peak, 0.2,

    \fb, 0.5,
    \amp, -8.dbamp * [1, 0.5],

    \harmonic, [1, 1.5],
    //\vel, [1, 0.5],

    \atk, 2,
    \rel, 8
);

~bcyn << [\degree, [0, -1, 2, 4].pseq, \octave, Pmap(2, 5, 4, 5) - 1, \dur, 4].p;
~bcyn.play;
~bcyn.stop;

