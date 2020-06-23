/*
Detector estilo LED (interfaz grafica)

Al mismo medidor del ejemplo anterior podemos cambiarle el estilo para verlo estilo
LED que se enciende segun la señal. Para ello le agregamos [style:led] en la etiqueta.
Suele ser mas util como detector de señal.
A veces hay que ajustar el minimo y maximo hasta tener una visualizacion mas adecuada.

[Se aplican todas las mismas ideas y advertencias que antes]

Poner un audio en la entrada!

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

led = abs : ba.linear2db : vbargraph("Señal [style:led]", -50, 0);

process = _ <: attach(_, led);