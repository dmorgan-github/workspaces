
S.loadSynths;
S.transport;
Q.start;
Q.view;

App.recdir;

Twister.connect;
Twister.clear;

//vel
(
//(0..15).do({|i|
//    Twister.knobs(i).cc([0, 1, \lin, 0, 0]);
//});
)

// op2 ratio
(
(16..31).do({|i|
    Twister.knobs(i).cc([0.5, 8, \lin, 1]);
});
)

// fb
(
(32..47).do({|i|
    Twister.knobs(i).cc([0, 1.2, \lin, 0]);
});
)

// op1 m2
(
(48..63).do({|i|
    Twister.knobs(i).cc([0, 2, \lin, 0]);
});
)

Pdefn(\ctranspose, 0);
Pdefn(\octave, 2);


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
(
var lowdrones;

(0..7).do({|i|
    Twister.knobs(i).cc([0, 1, \lin, 0, 0]);
});

lowdrones = 8.collect({|i|
    'pmono/out'.out
    <> Pbind(
        \instrument, \pm2op,
        \ctranspose, Pdefn(\ctranspose, 0),
        \scale, Scale.ritusen,
        \root, 2,
        \octave, Pdefn(\octave),
        \degree, 0,
        \harmonic, i+1,
        \dur, 1,
        \stretch, i+1,
        \vel, Twister.knobs(i).asMap,
        \op2ratio, 1, //Twister.knobs(i+16).asMap,
        \fb, 0.5, // Twister.knobs(i+32).asMap,
        \op1_m2, 0.5, //Twister.knobs(i+48).asMap,
        \lag, 0,
        \atk, Pkey(\dur) * Pkey(\stretch) * 0.1,
        \rel, Pkey(\dur) * Pkey(\stretch) * 2,
        \legato, 0.8
    )
});
Pdef(\ppar, Ppar(lowdrones));
)

Ndef('pmono/out').play;
Pdef(\ppar).play;
Pdef(\ppar).stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

Twister.knobs(8).cc([0, 1, \lin, 0, 0]);
(
Pdef(\vhq,

    'vhq/out'.out
    <> Pbind(
        \instrument, \pm2op,
        \ctranspose, Pdefn(\ctranspose, 0),
        \scale, Scale.ritusen,
        \degree, 0,
        \harmonic, 9,
        \octave, Pmap(5, 8, 0, 1) + Pdefn(\octave),
        \stretch, 0.125,
        \root, 2,
        \legato, 0.1,
        \fb, 0.4,
        \op1_m2, 0.3,
        \op2ratio, 2,
        \rel, 1,
        \vel, Twister.knobs(8).asMap,
        \mtranspose, Prand([0, 1, 2], inf).stutter(8)
    )
)
)

Pdef(\vhq).play;
Pdef(\vhq).stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

Twister.knobs(9).cc([0, 1, \lin, 0, 0]);
(
Pdef(\vuhl,
    Pbind(
        \instrument, \pm2op,
        \ctranspose, Pdefn(\ctranspose, 0),
        \scale, Scale.ritusen,
        \degree, 0,
        \harmonic, 10,
        \octave, Pmap(3, 8, 0, 1, 1) + Pdefn(\octave),
        \stretch, 0.125,
        \root, 2,
        \legato, 0.1,
        \fb, 0.4,
        \op1_m2, 0.3,
        \op2ratio, 0.5,
        \rel, 1,
        \vel, Twister.knobs(9).asMap
    )
)
)

Pdef(\vuhl).play;
Pdef(\vuhl).stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

Twister.knobs(10).cc([0, 1, \lin, 0, 0]);
(
Pdef(\oeaz,
    Pbind(
        \instrument, \pm2op,
        \ctranspose, Pdefn(\ctranspose, 0),
        \scale, Scale.ritusen,
        \degree, 0,
        \harmonic, 11,
        \octave, Pmap(3, 8, 0, 1, 1) + Pdefn(\octave),
        \stretch, 0.25,
        \root, 2,
        \legato, 0.5,
        \fb, 1,
        \op1_m2, 0.3,
        \op2ratio, 2,
        \rel, 1,
        \vel, Twister.knobs(10).asMap
    )
)
)

Pdef(\oeaz).play;
Pdef(\oeaz).stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

