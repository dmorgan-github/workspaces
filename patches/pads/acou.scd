
/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~acou = S();
~acou.synth({|freq, gate, aeg|
    var voices = 8;
	var sig = { Saw.ar(freq * Rand(0.99, 1.01 )) * voices.reciprocal }.dup(voices).sum;
	var cutoff = \cutoff.kr(0.5).clip(0, 1).linlin(0, 1, 20, 20000);
	var fvel = \fvel.kr(1).max(0.1);
	var feg = aeg.range(cutoff, cutoff * fvel).clip(20, 18000);

	sig = SelectXFocus.ar(1, [
		sig,
		sig ring1: SinOsc.ar(freq * 0.5)
	], 0.4);

	sig = RLPF.ar(sig, feg, \res.kr(0.5).linlin(0, 1, 1.4, 0.01));

	sig;
});

~acou.play;
~acou.stop;

(
~settings = IdentityDictionary[
    ('glis' -> 0.0),
    ('amp' -> 0.50118720531464),
    ('vdepth' -> 0.0),
    ('center' -> 0.0), ('cutoff' -> 0.04),
    ('width' -> 0.5), ('res' -> 0.01),
    ('ts' -> 1.0),
    ('atk' -> 0.0099999997764826),
    ('vel' -> 1.0),
    ('rel' -> 0.10000000149012),
    ('pw' -> 0.12502250671387),
    ('spread' -> 1.0),
    ('fvel' -> 1.0), ('vrate' -> 0.01),
    ('octave' -> 4), ('detunehz' -> 1),
    ('dec' -> 0.10000000149012),
    ('curve' -> -4.0),
    ('suslevel' -> 1.0)
];
~acou.set(*~settings.getPairs);
)

~acou.set(
    \cutoff, 0.04, //exprand(0.05, 0.2),
    \res, 0.01, //rrand(0.1, 0.8),
    \detunehz, 1,
    \octave, 4,
    \vrate, 0.01
);

(
'acou/1'.p << [

    [
        \dur, 4,
        \legato, 0.9,
        \atk, 1,
        \rel, 2,
        \octave, 4,
        \strum, 0.5,
        \harmonic, [1, 2],
        \degree, [
            [0, 2, 4],
            [1, 3, 6]
        ].pseq,
        \amp, 0.1 * 5.5,
        \fvel, Pbjorklund(3, 8).linlin(0, 1, 1, 1.2)
    ].p
    <> ~acou,

    [
        \dur, 8,
        \legato, 0.9,
        \atk, 2,
        \rel, 2,
        \octave, 3,
        \harmonic, 1,
        \degree, [
            [0, 4],
            [-4, 1]
        ].pseq,
        \amp, 0.05 * 5.5
    ].p
    <> ~acou

].ppar
)

'acou/1'.p.play;
'acou/1'.p.stop;

