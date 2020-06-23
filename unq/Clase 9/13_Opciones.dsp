/*
Selector de opciones (interfaz grafica)

Los "sliders" pueden configurarse para mostrarse como botones de opciones, con cada
una representando un numero. Recordemos que "un slider es solo un numero" !!.

Para ello incluiremos lo siguiente en su etiqueta de nombre:
    "Nombre [style:radio{'Opcion A':0;'Opcion B':1}]"

Aqui tenemos dos opciones, 'Opcion A' y 'Opcion B' (notar las comillas simples ' ),
separadas por el caracter de punto y coma ; A cada opcion se le asigna un valor fijo
numerico, 0 y 1 con el caracter dos puntos :
Del mismo modo podemos añadir multiples opciones.

[Advertencia: el control no funciona si añadimos espacios entre las opciones]

De esta forma podemos crear un panel de opciones numericas con un texto indicativo.
En el ejemplo siguiente veremos otra aplicacion util de esto.

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");
notaMidi = vslider("Nota [style:radio{'Do':60;'Mi':64;'Sol':67;'Si':71}]", 60, 0, 100, 1);

modulador = os.osc(0.5) * 0.5 + 0.5; // modulamos para que sea mas amena la nota fija

// usamos ba.midikey2hz para convertir un numero de nota MIDI en frecuencia
process = os.triangle(ba.midikey2hz(notaMidi)) * modulador * 0.5 <: _, _;