/*
Wahwah con autowah

Efecto de wahwah simple, con un filtro pasabandas resonante.
Incluye una distorsion leve como muchos pedales de wahwah.
Se le agrego un control automatico en base al nivel de la señal entrante (autowah), al encenderlo deshabilita el "pedal".

Con dry/wet se puede mezclar la señal original y la procesada.

Puede que para distintos timbres e instrumentos haya que ajustar los valores de frecuencias, gain y Q del filtro!

|| Juan Ramos 2023 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

frec = hslider("Frecuencia reson [scale:log]", 500, 250, 1500, 0.001) : si.smoo;
autowah = checkbox("Autowah");

pedal = hslider("Pedal wah", 0.2, 0, 1, 0.0001)*1000+250 : si.smoo;
gain = hslider("Ganancia", 2, 0, 6, 0.001) : si.smoo;
auto(in) = in, (in*2 : an.amp_follower(0.1)^1 * 1000+150);
drywet = hslider("Dry/wet", 0.7, 0, 1, 0.001) : si.smoo;
filtro(in, val) = in : fi.resonbp(val*autowah + pedal*(1-autowah), 2, 9)*0.33 : fi.highpass(1, 100);

wah(in) = (auto(in) : filtro*sin(drywet*ma.PI*0.5) + in*cos(drywet*ma.PI*0.5) )*gain : ma.tanh * 0.9;

process(l, r) = wah(l) <: _, _;