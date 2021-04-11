(
SynthDef(\s1, {

    var gate = \gate.kr(1);
	var freq = \freq.ar(20);
	var buf = \buf.kr(0);
	var grainenv = \grainenv.kr(-1);
	var pitch = \pitch.kr(1);
	var replyid = \bufposreplyid.kr(-1);
	var graindur = \graindur.kr(0.1);

	var aeg = {
		var atk = \atk.kr(0.001);
		var suslevel = \suslevel.kr(1);
		var rel = \rel.kr(1);
		var curve = \curve.kr(-4);
		Env.asr(atk, suslevel, rel, curve).ar(doneAction:Done.freeSelf, gate:gate)
	};

	var density = {
		var sync = \sync.kr(1);
		Select.ar(sync, [Dust.ar(freq), Impulse.ar(freq)]);
	}.();

	var phase = {
		var speed = \pb.kr(1);
		var posrand = \posrand.kr(0);
		var start = \startPos.kr(0) * BufFrames.kr(buf);
		var end = \endPos.kr(1) * BufFrames.kr(buf);
		var phase = Phasor.ar(0, speed * BufRateScale.ir(buf), start, end);
		phase = phase + LFNoise1.kr(100).bipolar(posrand * SampleRate.ir);
		phase = phase/BufSamples.ir(buf);
		phase
	}.();

	var pan = {
		var pan = \pan.kr(0);
		var panHz = \panHz.kr(0.1);
		var panRand = \panRand.kr(0);
		pan + LFNoise1.kr(panHz).bipolar(panRand);
	}.();

	var sig = GrainBuf.ar(
		numChannels:2,
		trigger:density,
		dur:graindur,
		sndbuf:buf,
		rate:pitch,
		pos:phase,
		interp:2,
		pan:pan
	);

    sig = LeakDC.ar(sig);
	sig = sig * aeg.() * \amp.kr(0.3) * AmpCompA.kr(freq) * \vel.kr(1);
	SendReply.kr(Impulse.kr(60), '/bufpos', [0, phase * BufFrames.kr(buf)], replyid);
	Out.ar(\out.kr(0), sig);

}).add;
)

(
~bufs = ~texture;
~num = (0..~bufs.size).choose;
~buf = ~bufs.values[~num.postln];
)
~buf = ~yeah;
~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");


(
Pdef(\s1,

    's1/out'.out
    <> Pbind(
        \instrument, \s1,
        \buf, ~buf,
        \pos, Pwhite(0.2, 0.8),
        \pb, 0,
        \octave, 3,
        \harmonic, [1, 1.5],
        \degree, [0, 1, 3],
        \mtranspose, [0, 1, -2, -3].pseq,
        \scale, Scale.ritusen,
        \dur, 8,
        \atk, 2,
        \rel, 8
    )
)
)


(
Ndef('s1/out').filter(100, {|in|
    var sig = LPF.ar(in, 2000);
    var fb = LocalIn.ar(2);
    sig = fb * 0.3 + sig;
    sig = PitchShift.ar(sig, 2, [2, 1.5], 0.01, 0.01);
    sig = JPverb.ar(sig, 10, 0, SinOsc.ar(1/21).range(0.1, 0.2));
    LocalOut.ar(sig);
    sig = LPF.ar(sig, 2000);
    sig = HPF.ar(sig, 80);
    sig;
}).set(\wet100, 0.7);
)


Pdef(\s1).play;
Pdef(\s1).stop;

s.record;
Pdef(\s1_play1, Pdef(\s1).finDur(129)).play;
s.stopRecording;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

(
SynthDef(\s2, {

    var gate = \gate.kr(1);
    var buf = \buf.kr(0);
    var freq = \freq.kr(261) * [1, 1.01];
    var phase = {
        var start = \start.kr(0) * BufFrames.kr(buf);
        var end = \end.kr(1) * BufFrames.kr(buf);
        LFSaw.ar(freq).linlin(-1, 1, start, end);
    };
    var sig = LeakDC.ar(BufRd.ar(1, buf, phase.(), 0, 4));
    var aeg = Env.adsr(\atk.kr(0.01), releaseTime:\rel.kr(1)).ar(doneAction:Done.freeSelf, gate:gate);
    sig = sig * aeg * AmpCompA.kr(freq) * \amp.kr(-6.dbamp) * \vel.kr(1);
    sig = Pan2.ar(sig, \pan.kr(0));
    Out.ar(\out.kr(0), sig);
}).add
)

~buf = ~yeah;
~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

(
Pdef(\s2,

    's2/out'.out
    <> Pbind(
        \instrument, \s2,
        \buf, ~buf,
        \amp, -6.dbamp,
        \degree, Pwhite(0, 4),
        \scale, Scale.zhi,
        \root, 2,
        \octave, 3,
        \harmonic, [1, 1.5],
        \dur, 8,
        \atk, 3,
        \rel, 8,
        \start, Pwhite(0.1, 0.5),
        \vel, 1
    )
)
)

Pdef(\s2).play;
Pdef(\s2).stop;

(
Ndef('s2/out').filter(100, {|in|
    var sig = LPF.ar(in, 2000);
    var fb = LocalIn.ar(2);
    sig = fb * 0.3 + sig;
    sig = PitchShift.ar(sig, 2, [2, 1.5], 0.01, 0.01);
    sig = JPverb.ar(sig, 10, 0, SinOsc.ar(1/9).range(0.1, 0.5));
    sig = LeakDC.ar(sig);
    LocalOut.ar(sig);
    sig = LPF.ar(sig, 1200);
    sig = HPF.ar(sig, 80);
    sig;
}).set(\wet100, 0.9);
)


