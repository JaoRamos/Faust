/*
Conmutador y selectores de opciones (interfaz grafica)

Teniendo un panel de opciones (o cualquier numero en realidad) podemos crear un conmutador entre
DOS o TRES señales utilizando la primitiva select2(x, señal1, señal2).
Si x vale 0, se utilizara la primer señal, si vale 1 la segunda señal.

Tenemos otro selector llamado select3, exactamente igual a select2 pero con 3 señales conmutables.
select3(x, señal1, señal2, señal3)

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");
// cuidado con los valores que ponemos de inicio/minimo/maximo/paso en el slider
// necesitamos configurar el "slider" para que SOLO nos devuelva 0 - 1  (0 - 1 - 2 para select3)
formaOnda = vslider("Forma de onda[style:radio{'Triangular':0;'Diente de sierra':1}]", 0, 0, 1, 1);
modulacion = vslider("Velocidad de modulacion [style:radio{'Lenta':0;'Media':1;'Rapida':2;'Maxima':3}]", 0, 0, 3, 1);

triangular = os.triangle(220);
sierra = os.sawtooth(220);

modulador = os.osc(0.5 + modulacion) * 0.5 + 0.5; // modulamos para que sea mas amena la nota fija

// select2 dejara pasar solo la señal que diga su primer argumento (0 o 1)
// podriamos tener 3 señales utilizando select3
process = hgroup("Conmutadores", select2(formaOnda, triangular, sierra) * modulador * 0.5);