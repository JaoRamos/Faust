/*
Efecto de Chorus MONO de una voz

Basicamente generamos un delay con tiempo variable, lo que cambiará el pich/afinación
de la señal. La variación la realizamos con un oscilador senoidal, aunque podríamos
usar otras formas de onda para distintos colores de chorus. Luego añadimos la señal
original a la modificada e incorporamos un filtro de agudos (pasabajos...).

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

// controles
rate = hslider("Rate (Hz) [scale:exp]", 0.5, 0.1, 20, 0.1);
mix = hslider("Dry/Wet %", 40, 0, 100, 1) / 100;
tiempo = ma.SR * hslider("Tiempo (ms) [scale:exp]", 6, 0.1, 20, 0.1)  / 1000; // ms
corteAgudos = hslider("Corte agudos (Hz) [scale:exp]", 5000, 1000, 20000, 100);

// Generamos la envolvente senoidal para el tiempo de delay
delayVariante = (os.osc(rate)*0.5 + 0.5) * tiempo;

// Al usar un parámetro (x) podemos generar "copias" de la señal ingresante,
// que luego podemos dirigir a diferentes secciones.
chorus(x) = x * (1-mix) +                                       // señal original
            ((x : de.fdelay(tiempo, delayVariante) * mix) :     // señal con delay variable
            fi.lowpass(1, corteAgudos));                        // filtro

// "x" representara a la primera entrada (puede tener cualquier nombre, no solo x)
process(x) = chorus(x) <: _, _;