Twister.knobs(11).cc([0, 1, \lin, 0, 0]);
(
Pdef(\zlx,
    Pbind(
        \instrument, \pm2op,
        \ctranspose, Pdefn(\ctranspose, 0),
        \scale, Scale.ritusen,
        \degree, 0,
        \harmonic, 12,
        \octave, Pmap(5, 9, 0, 1, 2) + Pdefn(\octave),
        \stretch, 0.5,
        \root, 2,
        \legato, 0.5,
        \fb, 1,
        \op1_m2, 0.3,
        \op2ratio, 2,
        \rel, 1,
        \vel, Twister.knobs(11).asMap
    )
)
)

Pdef(\zlx).play;
Pdef(\zlx).stop;

Pdefn(\ctranspose, 0);
Pdefn(\octave, 2);

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~sig = (Signal.sineFill(32, { rrand(0.1, 1.0)}.dup(8)) * rrand(1.3, 2.5)).fold(-1, 1).linlin(-1, 1, -3, 9).round;

(
Ppub(\s1,
    Pbind(
        \topic, \s1,
        \degree, ~sig.pseq,
        \dur, 0.25
    )
)
)

Ppub(\s1).play;


Psub(\p1).play
Psub(\p2).play;
Psub(\p3).play;

(
Psub(\p1, \s1,
    'p1/out'.out
    <> Pbind(
        \instrument, \pm2op,
        \foo, Pkey(\degree)
    ).fin(1),
    {
        ~count_.mod(3) == 0
    }
);

Psub(\p2, \s1,
    'p2/out'.out
    <> Pbind(
        \instrument, \pm2op,
        \foo, Pkey(\degree),
        \octave, 6
    ).fin(1),
    {
        ~count_.mod(4) == 0
    }
);

Psub(\p3, \s1,
    'p3/out'.out
    <> Pbind(
        \instrument, \pm2op,
        \foo, Pkey(\degree),
        \octave, 4
    ).fin(1),
    {
        ~count_.mod(5) == 0
    }
)
)

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

b = Buffer.alloc(s, 4 * s.sampleRate, 1);
b.zero;

Ndef(\tgrains).clear;
Ndef(\tgrains).play;
Ndef(\tgrains).set(\buf, b);
(
Ndef(\tgrains).filter(100, {|in|

    var sig;
    var buf = \buf.kr(0);
    var phase = Phasor.ar(0, 1, 0, BufFrames.kr(buf));
    var density = Impulse.ar(\density.kr(2));//Dust.ar(LFNoise2.ar(1/11).range(1, 10));
    var rate = \rate.kr(1);
    var graindur = \graindur.kr(0.1); //LFNoise2.ar(1/9).range(0.05, 1);// \graindur.kr(0.05);
    var grainpan = LFNoise2.ar(1/7).range(-1.0, 1.0);// \grainpan.kr(0);
    var grainamp = \grainamp.kr(1);

    var which = LFNoise1.kr(\which.kr(1/3)).range(0, 3).round;
    var rate2 = Select.kr(which, [1, 1.5, 2, 4]) * TChoose.kr(Dust.ar(0.1), [1, -1]);
    var fb = DelayC.ar(LocalIn.ar(2), 1, 1) * 0.1;

    sig = AllpassC.ar(in.asArray.sum + LPF.ar(fb.sum, 10000), 1, 1, 4);

    BufWr.ar(sig, buf, phase);

    sig = TGrains.ar(numChannels:2,
        trigger: density,
        bufnum: buf,
        rate: rate2,
        centerPos: (phase/SampleRate.ir) - 1, //LFNoise2.ar(1/3).range(0.05, 1),
        dur: graindur,
        pan: grainpan,
        amp: grainamp,
        interp:4
    );

    sig = LeakDC.ar(sig);
    sig = sig.blend(AllpassC.ar(sig, 1, 1, 2), 0.5);
    sig = Limiter.ar(sig, 0.7);
    LocalOut.ar(sig);
    sig;
});
)

Ndef(\tgrains)[0] = \mix -> {Ndef('vhq/out').ar};
Ndef(\tgrains).set(\density, 5);


M.udm.addSrc(Ndef('pmono/out'));
M.udm.addSrc(Ndef('p1/out'));
M.udm.addSrc(Ndef('p2/out'));
M.udm.addSrc(Ndef('p3/out'));

M.udm.addSrc(Ndef('\tgrains'));
M.udm.view;


Ndef(\tgrains).map(\density, Twister.knobs(16).asMap);
Ndef(\tgrains).map(\graindur, Twister.knobs(1).asMap);
Ndef(\tgrains).map(\which, Twister.knobs(2).asMap);






