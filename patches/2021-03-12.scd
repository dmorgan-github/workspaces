(
SynthDef(\s1, {

    var freq = Vibrato.ar(\freq.ar(261), 6, 0.02 * 0.5, 0.1);// * [1, 1.01];
    var gate = \gate.kr(1);
    var sig = Pulse.ar(freq, Rand(0.3, 0.7)); //Saw.ar(freq);
    var aeg = {
        Env.adsr(
            attackTime: \atk.kr(0.01),
            decayTime: \dec.kr(0.3),
            sustainLevel: \suslevel.kr(0.5),
            releaseTime: \rel.kr(1),
            curve: \curve.kr(-4)
        ).ar(doneAction:Done.freeSelf, gate: gate);
    };
    var cutoff = \cutoff.kr(2000);
    var fvel = \fvel.kr(0.5);
    var feg = Env.perc(
        \fatk.kr(0.01),
        \frel.kr(1)
    ).ar(gate:gate).linlin(0, 1, cutoff, cutoff * fvel);
    sig = RLPF.ar(sig, feg, \res.kr(0).linlin(0, 1, 1, 0.001));
    sig = sig * aeg.() * AmpCompA.kr(freq) * \amp.kr(-6.dbamp) * \vel.kr(1);
    sig = Pan2.ar(sig, \pan.kr(0));
    Out.ar(\out.kr(0), sig);

}).add;
)

(
Pdef(\s1,

    's1/ptrn/out'.out
    <> Pbind(
        \instrument, \s1,
        \degree, [0, 1, 2, 3].pseq,
        \amp, -6.dbamp,
        \dec, 0.1,
        \suslevel, 0.5,
        \rel, 1,
        \frel, 0.2,
        \cutoff, 2200,
        \fvel, 2,
        \legato, 0.1,
        \res, 0.5,
        \dur, 0.125,
        \root, 2,
        \scale, Scale.ritusen,
        \octave, Pmap(5, 8, 4, 5), // + Prand([0, 1, -1], inf),
        \vel, Pmap(3, 8, 0.7, 1)
    )
)
)

Pdef(\s1).play;
Pdef(\s1).stop;

(
Ndef('s1/ptrn/out').filter(100, {|in|
    var sig = in;
    sig = PitchShift.ar(sig, 2, 1.5, 0.01, 0.01) * \ps.kr(0.5) + sig;
    sig = FbC({|fb|
        LPF.ar(fb.reverse, 2200) * \fblevel.kr(0.3) + sig
    }, 1, [3/8, 4/8]); //* 0.4 + sig;
    sig = JPverb.ar(sig, 10, 0, \size.kr(3)) * 0.3 + sig;
    sig;
}).set(\wet100, 0.4);
)

Twister.connect;
Twister.knobs(0).cc([0.1, 10, \lin, 0, 3]).label_('rv size');
Twister.knobs(1).cc([0, 1]).label_('ps amt');
Twister.knobs(2).cc([0, 1]).label_('fb level');
Twister.view.front;

Ndef('s1/ptrn/out').map(\size, Twister.knobs(0).asMap);
Ndef('s1/ptrn/out').map(\ps, Twister.knobs(1).asMap);
Ndef('s1/ptrn/out').map(\fblevel, Twister.knobs(2).asMap);


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~sig = (Signal.sineFill(32, { rrand(0.1, 1.0)}.dup(8)) * 2).fold(-1, 1).linlin(-1, 1, -3, 9).round;

(
Pdef('s1/ptrn',

    's1/ptrn/out'.out
    <> Pspawner({|sp|

        var degrees = ~sig.pseq.asStream;
        var degrees2 = ~sig.pyramid.scramble.pseq.asStream;
        var s1 = Pdef(\s1).asStream;
        var prev = nil;

        inf.do({|i|
            var degree = degrees.next;
            var degree2 = degrees2.next;
            var s1next = s1.next(Event.default);

            if (degree2 != degree) {
                if (0.6.coin) {
                    sp.par( Pbind(\degree, degree, \cutoff, 1000).fin(1) <> s1next );
                };
            } {
                sp.par(
                    Pbind(
                        \degree, degree,
                        \dur, 0.125,
                        \mtranspose, Prand([0, 1, 2], inf),
                        \rel, 2,
                        \dec, 0.1,
                        \suslevel, Pwhite(0.1, 0.7),
                        \harmonic, [1, 1.5],
                        \vel, Pkey(\vel) * 0.5,
                        \octave, 4,
                        \cutoff, 200,
                        \fvel, 8,
                        \frel, Pwhite(0.1, 1),
                        \res, Pwhite(0.5, 0.8)
                    ).fin([3, 4, 5].choose) <> s1next
                );
            };
            sp.wait(0.25);
        });
    })
)
)


Pdef('s1/ptrn').play;
Pdef('s1/ptrn').stop;



(
Pdef('s1/ptrn/play',

    Pseq([
        Psync(Pdef('s1/ptrn').finDur(65), 72)
    ], 2)

)
)

(
Pdef(\srbhz,
    Ptpar( [
        0, Pdef('s2'),
        64, Pdef('s1/ptrn/play')
    ]).finDur(128)
)
)

s.record;
Pdef(\srbhz).play;
s.stopRecording;

Pdef(\srbhz).stop;

Pdef('s1/ptrn/play').play;
Pdef('s1/ptrn/play').stop;

Pdef('s4/ppar').play;

Pdef('s2').play;
Pdef('s2').stop;


Pdef('s1/ptrn/play').stop;
Pdef('s4/ppar').stop;
Pdef('s2').stop;


Pdef('s1/ptrn/play').stop;