/*
    Ejemplo para ejercicio de delay/reverberacion
    Introduccion a la Programacion Aplicada al Sonido
    Universidad Nacional de Quilmes

    Autor original: Roman Dumas
    Adaptacion: Juan Ramos
    Año: 2023
*/


// -------- Un par de definiciones de ayuda --------
sampleRate      = 44100;                    // este valor en realidad lo podemos hacer "automatico"
segSamples(seg) = seg * sampleRate;         // convierte segundos a samples, segun aquel sampleRate
msSamples(ms)   = segSamples(ms * 0.001);   // convierte milisegundos a samples


// -------- EFECTO REVERBERACION MONO -----------

// Reflexiones tempranas
//   Simulan reflexiones en las paredes/piso/techo o elementos del recinto
//   "dif" es solo una diferencia que se agrega para (si se desea) diferenciar canales L-R y dar mas efecto estereo
pared1(in, dif) = in : @(msSamples(68  + dif))*0.60; 
 pared2(in, dif) = in : @(msSamples(106 + dif))*0.37;
  pared3(in, dif) = in : @(msSamples(127 + dif))*0.21;
   //   ...podria haber mas!

// Colas de reverberacion
//   Genera una especie de cola de ecos que se van desvaneciendo
//   Un retardo inicial, posterior a las reflexiones tempranas, enviado a un bucle de REALIMENTACION ~ (feedback)
//   "dif" es solo una diferencia que se agrega para (si se desea) diferenciar canales L-R y dar mas efecto estereo
feedback1(in, dif) = in : @(msSamples(163 + dif))*0.31 : +~@(msSamples(68  + dif))*0.66; 
 feedback2(in, dif) = in : @(msSamples(252 + dif))*0.24 : +~@(msSamples(93  + dif))*0.47;
  feedback3(in, dif) = in : @(msSamples(508 + dif))*0.11 : +~@(msSamples(164 + dif))*0.32;
   //   ...podria haber muchas mas!

// Suma de todo, separado en varias lineas para mas claridad
//   "dif" es solo una diferencia que se agrega para (si se desea) diferenciar canales L-R y dar mas efecto estereo
reverberacion(in, dif) = in +                                                           // el "directo" se añade tal cual
                         pared1(in, dif)  + pared2(in, dif)  + pared3(in, dif) +        // sumamos las reflexiones tempranas
                         feedback1(in, dif) + feedback2(in, dif) + feedback3(in, dif);  // sumamos la cola de reverberacion


// -------- Process --------

// Usamos el efecto en ambos canales l-r, pero con una "pequeña diferencia" entre ambos (0 - 7)
// Es una simulacion de estereo "barata pero efectiva" :D
// Cuanto menor sea esa diferencia, mas "mono" sonara el efecto
process(l, r) = reverberacion(l, 0), reverberacion(r, 7);