/*
Efecto de Flanger estereo simple.

El flanger mas elemental se compone de un filtro comb (peine) modulado aplicado a una
señal. Tradicionalmente se lo obtiene sumando al original, una copia retrasada en el
tiempo. Esto produce una serie de valles en el espectro, cuyas posiciones guardan una
relación armónica. Es habitual que estas posiciones sean moduladas por un LFO.

Aquí tenemos un ejemplo rudimentario de flanger estereo, mediante una sencilla modulación
del tiempo de retardo (en samples, realmente) mencionado.

Mas info en: https://en.wikipedia.org/wiki/Flanging

|| Juan Ramos 2021 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

retardo = vslider("Retardo", 20, 10, 100, 0.01) + (rango*lfo);
rate = vslider("Rate LFO", 0.3, 0.1, 5, 0.01);
est = vslider("Estereo", 40, 0, 100, 1);
feedback = vslider("Feedback", 0.5, 0, 0.99, 0.01);
depth = vslider("Profundidad", 0.75, 0.0, 1.0, 0.01);
rango = vslider("Rango retardo", 15, 10, 100, 0.01);

master = vslider("Volumen", 0.8, 0.0, 1.5, 0.01);

// se pueden usar otros osciladores como LFO
lfo = (os.osc(rate) + 1)*0.5;

flanger(in, del, est, feedb, depth) = ((@(del + est))
                                        ~ (in + *(feedb))   // bardo
                                       ) *(depth) + in;

process(in) = hgroup("Super flanger", flanger(in, retardo, 0, feedback, depth)*master,
                                      flanger(in, retardo, est, feedback, depth)*master);