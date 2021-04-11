S.loadSynths;
S.transport;
Q.start;
Q.view;
App.recdir;


Pdef(\base, Pbind(\root, 2, \scale, Scale.ritusen));

(
Pdef(\p1,

    //'p1/out'.out
    //<>
    Pbind(
        \instrument, \modal,
        \foo, [0, 1, 2].pseq,
        \bar, [-1, 0, 1, 2, 3].pyramid(2).scramble.pseq,
        \baz, Pclutch([0, 1, 2].pseq, Pfunc({|evt| evt[\foo] != evt[\bar]})),
        \degree, Pfunc({|evt|
            if (evt[\foo] != evt[\bar]) {evt[\baz]}{Rest(1)}
        }),
        \dur, 0.25,
        \legato, 0.8,
        \rel, Pseries(0.5, 0.01).fold(0.5, 1),
        \harmonic, [1, 1.5],
        \octave, Pmap(3, 8, 4, 5),
        \vel, 1
    ) <> Pdef(\base)
);

Pdef(\p2,
    //'p2/out'.out
    //<>
    Pbind(
        \harm, 1,
        \dur, 0.25,
        \octave, Pkey(\octave) + 1
    )
    <> Pdef(\p1)
);

Pdef(\p3,
    Pbind(
        \harm, 1,
        \dur, 1,
        \octave, 3,
        \legato, 0.2,
        \amp, -10.dbamp
    )
    <> Pdef(\p1)
)
)

Pdef(\p1).play;
Pdef(\p2).play;
Pdef(\p3).play;

Pdef(\p1).stop;
Pdef(\p2).stop;
Pdef(\p3).stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
S.loadSynths;
Pdef(\base, Pbind(\root, 2, \scale, Scale.ritusen));
(
Ndef('p1/out').play;
Pdef(\m,
    Pmatrix(\ieqis2, 'p1/out',
        [
            [0, 1, 0, 0],
            [0, 0, 1, 1],
            [0, 0, 0, 0.7],
            [0, 0, 0, 0]
        ],
        [
            Pfilter(\abc, 'delay/fb', 0),
            Pfilter(\def, 'delay/fb', 0),
            Pfilter(\ghi, 'distortion/squiz', 1,
                \zcperchunk, [1, 5, 20].pseq
            )
        ]
    )
    <> Pchannel('p1/out', 0)
    <> Pdef(\mdef,
        Pbind(
            \instrument, \modal,
            \harmonic, 1,
        )
    ) <> Pdef(\base)
)
)

Pbindef(\mdef, \harmonic, 1, \dur, 1, \delR, [1, 2, 3].pseq, \delL, [1, 2, 3].pseq.stutter(2));
Pbindef(\mdef, \harmonic, 1, \dur, 0.5, \octave, Pmap(3, 8, 4, 5));

Pdef(\m).play;
Pdef(\m).stop;
M(\ieqis2).view;

Ndef('p1/out').stop;
Ndef(\def).gui


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
S.loadSynths;
Pdef(\base, Pbind(\root, 2, \scale, Scale.ritusen));
(
Pdef(\m2,

    Pmatrix(\pauw, 'p2/out',
        [
            [0, 1, 0, 0,   0],
            [0, 0, 0.5, 0, 0],
            [0, 0, 0, 1,   0],
            [0, 0.4, 0, 0, 0],
            [0, 0.4, 0, 0, 0],
        ],
        [
            //Psrc('p2/out', 0),

            Pfilter(\pvo, 'delay/fb', 1),

            Pfilter(\utn, {|in|
                var sig = FreqShift.ar(in, \fs.kr(3));
                sig = Limiter.ar(sig);
                sig;
            }, 1),

            Pfilter(\epm, 'granular/grainin', 1),

            Pfilter(\repyf, {|in|
                DCompressor.ar(in);
            }, 1)
        ], 0
    )
    <> Pdef(\m2def,
        Pbind(
            \instrument, \pm2op,
            \op2ratio, 0.8,
            \op1_m2, 0.3,
            \fb, 0.6,
            \degree, [0, 1, 2, 5].pseq,
            \amp, -7.dbamp,
            \legato, 0.1,
            \dur, 0.125,
            \octave, 6,
            // 'pvo/p2/out', 1
        )
    ) <> Pdef(\base)
)
)


Twister.knobs(0).cc([0.5, 8.0, \lin, 0, 1]);
Twister.knobs(1).cc([3, 100, \lin, 0, 3]);
Twister.view.front;

(
Pbindef(\m2def,
    \dur, 0.5,
    \legato, 0.1,
    \octave, Pmap(3, 8, 5, 6) -1 ,
    \op2ratio, Twister.knobs(0).asMap,
    \fs, Twister.knobs(1).asMap,
    \fb, 0.5,
    \op1_m2, 0.7,
    \menv, 1,
    \mrel, 0.05,
    \rel, Pseries(0.1, 0.01).fold(0.1, 2.0),
    \harmonic, [1, 1.5],
    \vel, [1, 0.5]
)
)

(
Pbindef(\m2def,
    \instrument, \pm2op,
    \op2ratio, Twister.knobs(0).asMap,
    \fs, Twister.knobs(1).asMap,
    \op1_m2, 0.3,
    \fb, 0.6,
    \degree, [0, 1, 2, 5].pseq,
    \amp, -7.dbamp,
    \legato, 0.1,
    \dur, 0.25,
    \octave, 6
)
)

Pdef(\m2).play;
Pdef(\m2).stop;
M(\pauw).view;
