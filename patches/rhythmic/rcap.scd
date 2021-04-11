W.transport;

/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////

~rcap = S();
~rcap.synth(\modal);
~rcap.fx(10, 'delay/fb');
~rcap.fx(20, {|in| PitchShift.ar(in, 2, 2, 0.01, 0.01); });
~rcap.set(
    \amp, -6.dbamp,
    \wet10, 0.6,
    \wet20, 0.6,
);

'rcap/1'.p << [
    \degree, [0, -1, 2, -2].pseq,
    \mtranspose, [0, 0, 0, 2, 4].pseq,
    \octave, Pmap(3, 8, 5, 6) - 1,
    \dur, 0.25
].p;
~rcap << 'rcap/1'.p;
~rcap << 'rcap/1'.p.s(\harmonic, [1, 1.5]).s(\amp, -16.dbamp);

~rcap.play;
~rcap.stop;


