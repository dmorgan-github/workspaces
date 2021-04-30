W.transport
s.meter

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
D.xdvv.play;
D.xdvv.stop;

(
D.xdvv.fx(200, {|in|
    var sig = in;
    sig = sig.blend(FbC({|fb| PitchShift.ar(fb.reverse, 2, 1.5, 0.01, 0.01) * 0.5 + sig}, 1, 3/4), 0.5);
    sig;
});
)

D.xdvv.vst(205, 'Raum');
~xdvv_raum.editor;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
B.mono(\freesound, "/Users/david/Documents/supercollider/media/freesound/93669__juskiddink__janie-joelle-djm800.wav");

(D.eobgt[0] = {

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

D.eobgt.set(\buf, B.freesound);
D.eobgt.set(\freq, 20, \graindur, 0.1, \speed, 0.5, \rev, 0.5, \posrand, 0.00, \startPos, 0.2, \endPos, 0.3);
D.eobgt.play;
D.eobgt.stop;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////g////////////////////////////

(
[
    0 -> {
        D.xdvv.play(fadeTime:4)
    },

    32 -> {
        D.eobgt.play(fadeTime:4)
    },

    96 -> {
        D.xdvv.stop(fadeTime:8);
        D.eobgt.stop(fadeTime:16);
    }
].playTimeline(TempoClock.default);
)

