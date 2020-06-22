import("stdfaust.lib");
/*
Efecto de Delay ESTEREO de multiples taps
Para este efecto solo simplificaremos el funcionamiento del Chorus de voces multiples
(¡ver primero los ejemplos de chorus!)
Eliminaremos la modulacion y demas factores innecesarios
Y agregaremos un control de feedback

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

nTaps = 4;      // se puede cambiar... enteros mayores a 1

// Nuestra definicion de lo que es "un" tap del delay
// la variable "n" aqui sera el numero de tap, esto lo produce el par() en la definicion delay (mas abajo)
// usaremos esta variable para nombrar cada elemento y generar algo de variedad en los valores
unTap(entr, n) = hgroup("[%n] Tap %n", tap)
    with {
        tap = entr : eco * vol : sp.panner(pan);    // delay completo con filtros, pan y volumen
        eco = filtroHP : filtroLP : + @(tiempoDelay) ~ *(feedBack) ;   // eco con feedback y filtro

        // aprovecharemos la funcion sin() para generar variedad en los valores por defecto!!
        filtroLP = fi.lowpass(2, hslider("[1]Hi Cut[unit:Hz][style:knob][scale:exp]", int(abs(sin(n*5)) * 5000 + 5000),      100, 20000, 100));
        filtroHP = fi.highpass(2, hslider("[0]Lo Cut[unit:Hz][style:knob][scale:exp]", int(abs(sin(n*5)) * 50 + 10),        10, 20000, 10));
        vol = vslider("[5]Nivel[unit:%][style:knob]", int(abs(sin(n*10))*75 + 25),      0, 100, 1) / 100 : si.smoo;
        tiempoDelay = ma.SR * hslider("[2]Tiempo [unit:ms][style:knob]", int(20 + abs(sin(n*5))*500),     1, 1000, 1)  / 1000;
        feedBack = vslider("[3]Feedback [unit:%][style:knob]", int(abs(sin(n*10)) * 20),        0, 100, 1) / 100 : si.smoo;
        pan = vslider("[4]Pan[style:knob]", sin(n*5),        -1, 1, 0.01) * 0.5 + 0.5 : si.smoo;
        
    }; 

// Nuestra definicion del delay completo, suma de varios "taps" utilizando par(), que replica un elemento
// (en este caso "tap") en paralelo cierta cantidad de veces. par() nos generara una multitud de salidas estereo,
// una por cada elemento (tap) que contenga. En process deberemos unificar estos canales en L y R.
// La variable "n" en par() sera el numero de iteracion, en este caso, el numero de cada tap generado
delay(entrada, nTaps) = vgroup("Delay de %nTaps taps", par(n, nTaps, unTap(entrada, n+1)));

// controles
wet = vslider("[1]Wet [unit:%][scale:exp]", 20, 0, 200, 1) / 100 : si.smoo;
dry = vslider("[2]Dry [unit:%][scale:exp]", 80, 0, 200, 1) / 100 : si.smoo;
master = vslider("[3]Volumen [unit:%][scale:exp]", 100, 0, 200, 1) / 100 : si.smoo;

// aqui unificamos la multitud de canales estereo en solo un par L-R
process(entrada) = hgroup("Efecto delay estereo", delay(entrada, nTaps) :>   // bajamos a 2 canales
                        hgroup("Controles",
                        (_ : *(wet) : +(entrada*dry)) * master,
                        (_ : *(wet) : +(entrada*dry)) * master )
                    );