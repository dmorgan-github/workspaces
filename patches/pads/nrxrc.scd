W.transport;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
~nrxrc = S();
~nrxrc.synth({|freq|
    var sig = SinOsc.ar(freq);
    sig;
});

~nrxrc.fx(10, {|in|

    var sig;
    var dec, filt, rev;

    sig = in;

    filt = {|in|
        RLPF.ar(in, \cutoff.kr(2000, spec:[200, 4000, \lin, 0, 2000]), 0.5);
    };

    rev = {|in|
        var sig = FbC({|fb|
            AllpassC.ar(PitchShift.ar(fb.reverse, 2, 2), 0.2, 0.2, 1) * 0.5 + in;
        });
        JPverb.ar(sig, 5, 0, 5, modDepth: 0.5);
    };

    sig = sig.blend(filt.(sig), 1);
    sig = sig.blend(rev.(sig), 0.6);

    sig;

});

~nrxrc.fx(20, 'vst/++decimate');

~nrxrc << [
    degree: Pwhite(0, 5),
    octave: 4,
    harmonic: [1, 1.5],
    dur: 4,
    atk: 2,
    rel: 8,
    vel: 0.8,

    decimate_color: 0,
    decimate_depth: 0.65512388944626,
    decimate_folding: 0.24373896002769,
    decimate_ingain: 0.5,
    decimate_outgain: 0.5,
    wet20: 0.5
].p;

~nrxrc.play;
~nrxrc.stop;
~nrxrc.vstctrls[20].editor;


