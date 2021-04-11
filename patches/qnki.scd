W.transport;
Twister.connect;
Twister.view;
W.sendToTwister;
W.setParentEvent( (scale:[0, 2, 5, 7, 9], stepsPerOctave:12) );


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~qnki = S();
~qnki.mono(\plaits_mono);
~qnki.fx(10, 'delay/fb', 0.4);
~qnki.fx(20, 'reverb/jpverb', 0.3);
~qnki.set(\t60, 3, \size, 3, \engine, 0);

~qnki << [ [ [0, 1], 2], [0, 1], [-2, 2], [1, -1] ].pdv;
(
~qnki << [ [ [0, 1], 2], [0, 1], [-2, 2], [1, -1]  ].pdv
.mtranspose([0, 0, 0, 1, 2].pseq)
.amp(-12.dbamp)
)
~qnki.play;
~qnki.stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~tuhrs = S();
~tuhrs.synth(\modal);
~tuhrs.fx(20, 'reverb/jpverb', 1);
(
~tuhrs << [ [ [0, 1], 2], [0, 1], [-2, 2], [1, -1] ].pdv
.stretch(2)
.octave(Pmap(3, 8, 4, 5))
.harmonic(Pstep([1, [1, 1.5]], [2, 2], inf))
.amp(-6.dbamp)
.s(\harm, 0.5)
.amp(-12.dbamp)
)
~tuhrs.play;
~tuhrs.stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~tie = S();
(
~tie.synth({|freq|
    var mod = SinOsc.ar(freq * 0.5) * Env.perc(0.01, 0.1).ar().linlin(0, 1, 4, 1);
    SinOsc.ar(freq, mod.mod(2pi));
})
)
~tie.fx(20, 'delay/fb', 0.3);
~tie.fx(30, {|in| PitchShift.ar(in, 2, 2, 0.01, 0.01)}, 0.3);
(
~tie << [dur: [1, 1, 3, 3, 0.5, 0.5, 2, 3, 2].pseq].p
.stretch(0.25)
.legato(0.2)
.degree([0, 1, 2].pseq)
.octave(Pmap(5, 8, 4, 5))
.harmonic(1)
)
~tie.play;
~tie.stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~temu = S();
~temu.fx(30, 'delay/fb', 0.4);
(
~temu.synth({|freq|
    var sig = Saw.ar(freq);
    var fenv = Env.perc.ar().linlin(0, 1, 200, 4000);
    sig = RLPF.ar(sig, fenv, 0.5);
    sig
});
)
(
~temu << [ 0, 1, -1, 2 ].scramble.pdv
.stretch(1)
.legato(0.2)
.octave([4, 5, 6].pseq.stutter(3))
.harmonic(1)
.s(\fbL, 0.6, \fbR, 0.7)
.amp(-12.dbamp);
)
~temu.play;
~temu.stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~uecs = S();
~uecs.synth(\modal);
~uecs.fx(20, 'delay/fb', 0.4);
~uecs.fx(30, 'vst/Raum', 0.5);
(
~uecs << [dur: [ 3, 2, 1, 1, 1].pseq ].p
.stretch(0.5)
.legato(0.2)
.degree([0, 1, 3].pseq)
.octave(Pmap(3, 8, 5, 6))
.harmonic([1, 0.8])
.amp(0.1)
.s(\delL, 3, \delR, 4, \harm, 0.5, \wet30, 0.3)
)
~uecs.play;
~uecs.stop;
~uecs.vstctrls[30].editor;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~vfqsv = S();
~vfqsv.synth({|freq| Pulse.ar(freq, width:SinOsc.ar(1/3).range(0.3, 0.7)) });
(
~vfqsv.fx(10, {|in|

    var freq = \freq2.kr.max(100);
    var sig = in;
    sig = JPverb.ar(sig, 10, 0, 5, modDepth:0.5);

    sig = Klank.ar(`[
        Array.fill(8, {rrand(1, 8)}),
        Array.fill(8, {rrand(0.1, 1)}),
        Array.fill(8, {rrand(1, 1)})
    ], sig, freq * [1, 1.5]) * 0.05;

    //sig = (sig * 1.2).tanh * 1.2.sqrt.reciprocal;
    sig = LeakDC.ar(sig);

    //sig = JPverb.ar(sig, 3, 0, 3);

    sig = Limiter.ar(sig) * 0.2;
    sig
}, 0.8);
)

~vfqsv << [dur: 4, degree: [1, 2, 3].pseq, atk:1, rel:2, octave: 4, amp: 0.1, freq2: Pfunc({|evt| evt.use({~freq.value})})].p;
~vfqsv.play;
~vfqsv.stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~osz = S();
~osz.fx(20, 'delay/fb', 0.6);
~osz.fx(30, {|in| PitchShift.ar(in, 2, 2, 0.01, 0.01)}, 0.6);
(
~osz.mono({|freq, gate, aeg|
    var sig = SinOsc.ar(freq);
    var cenv = Env.perc.ar(gate:\trig2.tr).linlin(0, 1, 0.1, 0.001);
    sig = CombC.ar(sig, 1, cenv, 2);
    sig;
});
)
~osz << [degree: [0, 1, 2].pseq, legato:0.1, rel:0.1, trig2:[0, 1].pseq.stutter(2), amp:0.2].p;
~osz.play;
~osz.stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~bufs = B.dirMono("/Users/david/Documents/supercollider/workspaces/patches/");
~b = ~bufs.values.choose;

~mri = O(\mri);
~mri.set(\buf, ~b);
~mri.set(\amp, 0.2);
~mri.phase = {|dur, freq| LFTri.ar(freq); };
~mri.phase = {|dur, freq| Env.circle( { rrand(-1, 1) }.dup(16),  { rrand(0.1, 1) }.dup(16).normalizeSum * dur * 3.7,  -4 ).ar };
~mri.play;
~mri.stop;
~mri.view;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~dks = O(\dks);
~dks.set(\buf, ~bufs.values.choose.postln);
~dks.set(\amp, 0.2);
~dks.phase = {|dur, freq| HenonC.ar(0.15) };
~dks.play;
~dks.stop;
~dks.view;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~lejk = O(\lejk);
~lejk.set(\buf, ~bufs.values.choose.postln);
~lejk.set(\amp, 0.5);
(
~lejk.phase = {|dur, freq|
    var myfreq = freq * 0.25;
    Gendy1.ar(minfreq:myfreq, maxfreq:freq);
};
)
~lejk.play;
~lejk.stop;
~lejk.view;


Ndef(\send).clear;
Ndef(\send).play(fadeTime:8);
Ndef(\send).stop(fadeTime:16);
Ndef(\send).mix(0, ~mri, 1);
Ndef(\send).mix(1, ~dks, 0);
Ndef(\send).mix(2, ~lejk, 0);

Ndef(\send).vst(10, 'Raum');
~send_raum.editor;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~b = B.readMono("/Users/david/Documents/supercollider/workspaces/patches/samples/SC_210314_134543-6db.WAV");
~iaej = G();
~iaej.set(\buf, ~b);
~iaej.play;
~iaej.stop;
(
~iaej.set(\freq, 2,
    \startPos, 0.5,
    \endPos, 0.6,
    \pitch, 1,
    \pb, 0.5,
    \sync, 0,
    \freq, 20,
    \ampRand, 0.6,
    \posrand, 0.5,
    \graindur, 0.1
)
)
~iaej.view;
~iaej.fx(10, 'filters/res', 0.1);
~iaej.gui;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
M.eaylq.addSrc(~iaej);
M.eaylq.view;




