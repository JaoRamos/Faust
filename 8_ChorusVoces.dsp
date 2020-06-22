import("stdfaust.lib");
/*
Efecto de Chorus ESTEREO de multiples voces
Este efecto es mas complejo: definiremos un "coro" compuesto de "voces".
Cada voz será aproximadamente lo mismo que el chorus mono, pero con parámetros
que nos permitirán replicarla muchas veces y asignarle un valor de Paneo.

Utilizaremos la expresión with{...}, que nos permite especificar un ámbito
particular para alguna definición. Por lo general esto lo hacíamos por fuera,
pero para que cada voz tenga su propio grupo de parámetros es necesario with{}
*/

nVoces = 8;	// se puede cambiar... enteros mayores a 1

unaVoz(entr, j) = vgroup("[%j] Voz %j", voz)
    with {
        voz = entr : de.fdelay(tiempoMax, delayVariable) * vol : sp.panner(pan);

        // aprovecharemos la funcion sin() para generar variedad en los valores por defecto!!
        vol = vslider("[2]Nivel[style:knob]", abs(sin(j*10)) / 2 + 0.25, 0, 1, 0.01) : si.smoo;
        tiempoMax = ma.SR * hslider("[1]Tiempo (ms) [scale:exp][style:knob]", 0.2 + abs(sin(j*5)*2), 0.01, 20, 0.01)  / 1000;
        rate = vslider("[0]Rate (Hz) [scale:exp] [style:knob]", 0.2 + abs(sin(j*10)), 0.1, 10, 0.1) : si.smoo;
        pan = vslider("[3]Pan[style:knob]", sin(j*5), -1, 1, 0.01) * 0.5 + 0.5 : si.smoo;
        delayVariable = (os.osc(rate) * 0.5 + 1) * tiempoMax;
    };

coro(audioIn, nVoces) = hgroup("Chorus de %nVoces voces", par(i, nVoces, unaVoz(audioIn, i+1)));

corteAgudos = fi.lowpass(1, vslider("[0]HiCut (Hz) [scale:exp]", 8000, 100, 20000, 100) : si.smoo);
wet = vslider("[1]Wet % [scale:exp]", 50, 0, 200, 1) / 100 : si.smoo;
dry = vslider("[2]Dry % [scale:exp]", 50, 0, 200, 1) / 100 : si.smoo;
master = vslider("[3]Volumen % [scale:exp]", 100, 0, 200, 1) / 100 : si.smoo;

process(entrada) = hgroup("Efecto chorus", coro(entrada, nVoces) :>                 // bajamos a 2 canales
                        hgroup("Controles",
                        (_ : corteAgudos : *(wet) : +(entrada*dry)) * master,
                        (_ : corteAgudos : *(wet) : +(entrada*dry)) * master )
                    );