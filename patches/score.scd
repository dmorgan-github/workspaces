W.transport;

(
[
    0 -> {
        \a.postln;
        ~evr.play;
    },

    32 -> {
        \b.postln;
        ~nrxrc.play;
    },

    48 -> {
        \c.postln;
        ~ikhh.play(fadeTime:4);
    },

    64 -> {
        \d.postln;
        ~bcyn.play;
    },

    128 -> {
        ~evr.stop;
        ~nrxrc.stop;
    },

    136 -> {
        ~ikhh.stop;
        ~bcyn.stop;
    }

].playTimeline(TempoClock.default)
)

