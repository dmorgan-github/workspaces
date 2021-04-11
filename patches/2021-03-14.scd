S.loadSynths;
S.transport;
Q.start;
App.recdir;
Q.view;


//Users/david/Documents/supercollider/media/Jogging House - Reel Feels (Sound Pack)/Jogging House - Reel Feels (Sound Pack) - 11 Synth 6.wav)
~buf = ~jogging.values.choose;
O.foyz.set(\buf, ~buf);
O.foyz.set(\rate, 1);
O.foyz.view;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
(
Tdef(\set, {

    inf.do({|i|
        O.foyz.set(\rate, 1);
        8.wait;
        O.foyz.set(\rate, 0.8);
        8.wait;
    });
})
)

Tdef(\set).play;
Tdef(\set).stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
M.fzbm.addSrc(O.foyz);
M.fzbm.view;

/////////////////////////////////////////////////////////////////////
// loopr
/////////////////////////////////////////////////////////////////////

~buf2 = B.readMono("/Users/david/Documents/supercollider/workspaces/2021-02/thisone/recordings/signals-14.wav");

Ndef(\loopr2).play;
Ndef(\loopr2).set(\buf, ~buf2);
Ndef(\loopr2).set(\rate, 1);
Ndef(\loopr2)[0] = \loopr2;
U(\buf, Ndef(\loopr2));


/////////////////////////////////////////////////////////////////////
// fx matrix
/////////////////////////////////////////////////////////////////////
M.amts.addSrc(Ndef(\loopr2));
M.amts.view;



b = Buffer.alloc(s, 4 * s.sampleRate, 1);

Ndef(\tgrains).play;
Ndef(\tgrains).set(\buf, b);
(
Ndef(\tgrains).filter(100, {|in|

    var sig;
    var buf = \buf.kr(0);
    var phase = Phasor.ar(0, 1, 0, BufFrames.kr(buf));
    var density = Dust.ar(LFNoise2.ar(1/11).range(1, 10));
    var rate = \rate.kr(1);
    var graindur = LFNoise2.ar(1/9).range(0.05, 1);// \graindur.kr(0.05);
    var grainpan = LFNoise2.ar(1/7).range(-1.0, 1.0);// \grainpan.kr(0);
    var grainamp = \grainamp.kr(1);

    var which = LFNoise1.kr(1/3).range(0, 3).round;
    var rate2 = Select.kr(which, [1, 1.5, 2, 4]) * TChoose.kr(Dust.ar(0.1), [1, -1]);
    var fb = DelayC.ar(LocalIn.ar(2), 1, 1) * 0.1;

    BufWr.ar(AllpassC.ar(in.asArray.sum + LPF.ar(fb.sum, 10000), 1, 1, 4), buf, phase);

    sig = TGrains.ar(numChannels:2,
        trigger: density,
        bufnum: buf,
        rate: rate2,
        centerPos: (phase/SampleRate.ir) - LFNoise2.ar(1/3).range(0.05, 1),
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

Ndef(\loopr2).play;
Ndef(\loopr2).stop;

Ndef(\tgrains)[0] = \mix -> {Ndef(\loopr2).ar};
Ndef(\tgrains).set(\wet100, 0.7);


Ndef(\tgrains).play;
Ndef(\tgrains).stop;



