s.scope(2, 4);
W.transport;
/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
(
S.ikrga.synth({|freq|
    var fbenv = Env.perc(1, 1).ar().linlin(0, 1, 0.1, 0.9);
    var sig = Pulse.ar(freq, fbenv);
    var fenv = Env.perc.ar();
    var filt = LPG.ar(sig, fenv, 0.5, 1, 0.8, 0.2);
    filt
})
)

S.ikrga.play;
S.ikrga.stop;
S.ikrga @.wet300 0.3 @.fx 300 -> 'delay/fb'
(
S.ikrga @.fx 310 -> {|in|
    var sig = in;
    sig = sig.blend(PitchShift.ar(sig, 2, 2, 0.01, 0.01), 0.5);
    sig = sig.blend(ReverseDelay.ar(in), 0.5);
    sig;
}
)
S.ikrga @.wet300 0
S.ikrga @.fx 320 -> 'vst/Raum'
S.ikrga @.dur Y.partam(16, 5, 1, 2, 3, 4, 5).collect(_.pseq(1)).pseq
S.ikrga @.deg [0, 1].pseq.stutter(3)
S.ikrga @.stretch 1
S.ikrga @.harmonic [1, 1.5] @.wet [1, 0.5]
S.ikrga @.detunehz 0.8
S.ikrga @.oct Y.neckam(8, 4, 1, 3).collect(_.pseq(1)).pseq.linlin(0, 1, 4, 5);
S.ikrga.vstctrls[320].editor;
S.ikrga.view;

/////////////////////////////////////////////////////////////////////
// create loopr
/////////////////////////////////////////////////////////////////////
B.ikrga.write(App.workspacedir +/+ "patches/ikrga.wav");
O.ikrga_loopr.phase = {|dur, freq| ( LFTri.ar(freq * [0.5, 0.25], -1) * 1.01).fold(-0.5, 1) ;}
O.ikrga_loopr.fx(200, {|in| LPF.ar(in, 1200) });
O.ikrga_loopr.stop;
O.ikrga_loopr.play(fadeTime:4);

App.recAtCommit("");