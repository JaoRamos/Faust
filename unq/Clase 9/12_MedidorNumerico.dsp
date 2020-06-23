/*
Medidor numerico (interfaz grafica)

Ademas de vumetro o led, podemos simplemente mostrar el numero con [style:numerical].

[Se aplican todas las mismas ideas y advertencias que antes]

Poner un audio en la entrada!

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");
mostrarNumero = abs : ba.linear2db : vbargraph("Nivel[style:numerical]", -60, 0);
process = _ <: attach(_, mostrarNumero);