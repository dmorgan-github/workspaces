W.transport;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~hain = B.dirMono("/Users/david/Documents/supercollider/media/Hainbach - Isolation Loops (soundpack)");
~buf2 = B.readMono("/Users/david/Documents/supercollider/workspaces/patches/SC_210326_215558-6db.WAV");

~ikhh = O();
~ikhh.set(\buf, ~hain.values.choose);
~ikhh.set(\rate, 0.5);
~ikhh.phase = {|dur freq| (LFTri.ar(freq * 0.25) * 1.5).fold(-1, 1).lag(1) };

(
~ikhh.filter(100, {|in|

    var sig = in;
    var del, ps, comp;

    del = {|in|
        AllpassC.ar(in, 0.2, 0.2, 3);
    };

    ps = {|in|
        PitchShift.ar(in, 2, 2, 0.01, 0.01);
    };

    comp = {|in|
        DCompressor.ar(in);
    };

    sig = sig.blend(comp.(sig), 1);
    sig = sig.blend(del.(sig), 0.5);
    sig = sig.blend(ps.(sig), 0.7);

    Splay.ar(sig, SinOsc.ar(1/13).range(0.1, 0.5));

});
)

~ikhh.play(fadeTime:4);
~ikhh.stop(fadeTime:8);
~ikhh.view;



