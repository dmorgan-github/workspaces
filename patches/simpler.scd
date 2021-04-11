
~buf2 = Buffer.read(s, Platform.resourceDir +/+ 'sounds/a11wlk01.wav');
~buf = Buffer.read(s, "/Users/david/Documents/supercollider/media/1channel/kalimba.aiff");
~buf3 = Buffer.read(s, "/Users/david/Documents/supercollider/media/1channel/apollo-lift-vector-issue2.wav");
~buf4 = Buffer.read(s, "/Users/david/Documents/supercollider/media/1channel/piano.mono.aiff");
~buf2.numChannels;




(
Pdef(\p, Pbind(*[
	instrument: \simpler
	,buf: ~buf
	,octave: Prand([3,4,5],inf)
	,degree: Pn(Plazy({Pseq([-4,0,5,7,9,12].scramble.clump(2),2)}))
	,dur: 0.5
	,strum: Prand([0, 0.125, 0.25], inf)
	,strumEndsTogether: false
	,loopStart: Pwhite(90000, 150000)
	,sampleStart: Pwhite(50000, 85000)
	,loopLen: 0.4
	,fadeTime: 0.15
	,attack: 0.25
	,release: 4
    ,amp: -6.dbamp
])).play;
)

Pdef(\p).stop;

(
Pdef(\p2, Pbind(*[
	instrument: \simpler
	,buf: ~buf4
	,octave: Prand([3,4,5],inf)
	,degree: Pn(Plazy({Pseq([-4,0,5,7,9,12].scramble.clump(2),2)}))
	,dur: 2
	,strum: Prand([0, 0.125, 0.25], inf)
	,strumEndsTogether: false
	,loopStart: Pwhite(90000, 150000)
	,sampleStart: Pwhite(50000, 85000)
	,loopLen: 0.4
	,fadeTime: 0.15
	,attack: 0.25
	,release: 4
])).play;
)

Pdef(\p2).stop;


(
Pdef(\p2, Pbind(*[
	instrument: \simpler
	,buf: ~buf3
	,octave: 5 //Prand([3,4,5],inf)
	,degree: 0 //Pn(Plazy({Pseq([-4,0,5,7,9,12].scramble.clump(2),2)}))
	,dur: 2
	,strum: 0 //Prand([0, 0.125, 0.25], inf)
	,strumEndsTogether: false
	,loopStart: Pwhite(90000, 150000)
	,sampleStart: Pwhite(50000, 85000)
	,loopLen: 0.4
	,fadeTime: 0.15
	,attack: 0.25
	,release: 4
])).play;
)