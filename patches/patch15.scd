/*
SC_210425_141516.WAV
SC_210425_183322.WAV
*/

W.setParentEvent( (root: 4, scale:Scale.ritusen) );

(
S.uetr.synth({|freq|

    var sig = {
        //var sig = SinOsc.ar(freq);
        var sig = SinOscFB.ar(freq, 0.3);
        //sig = sig.blend(Satan.ar(sig, \satandecay.kr(30).linlin(0, 1, 2, 30)), \dist.kr(0.13));
        sig;
    }.();

    var fenv = Env.perc(\fatk.kr(0.01), \frel.kr(0.99).linlin(0, 1, 0.1, 2)).ar();//.linlin(0, 1, 220, 1220);
    var filt = LPG.ar(
        input: sig,
        controlinput: fenv,
        controloffset: \controloffset.kr(1),
        controlscale: \controlscale.kr(0.5),
        vca: \vca.kr(1),
        resonance: \res.kr(1.25).linlin(0, 1, 0, 1.8),
        lowpassmode: 1,
        linearity: 1
    );
    sig = filt;
    sig;
})
)

(
S.uetr.fx(200, {|in|
    var sig = in;
    sig = sig.blend(FbC({|fb|
        PitchShift.ar(fb.reverse, 2, 2, 0.01, 0.01) * 0.3 + sig
    }, 2, [3/4, 4/4]), 0.5);
    sig;
});
)

S.uetr.fx(202, 'vst/Raum', 0.3);
S.uetr.vstctrls[202].editor;


Twister.knobs(0).cc([0, 1].asSpec);
Twister.knobs(1).cc([0, 1].asSpec);
Twister.knobs(2).cc([0, 1].asSpec);
Twister.knobs(3).cc([0, 1].asSpec);
Twister.knobs(4).cc([0, 1].asSpec);
Twister.knobs(5).cc([0, 1].asSpec);

Twister.view;


~sig1 = { [0, 1].choose }.dup(15);
~sig2 = { [0, 1].choose }.dup(13);

~sig1 = [1, 1, 0, 0, 1].scramble;
~sig2 = [1, 0, 1, 1]


(
S.uetr << [

    controloffset: 0.6, //Twister.knobs(0).asMap,
    controlscale: 0.71, //Twister.knobs(1).asMap,
    vca: 0.92, //Twister.knobs(2).asMap,
    res: 0.62, //Twister.knobs(3).asMap,
    fatk: 0.37, //Twister.knobs(4).asMap,
    frel: 0.54, //Twister.knobs(5).asMap,
    //dist: 0.03, //Twister.knobs(5).asMap,
    //satandecay: 0.42, //Twister.knobs(4).asMap,

    degree: [0, 1, 0].pseq,
    mtranspose: [0, 0, 0, 1, 0, 2, -1].pseq,
    octave: Pmap(3, 8, 4, 5),
    //dist: Pkey(\octave).linlin(4, 5, 0.1, 0.03),

    harmonic: [1, 1.5],
    vel: [1, 0.6],
    sig1: {
        inf.do({|i|
            ~sig1.wrapAt(i).yield;
        })
    }.r,
    sig2: {
        inf.do({|i|
            ~sig2.wrapAt(i).yield;
        })
    }.r,
    foo: {|evt|
        if (evt[\sig1] == evt[\sig2]) {
            1
        }{
            Rest(1)
        }
    }.pfunc,
    rel: Pkey(\octave).linlin(4, 5, 1.5, 1), // Pwhite(1.2, 1.8) * 0.8,
    legato: Pkey(\octave).linlin(4, 5, 0.7, 0.5),
    atk: Pkey(\octave).linlin(4, 5, 0.1, 0.05),
    wet202: 0.4,
    amp: 0.4,
    strum: Pwhite(0, 0.08),
].p
.stretch(0.5);
)

S.uetr.node.play;
S.uetr.play;
S.uetr.stop;

(
[
    0 -> {
        S.uetr.play;
    },

    128 -> {
        S.uetr.stop;
    }
].playTimeline(clock:TempoClock.default)
)