Pdef(\s2_play1, Pdef(\s2).finDur(129)).play;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

(
SynthDef(\s3, {

    var bufnum = \bufnum.kr(0);
    var freq = \freq.kr(261);
    var gate = \gate.kr(1);
    var sig = COsc.ar(bufnum, freq, \beats.kr(0.3));
    var aeg = Env.adsr(\atk.kr(0.01), releaseTime:\rel.kr(1)).ar(doneAction:Done.freeSelf, gate: gate);
    sig = sig * aeg * AmpCompA.kr(freq) * \amp.kr(-6.dbamp) * \vel.kr(1);
    sig = Pan2.ar(sig, \pan.kr(0));
    Out.ar(\out.kr(0), sig);

}).add;
)

~bufnum = ~epiano.nums.choose.postln;
~sig = (Signal.sineFill(32, { rrand(0.1, 1.0)}.dup(8)) * 2).fold(-1, 1).linlin(-1, 1, -3, 9).round;
~sig.plot;

(
Pdef(\s3,

    's2/out'.out
    <> Pbind(
        \instrument, \s3,
        \bufnum, ~bufnum,
        \degree, ~sig.pseq.clump(3),
        \dur, 8,
        \harmonic, [1, 1.5],
        \atk, 2,
        \rel, 8,
        \octave, 4,
        \scale, Scale.ritusen,
        \root, 2,
        \vel, 0.27
    )
)
)

Pdef(\s3).play;
Pdef(\s3).stop;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~sig = (Signal.sineFill(32, { rrand(0.1, 1.0)}.dup(8)) * 2).fold(-1, 1).linlin(-1, 1, -3, 9).round;


(
var prev = nil;

Pdef(\s4,

    's4/out'.out

    <> Pbind(
        \instrument, \s3,
        \bufnum, ~bufnum,
        //\foo, ~sig.pseq,
        \foo, Pseq([
            ~sig.pseq(1),
            ~sig.reverse.pseq(1)
        ], inf),
        \degree, Pfunc({|evt|
            var foo = evt[\foo];
            if (foo != prev) {
                prev = foo;
                foo;
            } {
                Rest(1)
            };
        }),
        \stretch, 0.25,
        \octave, Pmap(3, 8, 4, 5) - 1,
        \harmonic, [1, 1.5],
        \scale, Scale.ritusen,
        \root, 2,
        \rel, 2,
        \legato, Pwhite(0.1, 0.9),
        \vel, Pmap(3, 8, 0.7, 1),
        \strum, Pwhite(0.0, 0.02)
    )
)
)

S.transport

(
var prev = nil;
Pdef(\s4,

    's4/out'.out
    <>
    Pseq([

        Psync(
            Pbind(
                \foo, ~sig[0..4].pseq(1),
                \degree, Pfunc({|evt|
                    var foo = evt[\foo];
                    if (foo != prev) {
                        prev = foo;
                        foo;
                    } {
                        Rest(1)
                    };
                }),
                \stretch, 0.5,
                \strum, 0
                //\octave, Pkey(\octave)
            ) <> Pdef('s4/v2'),
            4
        ),

    ], inf),

)
)

Pdef(\s4).play;
Pdef(\s4).stop;

(
var prev = nil;
Pdef('s4/wtf',

    Pseq([
        Psync(
            Pbind(
                \foo, ~sig[0..8].reverse.pseq(1),
                //\foo, ~sig[6..15].reverse.pseq(1),
                \degree, Pfunc({|evt|
                    var foo = evt[\foo];
                    if (foo != prev) {
                        prev = foo;
                        foo;
                    } {
                        Rest(1)
                    };
                }),
                \stretch, 0.25,
                \strum, 0,
                //\octave, Pkey(\octave) + 1,
                \mtranspose, 2,
                //\vel, Pkey(\vel) * 0.6
            ) <> Pdef('s4/v2'),
            16
        ),

    ], inf)
)
)

Pdef('s4/wtf').play;
Pdef('s4/wtf').stop;

(
Pdef('s4/ppar',
    Ppar([
        Pdef('s4'),
        Pdef('s4/wtf')
    ])
)
)
Pdef('s4/ppar').play;
Pdef('s4/ppar').stop;

(
Pdef(\score,
    Ptpar([
        0, Pdef('s4/ppar'),
        32, Pdef('s3'),
        64, Pdef('s2'),
    ]).finDur(128)
)
)

s.record;
Pdef(\score).play;
s.stopRecording;

Pdef(\score).stop;


(
Ndef('s4/out').filter(100, {|in|
    var sig = in;

    sig = FbC({|fb|
        var fx = FreqShift.ar(fb.reverse, 3, 0) * 0.4 + sig;
        fx = PitchShift.ar(fx, 2, 2, 0.01, 0.01) * 0.6 + fx;
        fx;
    }, 1, [2/4, 3/4]);

    sig = LPF.ar(sig, 2000);
    sig;
}).set(\wet100, 0.5)
)


Pdef(\s2).play;
Pdef(\s3).play;
Pdef(\s4).play;


Pdef(\s2).stop;
Pdef(\s3).stop;
Pdef(\s4).stop;

(
Pdef(\play,
    Ptpar([
        16, Pdef(\s2),
        32, Pdef(\s3),
        0, Pdef(\s4)
    ]).finDur(97)
)
)

s.stopRecording;
s.record;
Pdef(\play).play;
Pdef(\play).stop;

App.recdir