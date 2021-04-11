W.transport;

Event.addParentType(\note, (root:0, scale:Scale.ritusen));

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

Twister.connect;
Twister.knobs(0).cc([0, 1, \lin, 0, 0.5]);

~s2 = S();
~s2.synth({|freq| SinOsc.ar(freq, SinOsc.ar(SinOsc.ar([1/13, 1/7]).range(1, 5)).mod(2pi)) });
~s2.fx(100, 'reverb/jpverb', 0.5);
~s2.seq(\dur, 6);
~s2.seq(\atk, 2, \rel, 8);
~s2.seq(\degree, [0, 2, 4]);
~s2.seq(\octave, 5, \harmonic, [1, 1.5]);
~s2.seq(\t60, 5, \size, 5, \wet100, 0.7);
~s2.seq(\modDepth, Twister.knobs(0).asMap);
~s2.seq(\mtranspose, [0, 2, 3].pseq.stutter(2));
~s2.seq(\amp, -20.dbamp);
~s2.play;
~s2.stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~s3 = S();
(
~s3.synth({|freq|
    var sig = SinOsc.ar(freq);
    sig;
}, \perc);
)
~s3.fx(100, 'vst/ValhallaSupermassive', 0.6);
~s3.fx(200, 'timbre/lofi');
~s3.set(\wow, 0.6);
~s3.set(\amp, -20.dbamp);
~s3.set(\stepsPerOctave, 19);
~s3.play;
~s3.stop;
~s3.vstctrls[100].editor;

's3/a'.p << [0, 1, \, [3, [5, 6, 7] ]].pdv.stretch(0.5).s(\octave, 6, \vel, Pwhite(0.7, 1.0));
~s3 << 's3/a'.p.s(\harmonic, [1, 2], \octave, 6, \rel, 1);
~s3 << 's3/a'.p.stretch(2).s(\harmonic, [1, 1.5], \octave, 6, \rel, 2).m(\degree, -1);
~s3 << 's3/a'.p.stretch(1).stretch(4).s(\harmonic, [1, 2], \octave, 6, \rel, 0.5);

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~s4 = S();
(
~s4.synth({|freq, gate, aeg|
    var sig = WhiteNoise.ar;
    sig = CombC.ar(sig, 0.1, freq.reciprocal, 2);
    sig = RLPF.ar(sig, Env.perc(0.01, 0.1).ar.linlin(0, 1, 1200, 4000), 0.2);
    sig;
});
)
~s4.fx(100, 'vst/ValhallaSupermassive', 0.8);
~s4.seq(\octave, 3);
~s4.seq(\dur, 8);
~s4.seq(\atk, 2, \rel, 8, \legato, 0.5, \dec, 0.1, \suslevel, 1);
~s4.seq(\degree, 0);
~s4.seq(\amp, -20.dbamp);
~s4.seq(\wet100, 0.5);
~s4.play;
~s4.stop;
~s4.vstctrls[100].editor;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~s5 = S();
~s5.mono(\plaits_mono);
(
~s5.fx(10, {|in|
    var sig = in;
    var fb = LocalIn.ar(2);
    sig = DelayC.ar(fb.reverse, 4, [\delL.kr(3/4), \delR.kr(4/4)]);
    sig = sig * \fb.kr(0.5) + in;
    LocalOut.ar(sig);
    sig
});
)
~s5.fx(20, 'delay/reversedelay', 0.6);
~s5.fx(30, 'reverb/jpverb', 0.3);
~s5.seq(\engine, 11);
~s5.seq(\wet10, 0.5, \wet20, 0.3, \wet30, 0.3);
~s5.seq(\delL, 3/8, \delR, 4/8, \fb, 0.8);
~s5.seq(\amp, -3.dbamp);
~s5.seq(\degree, [4, 3, 7, 6, 8].pseq, \dur, [1, 1, 1, 1, 4].pseq * 0.25);
~s5.seq(\octave, Pmap(3, 8, 5, 6)-1);
~s5.play;
~s5.stop;
~s5.node.play;



/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~s6 = S();
~s6.quant_(4.0);
~s6.fadeTime_(4.0);
~s6.mono(\plaits_mono);
(
~s6.fx(10, {|in|
    var sig = in;
    var fb = LocalIn.ar(2);
    sig = DelayC.ar(fb.reverse, 4, [\delL.kr(3/4), \delR.kr(4/4)]);
    sig = sig * \fb.kr(0.5) + in;
    LocalOut.ar(sig);
    sig
});
)
~s6.fx(20, 'delay/reversedelay', 0.6);
~s6.fx(30, 'reverb/jpverb', 0.3);
~s6.set(\wet10, 0.3, \wet20, 0.3, \wet30, 0.4);
~s6.set(\delL, 3/8, \delR, 4/8, \fb, 0.8);
~s6.set(\amp, -10.dbamp);
~s6.set(\t60, 5);
~s6.play;
~s6.stop;


's6/1'.p << [0, -1, 2, [3, -4]].pdv.stretch(0.25).s(\octave, Pmap(3, 8, 6, 7));
~s6 << 's6/1'.p.stretch(1).s(\glis, 0.1).s(\delL, [3/8, 5/4].pseq.stutter(2)).s(\amp, -3.dbamp);
~s6 << 's6/1'.p.stretch(0.5).s(\octave, Pmap(3, 8, 5, 6)).s(\glis, 0).s(\t60, 10);
~s6 << 's6/1'.p.stretch(0.5).s(\octave, Pmap(3, 8, 5, 6) + 1).s(\glis, 0.1).m(\degree, -1);

