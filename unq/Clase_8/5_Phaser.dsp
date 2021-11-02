/*
Efecto de Phaser estereo simple.

El phaser mas elemental se compone de un filtro all-pass (pasa todo), que (en teoria) no
modifica la amplitud de las frecuencias (a diferencia de los demas filtros), pero cambia
las relaciones de FASE de estas frecuencias. Si luego sumamos su resultado con la señal
original, produciremos cancelaciones y todo tipo de efectos de fase en distintas partes
del espectro. Finalmente, si incorporamos una modulación en el parametro de retardo del
filtro all-pass, haremos que estas cancelaciones cambien constantemente, produciendo
el efecto que conocemos como PHASER.

Aquí tenemos un ejemplo de un phaser de 5 etapas, pero en dos canales independientes
para tener un pseudo phaser estereo. Simplemente reusamos la misma definicion y le ponemos
una pequeña diferencia de frecuencia en el canal derecho.
Mas info en: https://en.wikipedia.org/wiki/Phaser_(effect)

|| Juan Ramos 2021 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

frecuencia = vslider("Frec minima", 100, 50, 10000, 0.01) + (rango*lfo);
rate = vslider("Rate LFO", 0.3, 0.1, 5, 0.01);
est = vslider("Estereo", 75, 0, 100, 1)*6;
feedback = vslider("Feedback", 0.5, 0, 0.9, 0.01);
depth = vslider("Profundidad", 1.0, 0.0, 1.0, 0.01);
rango = vslider("Rango frec", 300, 100, 2000, 0.01);
//q = vslider("Q de filtros", 1, 0.5, 5, 0.01);
q = 1;

// se pueden usar otros osciladores como LFO
lfo = (os.osc(rate) + 1)*0.5;

phaser(in, f, det, feedb, depth, q) = (
                                        (wa.allpass2(f*1.0, q, det) :
                                         wa.allpass2(f*2.3, q, det) :
                                         wa.allpass2(f*3.7, q, det) :
                                         wa.allpass2(f*5.0, q, det) :
                                         wa.allpass2(f*6.3, q, det) )
                                        ~ (in + *(feedb))   // bardo
                                       ) *(depth) + in;
//in = no.noise;
process(in) = hgroup("Super phaser", phaser(in, frecuencia, 0.0, feedback, depth, q),
                                     phaser(in, frecuencia, est, feedback, depth, q));