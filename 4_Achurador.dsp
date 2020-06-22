/*
Efecto casi comico de distorsion achuradora destructora...
Hacemos la señal totalmente cuadrada, y luego la hacemos seguir la amplitud de la señal
original mediante un seguidor de envolvente. De no hacerlo, la amplitud seria siempre
entre 1 y -1 totalmente saturado.

Es necesario añadir un filtro de agudos porque la señal 100% saturada es... insoportable!
Si observamos el osciloscopio, veremos señales casi cuadradas como resultado.

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

// hacemos cuadrada la señal, muy cuadrada!, utilizando un condicional if():
//      si la señal es mayor que cero, el resultado es +1
//      si la señal es menor que cero, el resultado es -1
// resultado: señal achurada con un hacha desafilada!!
achurador(x) = ba.if(x > 0, 1, -1) * 0.5;
filtroAgudos = fi.lowpass(10, 10000);

process(x) = x : achurador : filtroAgudos
             *(x : an.amp_follower(0.01))   // seguimos la amplitud original
             <: _, _;