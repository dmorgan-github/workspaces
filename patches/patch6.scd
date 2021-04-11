S.loadSynths;
S.printSynths;

W.transport;
W.recdir;

Q.start;
Q.view;


Event.addParentType(\note, (root:2, scale:Scale.ritusen.tuning_(\et12)));
Event.addParentType(\monoNote, (root:2, scale:Scale.ritusen.tuning_(\et12)));
Event.addParentType(\monoSet, (root:2, scale:Scale.ritusen.tuning_(\et12)));

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
(
S.def(\p6, {|freq|

    var sig = SinOsc.ar(freq);
    var gain =  SinOsc.ar(1/21).range(1, 2);
    sig = SinOsc.ar(0, sig * gain) * gain.sqrt.reciprocal;
    sig = LeakDC.ar(sig);
    sig = LPF.ar(sig, 4000);
    sig = Limiter.ar(sig, 0.7);
    sig;

})
)

Ndef('patch6/fx').play;
(
Ndef('patch6/fx').filter(100, {|in|

    var del, del2, comp, rev, sig;
    var freq = \freq.kr;

    sig = in;

    del = {|in|
        var fblevel = SinOsc.ar(1/31).range(0.4, 0.7);
        FbC({|fb|
            FreqShift.ar(fb.reverse, [freq/2, freq/4]) * fblevel + in
        }, 1, [3/5, 4/8])
    };

    del2 = {|in|
        AllpassC.ar(in, 1, 3/4, 2);
    };

    comp = {|in|
        DCompressor.ar(in);
    };

    rev = {|in|
        JPverb.ar(in, 5, 0, 1);
    };

    sig = sig.blend(del.(sig), 0.4);
    sig = sig.blend(del2.(sig), 0.4);
    sig = sig.blend(rev.(sig), 0.3);
    sig = sig.blend(comp.(sig), 1);

    sig;

});
)


(
Pdef(\patch6,

    Pchannel('patch6/fx')
    <> Pnodeset('patch6/fx',
        \freq, Pfunc({|evt|
            evt.use({~freq.value});
        }),
        \wet100, 0.8
    )
    <> Pbind(
        \instrument, \p6,
        \degree, [0, 1, 2, 3].pseq,
        \octave, Pmap(3, 8, 5, 6) -1,
        \legato, 0.5,
        \harmonic, [1, 1.5],
        \vel, [1, 0.5],
        \rel, 2,
        \mtranspose, [0, 0, 0, 1, \].pseq,
        \detunehz, 0.8,
        //\ctranspose, [0, -5].pseq.stutter(16),
        \amp, -6.dbamp
    )
)
)

Pdef(\patch6).finDur(130).play;
Pdef(\patch6).stop;