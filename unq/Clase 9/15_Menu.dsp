/*
Selector estilo menu (interfaz grafica)

Otra alternativa que tenemos para los sliders es utilizarlos como menu de opciones.
Funciona exactamente igual que los ejemplos anteriores, pero como un grupo desplegable de opciones.
Para ello utilizamos la etiqueta:
"Nombre[style:menu{'Opcion A':0;'Opcion B':1}]"

Nuevamente, podemos incluir tantas opciones como necesitemos. Aqui lo limitaremos a solo 3 porque
utilizaremos select3 para conmutarlas.

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

// "slider" estilo menu (si.. ya no es un slider, pero siempre es un numero)
formaOnda = vslider("Forma de onda[style:menu{'Triangular':0;'Diente de sierra':1;'Cuadrada':2}]", 0, 0, 2, 1);

triangular = os.triangle(220);
sierra = os.sawtooth(220);
cuadrada = os.square(220);

modulador = os.osc(0.5) * 0.5 + 0.5; // modulamos para que sea mas amena la nota fija

// esta vez utilizamos select3 para tener 3 opciones
process = select3(formaOnda, triangular, sierra, cuadrada) * modulador * 0.3 <: _, _;