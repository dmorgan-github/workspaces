W.transport;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~uaae = S();
~uaae.mono(\plaits_mono);
~uaae.fx(10, {|in| DCompressor.ar(in)});
~uaae.fx(20, 'reverb/jpverb');
~uaae.fx(30, 'delay/fb');
~uaae.fx(35, {|in| Squiz.ar(in, [2, 1.5], SinOsc.ar(1/31).range(1, 20) )});
~uaae.fx(40, {|in|
    var trig = \trig2.tr;
    var fenv = Env.perc(0.01, 1).ar(gate:trig).linlin(0, 1, 800, 2000);
    var sig = LPF.ar(in, 4200);//RLPF.ar(in, fenv, 0.7);
    sig;// * Env.perc(0.01, 2).ar(gate:trig);
});

~uaae.set(
    \engine, 0,
    \harm, 0.5
);

~uaae.envir

(
~uaae << [
    \degree, 0,
    \amp, 0.dbamp,
    \octave, Pmap(3, 8, 5, 6),
    \dur, 0.25,
    \degree, Ppatlace([
        [0, 3].pseq,
        [1, 2, 4, 5].pseq
    ], inf),
    \mtranspose, [0, 0, 0, 1, 2].pseq,
    \t60, 2,
    \size, Pseg(
        [1, 1.5, 1].pseq,
        [32, 32].pseq,
        \lin, inf),
    \wet20, 0.6,
    \wet30, 0.5,
    \wet35, 0.5,
    \trig2, 1
].p
)

~uaae.play;
~uaae.stop;