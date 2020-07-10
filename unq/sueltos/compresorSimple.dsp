/*
Ejemplo de compresor/limitador MONO parametrizable

El funcionamiento elemental de este compresor se basa en hacer un analisis de
la amplitud de la señal ingresante, aplicando un pequeño retardo, para poder
determinar un nivel de reduccion de ganancia segun los parametros elegidos
por el usuario. Esta basado en "compressor_lad_mono" de las librerias de Faust.
https://github.com/grame-cncm/faustlibraries/blob/master/compressors.lib

Como es algo complejo su funcionamiento, esta organizado en un solo bloque
muy comentado, que se puede "copiar y pegar" en otro proyecto directamente.

Los controles son opcionales segun cada caso, no es necesario ofrecer todos
los sliders siempre al usuario, algunos valores se pueden fijar en codigo.

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

// comienzo del codigo del compresor ----------------------------------------
compresorSimple(lad, rat, thr, att, rel, preGain, postGain, entrada) =
                    entrada * ba.db2linear(preGain) @ max(0, floor(0.5 + ma.SR * lad))
                    * compGain(rat, thr, att, rel, entrada * ba.db2linear(preGain))
                    * ba.db2linear(postGain)
/*
lad:  look ahead delay, necesario para analizar y aplicar el cambio de gain
rat:  ratio de compresion x:1
thr:  threshold, umbral **en dB** (normalmente es un numero negativo)
att/rel:  attack y release en SEGUNDOS (ojo la conversion a ms !)
pre/postGain:  gain **en dB** antes y despues de la compresion
entrada:  señal de entrada a comprimir. Si se deja vacio, Faust usa la señal
          que llegue desde el elemento anterior, o una entrada de audio.
*/

// En un with{..} analizamos y calculamos el gain para reducir la señal
    with {
        // todo este bloque se encarga de analizar la señal para obtener un
        // valor de reduccion del gain, segun los parametros del usuario
        compGain(rat, thr, att, rel) =
                an.amp_follower_ar(att, rel) :
                ba.linear2db : outminusindb(rat, thr) :
                kneesmooth(att) : ba.db2linear;

        // kneesmooth(att) installs a "knee" in the dynamic-range compression,
        // where knee smoothness is set equal to half that of the compression-attack.
        // A general 'knee' parameter could be used instead of tying it to att/2:
        kneesmooth(att) = si.smooth(ba.tau2pole(att/2.0));
        // compression gain in dB:
        // level esta implicito y es el valor "conectado" desde ba.linear2db
        outminusindb(rat, thr, level) = max(level-thr,0.0)
                                        * (1.0/max(ma.EPSILON, float(rat))-1.0);
    };
// fin del codigo del compresor ----------------------------------------------


// Controles, todo esto es personalizable segun la necesidad particular
// Algunos sliders pueden eliminarse, y dejar numeros fijos en el compresor
ampl = hslider("[0]Pre gain (dB)", 0, -18, 18, 0.1);
makeup =  hslider("[5]Post gain (dB)", 0, -18, 18, 0.1);
thresh = hslider("[1]Threshold (dB)", 0, -80, 0, 1);
ataque = hslider("[2]Ataque (ms) [scale:exp]", 5, 0.1, 500, 0.1) / 1000;
release = hslider("[3]Release (ms) [scale:exp]", 100, 0.1, 500, 0.1) / 1000;
ratio = hslider("[4]Ratio X:1 [scale:exp]", 3, 1, 50, 0.1);
// Conviene elegir un valor fijo de Look Ahead y dejarlo ahi...
// Ni siquiera deberia ofrecerse al usuario como slider!
laDel = hslider("[6]Look ahead (ms) [scale:exp]", 1, 0.1, 20, 0.1) / 1000;


// lo duplicamos para hacerlo estereo, pero usando los mismos parametros
// en caso de usar una entrada de audio (no un wav estereo), no necesitamos duplicar
process = compresorSimple(laDel, ratio, thresh, ataque, release, ampl, makeup),
          compresorSimple(laDel, ratio, thresh, ataque, release, ampl, makeup);