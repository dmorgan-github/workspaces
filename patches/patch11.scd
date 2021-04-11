S.loadSynths;
S.printSynths;

W.transport;
W.recdir;

Event.addParentType(\note, (root:0, scale:Scale.ritusen));


~s1 = S();
~s1.synth(\modal);
~s1.play;
~s1.stop;
~s1 << "9..9..9.".probs.stretch(0.25).s(\degree, [0, 1, 2].pseq.norest).s(\harm, 0.5);

~s2 = S();
~s2.synth(\modal);


(
~s2.fx(10, {|in|
    var sig = in;
    var fb = LocalIn.ar(2);
    sig = DelayC.ar(fb.reverse, 4, [\delL.kr(3/4), \delR.kr(4/4)]);
    sig = sig * \fb.kr(0.8) + in;
    sig = LeakDC.ar(sig);
    LocalOut.ar(sig);
    sig
}, 0.3);
~s2.fx(20, {|in|
    PitchShift.ar(in, 2, 2, 0.01, 0.01)
}, 0.6);
)
~s2.play;
~s2.stop;
~s2 << "9..9..8...".probs.stretch(0.25).s(\degree, [3, 2, 1].pseq.norest).s(\harm, 0.5).s(\octave, 5).s(\harmonic, [1, 1.5]).s(\vel, [1, 0.8]);

'ppar1/'.p << (Pdef(\t1_filter) <> [~s1.s(\foo, Pif(Pfunc({|evt| evt.isRest}), 0, 1)), ~s2.s(\amp, -3.dbamp)].ppar);
'ppar1/'.p.play;
'ppar1/'.p.stop;

(
{
	var toMerge = List();
	var mergeFunc = {arg events;
		//events.detect({arg e; e[\foo] == 1})
		var event = events.detect({arg e; e[\foo] == 1});
		if (event.isNil.not) {
			event;
		} {
			event = events.detect({arg e; e[\foo] == 2});
			if (event.isNil.not) {
				event;
			}{
				events.choose;
			}
		}
	};

	Pdef(\t1_filter, Pfunc({arg event;

		// collect parallel events
		if (event[\delta] < 0.000001) {
			toMerge.add(event);
			// replace current event with silence
			event = Event.silent(event[\delta], event);
		} {
			// last parallel event will have non-zero delta
			if (toMerge.size > 0) {
				// add event to accumulation
				toMerge.add(event);
				// call logic to create merged event
				event = mergeFunc.(toMerge).put(\delta, event[\delta]);
				// start all over
				toMerge.clear();
			}
		};
		event;
	}));
}.();

)