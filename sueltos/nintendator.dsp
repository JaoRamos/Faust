/*
Nintendator

Efecto que combina bitcrusher (reduccion de profundidad de bits), con downsample de frecuencia de muestreo (hold crudo, sin interpolacion).

Con ambos valores al maximo la señal se escucha casi normal (ligero efecto del downsample a 22k).

Se incluye un filtro lowpass para hacer un antialias agresivo en el "nuevo" nyquist (f/2).

El bitcrusher esta basado en el de Faust, que esta bugeado (2023)...
...arreglado y mejorado para que 1 bit de unicamente -1 o +1 .

El bitcrusher esta colocado DESPUES del downsampler, podria invertirse el orden, incluso ponerlo antes del filtro antialias.

Considerar habilitar un filtro DC (pasa altos) artificial (comentado en el codigo) si se desea que a muy baja profundidad de bits el silencio vaya al valor 0.
No es 100% elegante, pero se debe recordar que a 1 bit hay solo dos posibilidades: maximo y minimo; pero el minimo no se considera 0.0 sino -1.0 !!!

|| Juan Ramos 2023 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/
import("stdfaust.lib");

fmax = 40000;
frec = hslider("Frecuencia downsample [scale:log]", fmax, 500, fmax, 1);
bits = hslider("Bits resolucion [scale:log]", 24, 1, 24, 1);
antialias = checkbox("antialias");

bitcrusher_juan(nbits, x) = (rint((x/2.0 + 0.5) * scaler) / scaler - 0.5) * 2.0
    with {
        scaler = float(2^nbits - 1.0);
    };

nintendator(in) = in : ba.downSample(frec) : fi.lowpass(16, frec*antialias*0.5 + fmax*(1-antialias)*0.5) : bitcrusher_juan(bits); // : fi.highpass(1, 20);

process(l, r) = nintendator(l), nintendator(r);