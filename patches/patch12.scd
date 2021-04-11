S.loadSynths;
W.transport
W.recdir

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~s1 = S();
~s1.synth(\modal);
~s1.fx(10, {|in|
    var sig = in;
    sig = sig.blend(PitchShift.ar(in, 2, 1.5, 0.01, 0.01), 0.4);
    sig = FbC({|fb| fb * 0.5 + sig}, 1, [3/5, 3/9]);
    sig;
}, 0.6);
~s1.fx(20, 'granular/grainin', 0.4);
~s1.fx(30, {|in|
    JPverb.ar(in.blend(LeakDC.ar(SinOsc.ar(0, in * 1.5)) * 0.5, 0.3), 5, 0, 5)
}, 0.35);
~s1.fx(40, {|in| AnalogTape.ar(in, 1, 1.01, 1)}, 0.3);
~s1.fx(50, {|in| var sig = SinOsc.ar(0, (in * 8).mod(2pi)); LeakDC.ar(sig) }, 0);
~s1.fx(60, {|in| Limiter.ar(in, 0.7)});
~s1.play;
~s1.stop;
~s1.set(\harm, 0.5)
~s1 << "9..8..5..3.".probs.stretch(0.125).s(\degree, [0, \, \, 1, \, \, 4, \, \, 5, \].pseq);
~s1 << "9..9...5.7.".probs.stretch(0.125).s(\degree, [0, 1, 4, 5].pseq.norest);
~s1.node.play;

~jfe.stop;


~b2 = B.readMono("/Users/david/Documents/supercollider/workspaces/SC_210403_100807-6db.WAV");

~o1 = O();
~o1.set(\buf, ~b2);
~o1.set(\rate, 0.8);
~o1.phase = {|dur, freq| LFTri.ar(freq * 0.5) };
~o1.view;
~o1.stop;


(
Ndef(\a, {
    var s1, s2, s3;
    var sig, which;

    s1 = ~o1.ar;
    s2 = ~jfe.ar;

    which = TChoose.kr(Dust.kr(1), [0, 1]);
    sig = SelectXFocus.ar(which, [s1, s2], LFNoise2.ar(1).range(0.5, 1.0));

    sig = sig.blend(JPverb.ar(sig, 5, 0, 5), 0.3);
    sig = sig.blend(AnalogTape.ar(sig, 0.7, 0.8, 0.9), 0.7);
    sig = sig.blend(PitchShift.ar(sig, 2, 1.5, 0.01, 0.01), 0.7);

    sig;
})
)

Ndef(\a).play(fadeTime:4);
Ndef(\a).stop(fadeTime:8);


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~s2 = S();
~s2.synth(\modal);
~s2.fx(10, {|in|
    FbC({|fb| PitchShift.ar(fb, 2, 2, 0.01, 0.01) * 0.5 + in}, 1, [3/5, 3/9]);
}, 0.4);
~s2.play;
~s2.stop;
~s2 << ".9..8...5..3".probs.stretch(0.125).s(\degree, [-1, 1, -2, 2].pseq.norest.stutter(2)).s(\octave, 6, \harm, 0.5);
~s2.node.stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~s3 = S();
~s3.synth(\pm2op);
~s3.set(\fb, 0.7, \op1_m2, 0.1, \op2ratio, 2);
~s3.play;
~s3.stop;
~s3 << [ 2, 4, -1, 0 ].pdv.stretch(0.25);
~s3.node.stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~s4 = S();
~s4.synth({|freq| Pulse.ar(freq, SinOsc.ar(1).range(0.3, 0.6)) });
~s4.play;
~s4.stop;
~s4 << [degree: 0, dur: 4, octave: 4, atk: 2, rel: 4, amp: 0.dbamp].p;
~s4.node.stop;


