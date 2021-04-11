S.loadSynths;
S.printSynths;

W.transport;
W.recdir;

Q.start;
Q.view;



/////////////////////////////////////////////////////////////////////
// fx chain
/////////////////////////////////////////////////////////////////////

Ndef('patch1/pedal1').fadeTime_(2).play;
(
Ndef('patch1/pedal1').filter(100, {|in|
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
)

Ndef('patch1/pedal1').vst(150, 'MEqualizer');
~patch1_pedal1_mequalizer.editor;

Ndef('patch1/pedal1').vst(200, 'Raum');
~patch1_pedal1_raum.editor;

Ndef('patch1/pedal1').vst(300, 'ValhallaSupermassive');
~patch1_pedal1_valhallasupermassive.editor;

Ndef('patch1/pedal1').vst(400, '++bubbler');
~patch1_pedal1_bubbler.editor;


(
Pdef(\patch1,

    Pbind(
        \degree, [0, -1, 2, 4].pseq,
        //\mtranspose, [0, 2, -2, 1].pseq.stutter(8),
        \harmonic, [1, 1.5],
        \vel, [1, 0.5],
        \octave, Pmap(2, 5, 4, 5) - 1,
        \dur, 4,
        \atk, 2,
        \rel, 8,

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
        \amp, -8.dbamp
    )
    <> Pchannel('patch1/pedal1')
    <> Pbind(\scale, Scale.ritusen, \instrument, \fm7_algo30)
)
)

Pdef(\patch1).play;
Pdef(\patch1).stop;


