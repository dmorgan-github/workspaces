S.loadSynths;
S.printSynths;

W.transport;
W.recdir;

Q.start;
Q.view;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~hain = B.dirMono("/Users/david/Documents/supercollider/media/Hainbach - Isolation Loops (soundpack)");
~hain.values
~buf2 = B.readMono("/Users/david/Documents/supercollider/workspaces/patches/SC_210326_215558-6db.WAV");

~ikhh = O();
~ikhh.set(\buf, ~buf2);
~ikhh.set(\rate, 0.8);
~ikhh.phase = {|dur freq| (LFTri.ar(freq * [0.25, 0.125]) * 1.5).fold(-1, 1).lag(1) };

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

    sig = sig.blend(del.(sig), 0.5);
    sig = sig.blend(comp.(sig), 1);
    sig = sig.blend(ps.(sig), 0.7);

    Splay.ar(sig, SinOsc.ar(1/13).range(0.1, 0.5));

});
)

~ikhh.play(fadeTime:4);
~ikhh.stop(fadeTime:8);
~ikhh.view;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~buf = B.readMono("/Users/david/Documents/supercollider/workspaces/patches/SC_210314_080631-6db.WAV");

O.dei.set(\buf, ~buf);
O.dei.set(\rate, 0.5);

(
O.dei.filter(100, {|in|
    var sig = in;
    var del, ps;

    del = {|in|
        FbC({|fb|
            fb.reverse * 0.4 + in
        }, 1, [3/8, 4/8]);
    };

    ps = {|in|
        PitchShift.ar(in, 2, 2, 0.01, 0.01);
    };

    sig = sig.blend(del.(sig), 0.4);
    sig = sig.blend(ps.(sig), 0.3);
    sig
})
)

O.dei.vol = 0.3;
O.dei.play;
O.dei.stop;
O.dei.view;


/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
~buf = B.readMono("/Users/david/Documents/supercollider/workspaces/patches/SC_210326_215558-6db.WAV");
~buf.duration;

~buf = B.readMono("/Users/david/Documents/supercollider/workspaces/patches/clip.wav");

Ndef('patch8/b/fx').play;
Ndef('patch8/b/fx').vst(100, 'ValhallaSupermassive');
~patch8_b_fx_valhallasupermassive.editor;

(
Pdef('patch8/b',

    Pchannel('patch8/b/fx')
    <> Pbind(
        \dir, [-1, 1].prand,
        \start, Plazy({|evt|
            var slices = evt[\slices];
            Prand(slices, inf)
        }),
        \amp, -3.dbamp
    )
    <> Pdef(\slicer)
    <> Pbind(\buf, ~buf, \beats, 8)
);
)
Pdef('patch8/b').play(quant:1.0);
Pdef('patch8/b').stop;

