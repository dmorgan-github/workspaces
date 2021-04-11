(
L([
    \patch1 -> [
        Pbind(
            \valhallasupermassive_delay_ms, Pwhite(0.1, 0.8),
            \raum_mode, 1,
            \valhallasupermassive_wet, 0.25,
            \bubbler_wet, 0,
            \amp, -27.dbamp
        ) <> Pdef(\patch1),

        Pbind(
            \valhallasupermassive_delay_ms, Pwhite(0.1, 0.8),
            \raum_mode, 1,
            \valhallasupermassive_wet, 0.25,
            \bubbler_wet, 0.5,
            \amp, -27.dbamp
        ) <> Pdef(\patch1)
    ]
])
)