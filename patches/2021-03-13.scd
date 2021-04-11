/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
App.recdir;
S.transport;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

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
    ).ar(gate:gate).linlin(0, 1, cutoff, cutoff * fvel).clip(20, 20000);
    sig = RLPF.ar(sig, feg, \res.kr(0).linlin(0, 1, 1, 0.001));
    sig = sig * aeg.() * AmpCompA.kr(freq) * \amp.kr(-6.dbamp) * \vel.kr(1);
    sig = Pan2.ar(sig, \pan.kr(0));
    Out.ar(\out.kr(0), sig);

}).add;
)

/////////////////////////////////////////////////////////////////////
// fx
/////////////////////////////////////////////////////////////////////
(
Ndef('s1/ptrn/out').filter(100, {|in|
    var sig = in;
    sig = PitchShift.ar(sig, 2, 1.5, 0.01, 0.01) * \ps.kr(0.5) + sig;
    sig = FbC({|fb|
        LPF.ar(fb.reverse, \delcutoff.kr(2200)) * \fblevel.kr(0.3) + sig
    }, 1, [3/8, 4/8]); //* 0.4 + sig;
    //sig = JPverb.ar(sig, 10, 0, \size.kr(3)) * 0.3 + sig;
    sig;
}).set(\wet100, 0.4);
)

Ndef('s1/ptrn/out')[100] = nil;

/////////////////////////////////////////////////////////////////////
// midi setup
/////////////////////////////////////////////////////////////////////
Twister.connect;
Twister.knobs(0).cc([0.1, 10, \lin, 0, 3]).label_('rv size');
Twister.knobs(1).cc([0, 1]).label_('ps amt');
Twister.knobs(2).cc([0, 1]).label_('fb level');
Twister.knobs(3).cc([200, 4000, \lin, 0, 2000]).label_('cutoff');
Twister.knobs(4).cc([0.001, 1, \lin, 0, 0.5]).label_('res');
Twister.knobs(5).cc([0.1, 2, \lin, 0, 1]).label_('rel');
Twister.knobs(6).cc([200, 16000, \lin, 0, 2200]).label_('delay cutoff');
Twister.knobs(7).cc([0, 1, \lin, 0, 0.5]).label_('sus level');
Twister.knobs(8).cc([0.001, 1, \lin, 0, 0.2]).label_('f rel');
Twister.knobs(9).cc([-5, 7, \lin, 1, 0]).label_('mtranspose');
Twister.knobs(10).cc([0.001, 1, \lin, 0, 0.1]).label_('legato');
Twister.knobs(11).cc([1, 7, \lin, 1, 5]).label_('k');
Twister.knobs(12).cc([0.25, 4, \lin, 0, 2]).label_('f vel');
Twister.knobs(13).cc([-90, 1, \lin, 0, -39]).label_('kneepointL');
Twister.knobs(14).cc([-90, 1, \lin, 0, -39]).label_('kneepointR');
Twister.knobs(15).cc([0.5, 4, \lin, 0.5, 1]).label_('f');
Twister.view.front;


/////////////////////////////////////////////////////////////////////
// pattern
/////////////////////////////////////////////////////////////////////
(
Pdef(\s1,

    's1/ptrn/out'.out
    <> Pbind(
        \instrument, \s1,
        \degree, [0, 1, 2, 4].pseq,
        \mtranspose, Twister.knobs(9).asPfunc,
        \amp, -6.dbamp,
        \dec, 0.1,
        \suslevel, Twister.knobs(7).asMap,
        \rel, Twister.knobs(5).asMap,
        \frel, Twister.knobs(8).asMap,
        \cutoff, Twister.knobs(3).asMap, //2200,
        \fvel, Twister.knobs(12).asMap,
        \legato, Twister.knobs(10).asPfunc,
        \res, Twister.knobs(4).asMap, //0.5,
        \dur, 0.25,
        \root, 2,
        \scale, Scale.ritusen,
        \k, Twister.knobs(11).asPfunc,
        \octave, Pbjorklund(Pkey(\k), 8, inf).linlin(0, 1, 4, 5), // Pmap(5, 8, 4, 5), // + Prand([0, 1, -1], inf),
        \vel, Pmap(3, 8, 0.5, 1),
        //\harmonic, [1, 1.5]
    )
)
)

Pdef(\s1).play;
Pdef(\s1).stop;

/////////////////////////////////////////////////////////////////////
// map
/////////////////////////////////////////////////////////////////////
Ndef('s1/ptrn/out').map(\size, Twister.knobs(0).asMap);
Ndef('s1/ptrn/out').map(\ps, Twister.knobs(1).asMap);
Ndef('s1/ptrn/out').map(\fblevel, Twister.knobs(2).asMap);
Ndef('s1/ptrn/out').map(\delcutoff, Twister.knobs(6).asMap);


M.wxu.addSrc(Ndef('s1/ptrn/out'));
M.wxu.view;


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

    sig = RLPF.ar(sig, 2000, 0.2);
    sig = LeakDC.ar(sig);

    sig = sig * aeg * AmpCompA.kr(freq) * \amp.kr(-6.dbamp) * \vel.kr(1);
    sig = Pan2.ar(sig, \pan.kr(0));
    Out.ar(\out.kr(0), sig);
}).add
)


(
Ndef('s2/out').filter(100, {|in|
    var sig = in;
   // sig = PitchShift.ar(sig, 2, 1.5, 0.01, 0.01) * \ps.kr(0.5) + sig;
    sig = FbC({|fb|
        LPF.ar(fb.reverse, \delcutoff.kr(2200)) * \fblevel.kr(0.6) + sig
    }, 1, [3/8, 4/8]); //* 0.4 + sig;
    //sig = JPverb.ar(sig, 5, 0, 5) * 0.4 + sig;
    sig;
}).set(\wet100, 0.6);
)

~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
~buf = ~texture.values.choose

(
//~buf = ~texture.values.choose;
Pdef(\s2,

    's2/out'.out
    <> Pbind(
        \instrument, \s2,
        \buf, ~buf,
        \amp, -6.dbamp,
        \degree, 0, //[0, 2, 3], //Pwhite(0, 4),
        \scale, Scale.zhi,
        \root, 2,
        \octave, Pmap(3, 8, 4, 5),
        \harmonic, [1, 1.5],
        \dur, 1,
        \atk, 0.01,
        \rel, 0.1,
        \start, Pwhite(0.1, 0.5),
        \vel, 1
    )
)
)

Pdef(\s2).play;
Pdef(\s2).stop;

Ndef('s2/out').play;

M.wxu.addSrc(Ndef('s2/out'));
M.wxu.addSrc(Ndef('s1/ptrn/out'));
M.wxu.view;


Twister.knobs(13).cc([-90, 1, \lin, 0, -39]).label_('kneepointL');
(
Ndef(\satan_1111).set(
    \kneepointL, Twister.knobs(13).asMap,
    \kneepointR, Twister.knobs(14).asMap
)
)


Ndef(\res_1326).set(\f, Twister.knobs(15).asMap);

