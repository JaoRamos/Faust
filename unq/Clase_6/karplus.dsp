import("stdfaust.lib");
// frecuencia desde MIDI o teclado
frecuencia = nentry("freq", 120, 60, 20000, 1);
// cantidad de muestras de retardo segun la fundamental deseada
// puede haber desafinaciones porque los retardos son numeros enteros!
retardo = int(ma.SR / frecuencia);
// Controles del ruido del Karplus-Strong
GAIN_MINIMO = 0.7; // Cuanto menor sea, mas se parecera al ruido blanco
GAIN_MAXIMO = 0.999; // Cuidado no llegar a 1, ¡o el sonido no se detendra!
invertir = (checkbox("Invertir ruido") * 2 - 1) * -1; // -1 a 1 ¡ver el efecto!
gainRealimentacion = hslider("Gain", GAIN_MAXIMO * 0.99, GAIN_MINIMO, GAIN_MAXIMO, 0.0001);
envolvente = en.ar(0.003, 0.01, button("gate")) ; // envolvente para el ruido, experimentar!
// Filtro. Probar cambiar sus parametros
filtroKarplus = fi.lowpass(2, 5000);
// Generamos el retardo con el filtro
retardoFiltrado = @ (retardo)
 : filtroKarplus
 : *(gainRealimentacion * invertir);
// Componemos el algoritmo, con la recursion ~ para que se vaya sumando al original
karplusStrong = no.noise * envolvente : + ~ retardoFiltrado;
// si se dispone de un control de modulacion MIDI, jugar con este filtro
frecResonante = hslider("Resonante Wah (¡mover!)[midi:ctrl 1]", 1, 0, 1, 0.01) : si.smoo;
filtroRes = fi.resonlp(frecResonante * 4000 + 300,
 hslider("Q del filtro Resonante", 10, 1, 100, 0.01),
 0.5); // Gain fijo de 0.5
// incorporamos el velocity MIDI
velocity = nentry("gain", 0, 0, 1, 0.0001);
// Karplus Strong! (mono duplicado en L y R mediante la bifurcacion <: )
process = karplusStrong * velocity : filtroRes <: _, _;