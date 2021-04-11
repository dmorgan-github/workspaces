/////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////
(
~mono = {|path|
	Buffer.readChannel(Server.default, path, channels:[0], action:{arg buf;
		"added buffer: %".format(path).inform;
	});
}
)

/////////////////////////////////////////////////////////////////////
// foley sounds
/////////////////////////////////////////////////////////////////////
~g = B.dirMono("/Users/david/Documents/supercollider/media/Glitch With Friends/Foley/Recorded Foley");
~bartok = ~mono.("/Users/david/Documents/supercollider/workspaces/uicj/bartok5.aiff");
~found = B.dirMono("/Users/david/Documents/supercollider/media/Found Sounds Vol 1/One Shots");
~volca = B.dirMono("/Users/david/Douments/supercollider/media/1channel/drums/volcabeats/*");
~yeah = ~mono.("/Users/david/Documents/supercollider/media/1channel/vox/oh-yeah-man-they-definitely-feel-it.wav");


~bd = ~volca.values.select({|buf| buf.path.beginsWith("/Users/david/Documents/supercollider/media/1channel/drums/volcabeats/bd") })
~tom = ~volca.values.select({|buf| buf.path.beginsWith("/Users/david/Documents/supercollider/media/1channel/drums/volcabeats/tom") });
~ch = ~volca.values.select({|buf| buf.path.beginsWith("/Users/david/Documents/supercollider/media/1channel/drums/volcabeats/ch") });
~sd = ~volca.values.select({|buf| buf.path.beginsWith("/Users/david/Documents/supercollider/media/1channel/drums/volcabeats/sd") });

~jogging = B.dirMono("/Users/david/Documents/supercollider/media/Jogging House - Reel Feels (Sound Pack)");
~hain = B.dirMono("/Users/david/Documents/supercollider/media/Hainbach - Isolation Loops (soundpack)");

~texture = B.dirMono("/Users/david/Documents/supercollider/media/Found Sounds Vol 1/Texture/");



~epiano = B.dirWt("/Users/david/Documents/supercollider/resources/AKWF/AKWF_epiano/");
