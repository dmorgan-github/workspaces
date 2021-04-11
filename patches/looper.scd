S.loadSynths;
S.transport;
Q.start;
App.recdir;
Q.view;

/////////////////////////////////////////////////////////////////////
// loopr
/////////////////////////////////////////////////////////////////////

~buf2 = B.readMono("/Users/david/Documents/supercollider/workspaces/2021-02/thisone/recordings/signals-14.wav");
~buf3 = B.readMono("/Users/david/Documents/supercollider/workspaces/iint/iint.wav");

Ndef(\loopr3).play;
Ndef(\loopr3).stop;
Ndef(\loopr3).set(\buf, ~buf3);
Ndef(\loopr3).set(\rate, 1);
Ndef(\loopr3)[0] = \loopr2;
U(\buf, Ndef(\loopr3));


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~yeah = B.readMono("/Users/david/Documents/supercollider/media/1channel/vox/oh-yeah-man-they-definitely-feel-it.wav")
Ndef(\loopr3).play;
Ndef(\loopr3).set(\buf, ~yeah);


/////////////////////////////////////////////////////////////////////
// fx matrix
/////////////////////////////////////////////////////////////////////
M.dcn.addSrc(Ndef(\loopr3));
M.dcn.addSrc(Ndef(\tgrains));
M.dcn.view;


b = Buffer.alloc(s, 4 * s.sampleRate, 1);
b.zero;

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

Ndef(\loopr3).play;
Ndef(\loopr3).stop;

Ndef(\tgrains)[0] = nil;//\mix -> {Ndef(\loopr3).ar};
Ndef(\tgrains).set(\wet100, 1);

Twister.connect;
Twister.knobs(0).cc([0.1, 20, \lin, 0, 1]);
Twister.knobs(1).cc([0.001, 1, \lin, 0, 0.1]);
Twister.knobs(2).cc([0.001, 1, \lin, 0, 0.1]);
Ndef(\tgrains).map(\density, Twister.knobs(0).asMap);
Ndef(\tgrains).map(\graindur, Twister.knobs(1).asMap);
Ndef(\tgrains).map(\which, Twister.knobs(2).asMap);

Ndef(\tgrains).play;
Ndef(\tgrains).stop;