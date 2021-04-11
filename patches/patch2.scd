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
// fx
/////////////////////////////////////////////////////////////////////
Ndef('patch2/fx').play;

Ndef('patch2/fx').fx(100, 'delay/fb');
Ndef('patch2/fx').view;

Ndef('patch2/fx').vst(200, 'Raum');
~patch2_fx_raum.editor;
~patch2_fx_raum.gui;
V.printPatternParams('Raum', ~patch2_fx_raum);

Ndef('patch2/fx').vst(300, 'ValhallaSupermassive');
~patch2_fx_valhallasupermassive.editor;

(
Ndef('patch2/fx').filter(400, {|in|
    PitchShift.ar(in, 2, 2, 0.01, 0.01);
})
)

Ndef('patch2/fx')[400]

/////////////////////////////////////////////////////////////////////
// base sequence
/////////////////////////////////////////////////////////////////////
(
Pdef(\patch2,

    Pchannel('patch2/fx')
    <> Pbind(
        \instrument, \modal,
        \degree, [0, -1, 2, -2].pseq,
        \mtranspose, [0, 0, 0, 2, 4].pseq,
        \octave, Pmap(3, 8, 5, 6) - 1,
        \amp, -6.dbamp,
        \dur, 0.25,
        \wet100, 0.6,
        \wet200, 0.5,
        \wet300, 0.4,
        \wet400, 0.6
    )
)
)

Pdef(\patch2).play;
Pdef(\patch2).stop;

/////////////////////////////////////////////////////////////////////
// variations
/////////////////////////////////////////////////////////////////////
(
Pdef('patch2/play',
    Pdef(\patch2)
    <> Pbind(\raum_mode, 0.5)
)
)

(
Pdef('patch2/play',
    Pbind(
        \harmonic, [1, 1.5],
        \vel, 0.5,
        \dur, 0.5
    )
    <> Pdef(\patch2)
    //<> Pbind(\raum_mode, 1, \raum_reverb, 1, \raum_feedback, 1)
)
)


(
Pdef('patch2/play',
    Pbind(
        \harmonic, [1, 1.5],
        \vel, 0.15,
        \dur, 0.5,
        \octave, Pkey(\octave) - 1
    )
    <> Pdef(\patch2)
    //<> Pbind(\raum_mode, 1, \raum_reverb, 1, \raum_feedback, 1)
)
)

(
Pdef('patch2/play',

    Ppar([

        Pbind(
            \harmonic, [1, 2],
            \vel, 0.3,
            \dur, 1,
            \harm, 0.5
        )
        <> Pdef(\patch2),

        Pbind(
            \harmonic, [1, 0.5],
            \vel, 0.5,
            \legato, 0.5,
            \dur, 1.5,
            \harm, 0.1
        )
        <> Pdef(\patch2)

    ])
)
)

(
Pdef('patch2/play',
    Pbind(
        \harmonic, 1,
        \legato, 0.5,
        \dur, 2
    )
    <> Pdef(\patch2)
    //<> Pbind(\raum_mode, 1, \raum_reverb, 1, \raum_feedback, 1)
)
)

Pdef('patch2/play').play;
Pdef('patch2/play').stop;

