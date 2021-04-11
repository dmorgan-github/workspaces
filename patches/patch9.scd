
W.transport;
W.recdir;

~bufs = B.dirMono("/Users/david/Documents/supercollider/workspaces/patches");

~jfe = O();
~jfe.set(\buf, ~bufs.values.choose.postln);

(
~jfe.filter(100, {|in|

    var sig = in;
    var dist, rev, tape;

    dist = {|in|

        var sig = AnalogVintageDistortion.ar(in,
            drivegain: \drivegain.kr(0.85, spec:[0, 1, \lin, 0, 0.5]),
            bias: \bias.kr(0),
            lowgain:\lowgain.kr(-20.dbamp),
            highgain:\highgain.kr(-20.dbamp),
            shelvingfreq:\shelvingfreq.kr(600),
            oversample:1);
        sig = DCompressor.ar(sig, ratio:\compressratio.kr(10));
        sig = Limiter.ar(sig);
        sig = sig * 0.1;
        sig;
    };

    rev = {|in|
        JPverb.ar(in, 5, 0, 3);
    };

    tape = {|in|
        AnalogTape.ar(in,
            saturation:\sat.kr(0.5),
            drive: \tapedrive.kr(0.5)
        );
    };

    sig = sig.blend(dist.(in), 0.3);
    sig = sig.blend(rev.(sig), 0.4);
    sig = sig.blend(tape.(sig), 1);
    sig;
})
.addSpec(\drivegain, [0, 1, \lin, 0, 0.5])
.addSpec(\bias, [0, 2.5, \lin, 0, 0])
.addSpec(\lowgain, [0.0001, 1, \lin, 0, 0.1])
.addSpec(\highgain, [0.0001, 1, \lin, 0, 0.1])
.addSpec(\shelvingfreq, [20, 20000, \lin, 0, 600])
.addSpec(\sat, [0, 2, \lin, 0, 0.5])
.addSpec(\tapedrive, [0, 2, \lin, 0, 0.5])
.addSpec(\compressratio, [1, 40, \lin, 0, 4])
)

~jfe.set(\rate, 1);
~jfe.set(\amp, 10.dbamp);
~jfe.phase = {|dur, freq| (LFTri.ar(freq * 0.5, -1) * 1.5).fold(-1, 1) };

~jfe.play(fadeTime:8);
~jfe.stop(fadeTime:0);

~jfe.view;
~jfe.gui;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
(
[
    0 -> {
        ~jfe.play(fadeTime:8);
    },
    128 -> {
        ~jfe.stop(fadeTime:8);
    }
].playTimeline(TempoClock.default);
)