's6/2'.p << 's6/1'.p.stretch(0.5).s(\octave, Pmap(5, 9, 5, 6) + 1).s(\glis, 0.1).a(\degree, 2);
~s6 << 's6/2'.p.s(\engine, 11);


(
~s6.stretch(0.5)
.every(9, 2)
.m(\degree, -1)
.f(\octave, 6, \stepsPerOctave, 24)
.f(\foo, Pkey(\octave), \engine, 1)
.pdef('s6/1')
.play;
)


(
'test123'.p(
    [
        ~s6.every(4, 4),

        ~s6.stretch(0.5)
        .every(9, 4)
        .mul(\degree, -1)
        .f(\octave, 6, \stepsPerOctave, 24)
        .f(\foo, Pkey(\octave), \engine, 1)

    ].ppar
)
)

'test123'.p.play;
'test123'.p.stop;


(
's6play'.p(

    Ptpar([

        0, Pseq([
            Psync(~s6, 8, 8),
        ], inf),

        16, Pseq([
            Pbind(\degree, Pkey(\degree).neg, \vel, 0.4, \rel, 1)
            <> Psync(~s6, 11, 11)
        ], inf),

        32, Pseq([
            Pdv([ 0, 1, -2, [4, 4]], \degree).repeat
            <> Pbind(\stretch, 0.5)
            <> ~s6
        ], inf),

       48,  ~s5
    ])
)
)

's6play'.p.play;
's6play'.p.stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////


~k1 = S();
~k1.fx(10, {|in| AllpassC.ar(FreqShift.ar(in, 20), 1, 3/8, 2);}, 0.4);
(
~k1.synth({|freq|
    var menv = Env.perc(0.01, 0.1).ar().linlin(0, 1, 0, 2);
    var mod = SinOsc.ar(freq * 2) * menv;
    SinOsc.ar(freq, mod.mod(2pi));
}, \perc);
)


~k2 = S();
~k2.synth({|freq| Pulse.ar(freq, LFSaw.ar(1).range(0.1, 0.7))}, \perc);
(
~k2.fx(10, {|in|
    var sig = in;
    var fb = LocalIn.ar(2);
    sig = DelayC.ar(fb.reverse, 4, [\delL.kr(3/4), \delR.kr(4/4)]);
    sig = sig * \fb.kr(0.8) + in;
    sig = LeakDC.ar(sig);
    LocalOut.ar(sig);
    sig
}, 0.7);
)

~k3 = S();
~k3.synth({|freq| SinOscFB.ar(freq, Rand(0.3, 0.7));});

'k1/a'.p << "..55..55..55..55".probs.stretch(0.25).s(\octave, Pmap(5, 8, 5, 6).norest, \wet10, 0.5);
~k1 << 'k1/a'.p.stretch(Pif(Pfunc({0.5.coin}), 1, 0.5)).s(\degree, [0, 1, 2, 3].pseq.norest).every(8, 6);
~k1 << 'k1/a'.p.s(\degree, [0, 1, 2, 3].pseq.norest).s(\rel, 0.5);
~k1.play;
~k1.stop;

~k2 << "..97..95..94..".probs.stretch(0.25).s(\degree, [0, 1, 2].pseq.norest, \rel, 0.5, \wet10, 0.5, \octave, Pmap(3, 8, 5, 6).norest, \amp, -3.dbamp);
~k2.play;
~k2.stop;

'k/1'.p << [~k1, ~k2].ppar;
'k/1'.p.play;
'k/1'.p.stop;

(
~k3.fx(10, {|in|
    var sig = in;
    var fb = LocalIn.ar(2);
    sig = DelayC.ar(fb.reverse, 4, [\delL.kr(3/4), \delR.kr(4/4)]);
    sig = sig * \fb.kr(0.8) + in;
    sig = LeakDC.ar(sig);
    LocalOut.ar(sig);
    sig
}, 0.5);
)
~k3.fx(20, 'vst/Raum', 0.6);
~k3.play;
~k3.stop;

~k3 << [0, [\, 1], 2, [\, 3]].mirror.pdv.stretch(0.25).s(\octave, Pmap(3, 7, 5, 6)).s(\rel, 1).s(\delL, 5/8).s(\delR, 3/8);
~k3 << [0, [\, 1], 2, [\, 3]].mirror.pdv.stretch(0.5).s(\octave, Pmap(3, 7, 5, 6)).s(\rel, 1).s(\delL, 5/8).s(\delR, 3/8);

'k3/a'.p << [0, [\, 1], 2, [\, 3]].mirror.pdv.stretch(1).s(\octave, Pmap(3, 8, 5, 6)).s(\rel, 2).s(\delL, 5/8).s(\delR, 3/8);
~k3 << 'k3/a'.p.s(\vdepth, 0.01 * 0.5);
~k3 << 'k3/a'.p.s(\vdepth, 0.01 * 0.7);

~k3.vstctrls[20].editor;



/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~s7 = S();
~s7.synth({|freq| SinOscFB.ar(freq, SinOsc.ar(1/3).range(-0.7, 0.7) )});
~s7.fx(10, {|in| JPverb.ar(PitchShift.ar(in, 2, 2, 0.01, 0.01), 10, 0, 5, modDepth:0.5)}, 0.6);
~s7.play;
~s7.stop;
~s7 << [\degree, [0, -3].pseq.stutter(2)].p.s(\octave, 5, \dur, 8, \legato, 0.7, \atk, 0.5, \rel, 4, \harmonic, [1, 1.5, 2]);


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
(
Roli.note(
    {|note, vel|
        ~s5.on(note, vel);
    },
    {|note|
        ~s5.off(note);
    }
);
)