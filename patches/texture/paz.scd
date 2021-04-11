W.transport;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~paz = S();
~paz.synth(\abstract_drum);
~paz.fx(10, {|in|  DCompressor.ar(in, ratio:4, release: 1)});
~paz.fx(20, 'reverb/jpverb');
~paz.fx(30, 'delay/fb');
~paz.fx(40, {|in|

    var sig = in;
    var fx = {|in|
        var ps = \ps.kr(2);
        var sig1 = PitchShift.ar(in, 2, ps, 0.01, 0.01);
        var sig2 = Squiz.ar(in, ps, SinOsc.ar(1/21).range(1, 30));
        var sig = SelectX.ar(TChoose.kr(Dust.kr(0.5), [0, 1]), [sig1, sig2]);
        sig = Limiter.ar(sig, 0.7);
        sig;
    };

    sig = sig.blend(fx.(sig), 0.5);
});

~paz.fx(50, 'granular/grainin');

~paz << [
    decCoef: Pwhite(0.1, 1.0),
    position: Pwhite(0.1, 1.0),
    amp: 5.dbamp,
    dur: [1.5, 1, 1.5].pseq * 0.5,
    hiFreqSus: 0.4,
    octave: Pmap(3, 8, 5, 6),
    harmonic: [1, 1.5],
    wet20: 0.3,
    t60: 3,
    size: Pwhite(1.0, 3.0),
    fbL: 0.7,
    fbR: 0.6,
    delL: 2.5,
    delR: 4,
    ps: [1.5, 2].pseq.stutter(4),
].p;

~paz.play;
~paz.stop;





