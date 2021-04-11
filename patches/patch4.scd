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

Ndef('patch4/fx').play;
Ndef('patch4/fx').fx(50, 'reverb/jpverb');
(
Ndef('patch4/fx').filter(75, {|in|
    DCompressor.ar(in, ratio:4, release: 1)
});
)
Ndef('patch4/fx').fx(100, 'delay/fb');

Ndef('patch4/fx/2').play;
Ndef('patch4/fx/2').mix(0, Ndef('patch4/fx'));
(
Ndef('patch4/fx/2').filter(100, {|in|
    var ps = \ps.kr(2);
    var sig1 = PitchShift.ar(in, 2, ps, 0.01, 0.01);
    var sig2 = Squiz.ar(in, ps, SinOsc.ar(1/21).range(1, 30));
    var sig = SelectX.ar(TChoose.kr(Dust.kr(0.5), [0, 1]), [sig1, sig2]);
    sig = Limiter.ar(sig, 0.7);
    sig;
})
);
Ndef('patch4/fx/2').fx(200, 'granular/grainin');


/////////////////////////////////////////////////////////////////////
// sequence
/////////////////////////////////////////////////////////////////////
(
Pdef(\patch4,

    Pchannel('patch4/fx')
    <> Pnodeset('patch4/fx/2',
        \ps, [1.5, 2].pseq.stutter(4),
        \wet100, 0.3,
        \wet200, 0.8
    )
    <> Pnodeset('patch4/fx',
        \wet100, 0.6,
        \wet50, 0.3,
        \t60, 3,
        \size, Pwhite(1.0, 3.0),
        \fbL, 0.7,
        \fbR, 0.6,
        \delL, 2.5,
        \delR, 4
    )
    <> [
        instrument: \abstract_drum,
        decCoef: Pwhite(0.1, 1.0),
        position: Pwhite(0.1, 1.0),
        amp: 5.dbamp,
        dur: [1.5, 1, 1.5].pseq * 0.5,
        hiFreqSus: 0.4,
        octave: Pmap(3, 8, 5, 6),
        harmonic: [1, 1.5]
    ].p
)
)

Pdef(\patch4).play;
Pdef(\patch4).stop;

