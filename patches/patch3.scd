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
Ndef('patch3/fx').play;

(
Ndef('patch3/fx').filter(100, {arg sig_in;

    var in = sig_in * \input.ar(1);
    var fblevel = [\fbL.ar(0.3), \fbR.kr(0.5)];
    var delL = \delL.ar(3).lag(0.1) * 4.reciprocal;
    var delR = \delR.ar(4).lag(0.1) * 4.reciprocal;
    var tempo = \speed.ar(1).lag(0.1);
    var offsetL = \offsetL.ar(0).lag(0.1);
    var offsetR = \offsetR.ar(0).lag(0.1);

    var sig = HPF.ar(in, \hpf.kr(20));
    sig = FbC({arg fb;
        FreqShift.ar(fb.reverse, 100) * fblevel + sig
    }, 16, [delL, delR] * tempo + [offsetL, offsetR]);

    sig = Splay.ar(sig, \spread.ar(1), 1, center:\pan.ar(0));
    sig * \output.kr(1);
});
)


~obj = N.loadFx('delay/fb');
~obj[\synth].asCompileString

Ndef('patch3/fx').fx(200, 'reverb/jpverb');

(
Ndef('patch3/fx').filter(300, {|in|
    RLPF.ar(in, SinOsc.ar(10).range(1, 2) * 2000, SinOsc.ar(1/13).range(0.4, 0.8));
});
)
Ndef('patch3/fx').fx(400, 'reverb/jpverb');

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~sig = ( Signal.sineFill(32, {rrand(0.1, 1.0)}.dup(32)) * 1.5 ).fold(-1, 1).linlin(-1, 1, -5, 5).round;
~sig.plot;

(
var prev;
Pdef(\patch3,

    Pchannel('patch3/fx')
    <> [
        instrument: \fm7_algo17,
        foo: ~sig.pseq,
        degree: Pfunc({|evt|
            if (evt[\foo] != prev) {
                prev = evt[\foo];
                prev
            }{
                Rest(1)
            }
        }),
        harmonic: [1, 7.midiratio],
        strum: Pwhite(0.0, 0.1),
        octave: Pmap(5, 8, 4, 5),
        fb: 0.2,
        rel: 2,
        scale: Scale.ritusen,
        dur: 0.5,
        t60: 5,
        size: Pwhite(1.0, 1.01),
        amp: -25.dbamp,

        op2ratio: 2,
        op3ratio: 0.5,
        op3suslevel: 0,
        op3dec: 0.2,
        vel: Pwhite(0.7, 1.0),

        wet100: 0.5,
        wet200: 0.1,
        wet300: 0.1,
        wet400: 0.1,

    ].p
)
)

Pdef(\patch3).play;
Pdef(\patch3).stop;