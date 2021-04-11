S.loadSynths;
S.printSynths;

W.transport;
W.recdir;

Q.start;
Q.view;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

Ndef('patch7/fx').play;

(
Ndef('patch7/fx').filter(100, {|in|

    var sig;
    var dec, filt, rev;

    sig = in;

    filt = {|in|
        RLPF.ar(in, \cutoff.kr(2000, spec:[200, 4000, \lin, 0, 2000]), 0.5);
    };

    rev = {|in|
        var sig = FbC({|fb|
            AllpassC.ar(PitchShift.ar(fb.reverse, 2, 2), 0.2, 0.2, 1) * 0.5 + in;
        });
        JPverb.ar(sig, 5, 0, 5, modDepth: 0.5);
    };

    sig = sig.blend(filt.(sig), 1);
    sig = sig.blend(rev.(sig), 0.6);

    sig;

});
)
Ndef('patch7/fx').vst(50, '++decimate');
~patch7_fx_decimate.editor;
~patch7_fx_decimate.gui;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

(
S.def(\p7, {|freq|

    var sig = SinOsc.ar(freq);
    sig;
});
)

(
Pdef(\patch7,

    Pchannel('patch7/fx')

    <> Pnodeset('patch7/fx',
        'decimate_color', 0,
        'decimate_depth', 0.65512388944626,
        'decimate_folding', 0.24373896002769,
        'decimate_ingain', 0.5,
        'decimate_outgain', 0.5,
        'wet50', 0.5
    )
    <> Pbind(
        \instrument, \p7,
        \degree, Pwhite(0, 5),
        \octave, 4,
        \harmonic, [1, 1.5],
        \dur, 4,
        \atk, 2,
        \rel, 8,
        \vel, 0.8
    )
)
)

Pdef(\patch7).play;
Pdef(\patch7).stop;

~b = PbindProxy();
~b.quant_(1)

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~s1 = S();
(
~s1.synth({|freq|
    var sig = SinOsc.ar(0, SinOscFB.ar(freq, [0.1, 0.3] * SinOsc.ar(1/13).range(1, 2)) * \ws.kr(1));
    sig = sig * \ws.kr.sqrt.reciprocal;
    sig;
});
)
~s1.fx(100, 'delay/fb', 0.4);
~s1.fx(150, {|in| AnalogTape.ar(in, 0.5, 0.3, 0.7) });
~s1.seq(\dur, 0.25);
~s1.seq(\harmonic, [1, 1.5], \octave, Ptuple([Pmap(3, 7, 5, 6, repeats:4), Pmap(5, 8, 4, 5, repeats:5)], 1));
~s1.seq(\mtranspose, [0, 1, 0, 0, 2].pyramid.pseq, \scale, Scale.ritusen);
~s1.seq(\legato, 0.6, \rel, {SinOsc.ar(1/35, -1).linlin(-1, 1, 0.1, 2)}, \vel, [1, 0.7]);
~s1.seq(\ws, { SinOsc.ar(1/13, -1).range(1.0, 2.0) });
~s1.seq(\delL, 1.5, \amp, -3.dbamp);
~s1.seq(\delR, { LFNoise1.ar(1/3).range(1.5, 3.5) });
~s1.seq(\fbL, 0.4, \fbR, 0.5);
~s1.seq(\wet150, 0.7, \wet100, 0.4);
~s1.play(quant:4.0);
~s1.stop;

(
Pdef(\s1play,
    Pseq([
        Psync(Pbind(\amp, -4.dbamp) <> ~s1, 16, 16)
    ], inf)
)
)

Pdef(\s1play).play;
Pdef(\s1play).stop;




