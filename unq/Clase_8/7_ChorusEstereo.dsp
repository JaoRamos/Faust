/*
Efecto de Chorus ESTEREO simple

Partiendo del Chorus MONO, generamos el efecto en ambos canales, pero a uno (R)
le invertimos la fase del oscilador. El resultado es que la "desafinación" queda
invertida en R respecto de L, cuando uno está al máximo, el otro al mínimo.
Es crudo pero efectivo...! Un chorus estereo más sofisticado podría tener voces
independientes con parámetros distintos... veremos eso en el siguiente ejemplo.

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

rate = hslider("Rate (Hz) [scale:exp]", 1, 0.01, 20, 0.01);
mix = hslider("Dry/Wet %", 50, 0, 100, 1) / 100;
tiempoMax = ma.SR * hslider("Tiempo máximo (ms) [scale:exp]", 2, 0.01, 20, 0.01)  / 1000; // ms
corteAgudos = hslider("Corte agudos (Hz) [scale:exp]", 8000, 100, 20000, 100);
 
// Generamos la envolvente senoidal para el tiempo de delay
// Icorporamos el parámetro inversor de fase (1 o -1)
delayVariante(fase) = (fase * os.osc(rate) * 0.5 + 0.5) * tiempoMax;

// Al usar un parámetro (x) podemos generar "copias" de la señal ingresante,
// que luego podemos dirigir a diferentes secciones.
chorus(x, fase) = x * (1-mix) +                                       // señal original
            ((x : de.fdelay(tiempoMax, delayVariante(fase)) * mix) :  // delay variable
            fi.lowpass(1, corteAgudos));                              // filtro

inversor = (checkbox("Bypass estereo!") * 2) - 1;
// Acá está la clave de la inversión de fase: si ambos canales tienen la misma fase,
// no habrá efecto estereo, sonarán iguales (mono), por eso también le podemos llamar
// "bypass" al inversor del canal derecho. Al izquierdo le damos fase *1 (sin cambios).
// Ponemos (x) en process, porque necesitamos copiar la entrada L a ambos chorus
process(x) = chorus(x, 1), chorus(x, inversor);
