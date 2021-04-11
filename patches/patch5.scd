S.loadSynths;
S.printSynths;

W.transport;
W.recdir;


Event.addParentType(\note, (root:2, scale:Scale.ritusen.tuning_(\et12)));
Event.addParentType(\monoNote, (root:2, scale:Scale.ritusen.tuning_(\et12)));
Event.addParentType(\monoSet, (root:2, scale:Scale.ritusen.tuning_(\et12)));

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////


Ndef('patch5/fx').play;
Ndef('patch5/fx').fx(100, 'reverb/jpverb');
Ndef('patch5/fx').filter(200, {|in| DCompressor.ar(in)});
Ndef('patch5/fx').fx(300, 'delay/fb');
Ndef('patch5/fx').filter(350, {|in| Squiz.ar(in, [2, 1.5], SinOsc.ar(1/31).range(1, 20) )});
(
Ndef('patch5/fx').filter(400, {|in|
    var trig = \trig2.tr;
    var fenv = Env.perc(0.01, 1).ar(gate:trig).linlin(0, 1, 800, 2000);
    var sig = LPF.ar(in, 4200);//RLPF.ar(in, fenv, 0.7);
    sig;// * Env.perc(0.01, 2).ar(gate:trig);
});
)


(
Pdef(\patch5,

    Pchannel('patch5/fx')
    <> Pnodeset('patch5/fx',
        \t60, 2,
        \size, Pseg(
            [1, 1.5, 1].pseq,
            [32, 32].pseq,
            \lin, inf),
        \wet100, 0.6,
        \wet300, 0.5,
        \wet350, 0.1,
        \trig2, 1
    )
    <> Pmono(\plaits_mono,
        \engine, 0,
        \harm, 0.5,
        \degree, 0,
        \amp, -3.dbamp,
        \octave, Pmap(3, 8, 5, 6),
        \dur, 0.25,
        \degree, Ppatlace([
            [0, 3].pseq,
            [1, 2, 4, 5].pseq
        ], inf),
        \mtranspose, [0, 0, 0, 1, 2].pseq,
    )
)
)

Pdef(\patch5).play;
Pdef(\patch5).stop;