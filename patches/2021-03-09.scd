(
SynthDef(\s1, {

    var freq = \freq.kr(261);
    var width = \width.kr(0.5);
    var gate = \gate.kr(1);
    var sig = VarSaw.ar(freq, width:width);
    var aeg = Env.adsr(\atk.kr(0.01), releaseTime:\rel.kr(1)).ar(doneAction:Done.freeSelf, gate:gate);
    sig = LeakDC.ar(sig);
    sig = sig * AmpComp.kr(freq) * aeg * \amp.kr(-6.dbamp);
    sig = Splay.ar(sig, \spread.kr(1), center:\pan.kr(0));
    Out.ar(\out.kr(0), sig);

}).add;
)

Pdef(\base, Pbind(\root, 2, \amp, -6.dbamp, \scale, Scale.ritusen))

(
Pdef(\s1,

    's1/out'.out

    <> Pbind(\width, Pwhite(0.1, 0.9))

    <> Pwrand(
        [
            Pbind(\mtranspose, 0).fin(2),
            Pbind(\mtranspose, 2).fin(2)
        ],
        [2, 1].normalizeSum,
        inf
    )

    <> Pseq([

        Pbind(
            \octave, Pmap(3, 8, 4, 5, repeats:1),
        ).repeat(2),

        Pbind(
            \octave, Pmap(5, 8, 4, 5, repeats:1),
        ).repeat(2)

    ], 4)
    <> Pbind(\instrument, \s1, \degree, [0, -1, -2, 1].pseq, \dur, 0.25)
    <> Pdef(\base)
);

(
Pdef(\s1_a,

    Pseq([
        Pdef(\s1),
        Pbind(\atk, 0.01, \rel, 4, \degree, 0, \harmonic, [1, 1.5]) <> Pdef(\s1)
    ], inf)
))
)

Pdef(\s1).play;
Pdef(\s1).stop;

Pdef(\s1_a).play;
Pdef(\s1_a).stop;

Ndef('s1/out').stop;

Ndef(\out).play;
Ndef(\out)[0] = \mix -> { Ndef('s1/out').ar; };
Ndef(\out).stop;

Ndef(\out2).play;
Ndef(\out2)[0] = \mix -> { Ndef('s1/out').ar; };
Ndef(\out2).stop;

(
Ndef(\out).filter(100, {|in|
    var sig = in;
    var sig1 = in;
    var sig2 = in;

    sig1 = FreqShift.ar(sig1, SinOsc.ar(1/3).range(10, 30) );
    sig2 = {
        var sig = PitchShift.ar(sig2, 0.1, SinOsc.ar(5).range(1, 4), 0.01, 0.01);
        sig = DelayC.ar(sig, 1, 1) * 0.5 + sig;
        sig
    }.();
    sig = SelectXFocus.ar(SinOsc.ar(20).range(0, 1), [sig1, sig2], LFNoise0.kr(1).range(0, 1));
    sig = JPverb.ar(sig, 5, 0, 5) * 0.3 + sig;
    sig;
})
.set(\wet100, 0.4);
)

(
Ndef(\master, {
    var sig = SelectX.ar(LFNoise0.kr(1/3).range(0, 1), [Ndef(\out).ar, Ndef(\out2).ar]);
    sig;
})
)

Ndef(\master).play;
Ndef(\master).stop;



M.mar9.addSrc(Ndef(\master));
M.mar9.view;
