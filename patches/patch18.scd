W.transport
W.setParentEvent( (root: 0, scale:Scale.ritusen) );

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
S.iquau.synth(\modal);
S.iquau.play;
S.iquau.stop;
S.iquau.fx(200, 'vst/Raum', 0.5);
S.iquau.vstctrls[200].editor;
S.iquau << [amp: 0.15, dur:0.5, morph: 0, harm:1.5].p.octave(5)


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
S.fme.synth(\modal);
'fm3/1'.p << [ [1, \, 1, 1], \, [\, 1], 2 ].pdv.stretch(0.5).octave(Pmap(3, 8, 4, 5)).s(\harm, 0.75).amp(0.15)
S.fme << 'fm3/1'.p.s(\wet300, 0);
S.fme << 'fm3/1'.p.s(\wet300, 0.3);
S.fme.play;
S.fme.stop;
S.fme.fx(300, 'delay/fb', 0.3);

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

(
~compam = {|n, m ...p|
	var res= List.new;
	var parts= Array.newClear(n-1);
	var mp= m-1;
	var aparts= p;
	var allowed= {|p| aparts.includes(p)};
	var compose= {|n, p, m|
		if(n==0, {
			if(m==mp and:{allowed.(p)}, {
				res.add(parts.copyRange(0, m-1)++p);
			});
		}, {
			if(m<mp and:{allowed.(p)}, {
				parts[m]= p;
				compose.(n-1, 1, m+1);
			});
			compose.(n-1, p+1, m);
		});
	};
	compose.(n-1, 1, 0);
	res;
};
)

S.hrwa.synth(\modal);
(
S.hrwa << [
    //dur: ~compa.(8, 2, 4, 5, 6).collect(_.pseq(1)).pseq,
    dur: ~compam.(16, 5, 2, 3, 4).collect(_.pseq(1)).pseq,
    stretch: 0.125,
    octave: Pmap(3, 8, 5, 6),
    harm: 0.5,
    amp: 0.2,
    degree: [1, -1, 2, -2].pseq,
    mtranspose: [0, 0, 0, 1, 2].pseq
].p
)
S.hrwa.play;
S.hrwa.stop;
S.hrwa.fx(300, 'delay/fb', 0.3);

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
S.hh.play;
S.hh.stop;
S.hh << [dur:0.25].p

S.bd.play;
S.bd.stop;
S.bd << [amp:0.5].p

S.sd.play;
S.sd.stop;
S.sd << [lag:0.5, amp:0.1].p

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

(
S.ewoy.synth({|freq|
    var pw = \pw.kr(0.5);
    var ws = \ws.kr(0.5);
    var sync = \sync.kr(1);
    var sfreqratio = \sfreqratio.kr(1).linlin(0, 1, 1, 8);
    var focus = \focus.kr(0);
    //var sig = VarShapeOsc.ar(freq, pw, ws, sync, freq * sfreqratio);

    var sig = {
        var sig1 = SyncSaw.ar(freq, freq * sfreqratio);
        var sig2 = Pulse.ar(freq, pw);
        var sig3 = VarSaw.ar(freq, 0, pw);
        var sig = SelectXFocus.ar(ws, [sig1, sig2, sig3], focus);
        sig
    }.();

    var filt = LPF.ar(sig, \lpf.kr(0.5).linlin(0, 1, 100, 8000));
    filt = HPF.ar(filt, \hpf.kr(0).linlin(0, 1, 20, 220));

    sig = Balance.ar(filt, SinOsc.ar(freq));
    sig
})
)

S.ewoy.node.stop;
S.ewoy.node.play(fadeTime:4);
S.ewoy.play;
S.ewoy.stop;

(
S.ewoy << [
    degree: [0, 1, 3].pseq,
    octave: [3, 4],
    harmonic: [1, 1.5],
    mtranpose: [0, 0, 1, 2, -1, 0, 0].pseq,
    dur: 8,
    atk: 2,
    rel: 8,
    pw: 0.1,
    ws: 0.1,
    sync: 1,
    sfreqratio: 0.1,
    focus: 0.5,
    lpf: 0.2,
    wet200: 0.8,
    amp: 0.1 * 0.27
].p
)

S.ewoy.fx(200, 'vst/Raum', 0.4);
S.ewoy.vstctrls[200].editor;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
B.mono(\ghan, "/Users/david/Documents/supercollider/media/freesound/180448__klankbeeld__ghana-woman-sing-traditional-song-dec-1986-2-007-01.wav")

(D.xdvv[0] = {

    var buf = \buf.kr(0);
    var freq = \freq.kr(20);
    var density = Dust.ar(freq);
    var graindur = \graindur.kr(0.1);
    var pan = LFNoise2.kr(1);
    var grainamp = LFNoise2.kr(1).range(0.5, 1);
    var pitch = [1, 1.5];
    var center = {
        var sr = SampleRate.ir;
        var phase;
        var start = \startPos.kr(0) * BufFrames.kr(buf);
        var end = \endPos.kr(1) * BufFrames.kr(buf);
        var posrand = \posrand.kr(0);
        var speed = \speed.kr(1) * BufRateScale.kr(buf);
        var rev = \rev.kr(0);
        rev = TWChoose.kr(density, [1, -1], [1-rev, rev], 0);
        phase = Phasor.ar(0, speed * rev, start, end) / sr;
        phase = phase + LFNoise1.kr(1).bipolar(posrand * sr);
        phase;
    };

    var sig = TGrains.ar(1,
        trigger: density,
        bufnum: buf,
        rate: pitch,
        centerPos: center.(),
        dur: graindur,
        pan: pan,
        amp: grainamp,
        interp:4
    );

    Splay.ar(sig.flatten) * \amp.kr(-6.dbamp);
})

D.xdvv.set(\buf, B.ghan);
D.xdvv.set(\freq, 20, \graindur, 0.1, \speed, 0.5, \rev, 0.5, \posrand, 0.00, \startPos, 0.2, \endPos, 0.3);
D.xdvv.set(\amp, 0.2);
D.xdvv.play(fadeTime:8);
D.xdvv.stop;

(
D.xdvv.fx(200, {|in|
    var sig = in;
    sig = sig.blend(FbC({|fb| PitchShift.ar(fb.reverse, 2, 1.5, 0.01, 0.01) * 0.5 + sig}, 1, 3/4), 0.5);
    sig;
});
)

D.xdvv.fx(205, 'vst/Raum');
~xdvv_raum.editor;


(
[
    0 -> {
        S.ewoy.node.stop;
        S.iquau.play;
    },

    12 -> {
        S.fme << 'fm3/1'.p.s(\wet300, 0);
        S.fme.play;
    },

    24 -> {
        S.fme << 'fm3/1'.p.s(\wet300, 0.3);
    },

    48 -> {
        S.hrwa.play;
    },

    96 -> {
        S.ewoy.node.play(fadeTime:6);
        S.ewoy.play;
    },

    128 -> {
        D.xdvv.play(fadeTime:8);
    },

    208 -> {
        S.ewoy.stop;
        S.iquau.stop;
    },

    216 -> {
        S.hrwa.stop;
        S.fme.stop;
    },

    225 -> {
        D.xdvv.stop;
    }

].playTimeline();
)


