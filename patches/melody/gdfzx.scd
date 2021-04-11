W.transport;

~sig = ( Signal.sineFill(32, {rrand(0.1, 1.0)}.dup(32)) * 1.5 ).fold(-1, 1).linlin(-1, 1, -5, 5).round;
~sig.plot;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~gdfzx = S();
~gdfzx.synth(\fm7_algo17);
~gdfzx.fx(10, {|sig_in|
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

(
var prev;
~gdfzx << [
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

    dur: 0.5,
    t60: 5,
    size: Pwhite(1.0, 1.01),
    amp: -10.dbamp,

    op2ratio: 2,
    op3ratio: 0.5,
    op3suslevel: 0,
    op3dec: 0.2,
    vel: Pwhite(0.7, 1.0),

    wet10: 0.5,
].p
)

~gdfzx.play;
~gdfzx.stop;

Twister.clear;
Twister.connect;
W.sendToTwister;
W.synths



