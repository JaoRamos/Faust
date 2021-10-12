/*
import("stdfaust.lib");

// les damos otro nombre para que sean mas faciles de leer
sampleRate = ma.SR;
pi = ma.PI;

// el generador de fase de siempre
partedecimal(x) = x - int(x);
fase(frec) = frec/sampleRate : (+ : partedecimal) ~ _;

// onda senoidal a partir de funcion seno
senoidal(frecuencia) = sin(fase(frecuencia) * 2 * pi);
frec = 500;

sierra = (senoidal(1 * frec)*1)   +
         (senoidal(2 * frec)/2.0) +
         (senoidal(3 * frec)/3.0) +
         (senoidal(4 * frec)/4.0) +
         (senoidal(5 * frec)/5.0);

process = sierra * 0.3;
*/
/*
import("stdfaust.lib");

volumen = hslider("-volumen-", 0.05, 0, 1, 0.01);
fundamental = hslider("-frecuencia-", 80, 20, 2000, 10);

// oscilador de cada parcial, será duplicado por sum()
parcial(indiceParcial, frecFundamental) = os.osc(frecFundamental * indiceParcial)
                                        * hslider("%indiceParcial Parcial", 1 / indiceParcial, 0, 1, 0.01);

// duplicamos el oscilador 10 veces para tener 10 parciales, probar que pasa con mas!
generador = sum(numParcial, 30, parcial(numParcial + 1, fundamental) ) * volumen;
process = generador, generador;
*/
/*
import("stdfaust.lib");

volumen = hslider("-volumen-", 0.05, 0, 1, 0.01);
fundamental = hslider("-frecuencia-", 80, 20, 2000, 10);

// oscilador de cada parcial, será duplicado por sum()
parcial(indiceParcial, frecFundamental) = os.osc(frecFundamental * indiceParcial)
                                        * hslider("%indiceParcial Parcial", 1 / indiceParcial, 0, 1, 0.01);

// duplicamos el oscilador 10 veces para tener 10 parciales, probar que pasa con mas!
cuadrada = sum(numParcial, 10, parcial((numParcial*2) + 1, fundamental) ) * volumen;
process = cuadrada, cuadrada;
*/

// UNA - "La" voz
import("stdfaust.lib");

// faust reconoce estos labels
// los mapea desde el controlador externo
// "gate"  si hay una nota encendida o no
// "freq"  me dice la frecuencia de la nota recibida
// "gain"  velocity midi (0-1)

sonar = button("gate");
frecuencia = nentry("freq", 200, 50, 2000, 0.001);
velocity = nentry("gain", 0, 0, 1, 0.001);

volumen = hslider("-volumen-", 0.5, 0, 1, 0.01);

//              tiempos en segundos
//              adsr(at,dt,sl,rt, gate)
//                    t  t  n  t
envolvente = en.adsr(0.02, 0.01, 0.5, 0.5, sonar);

parcial(indiceParcial, frecFundamental) = os.osc(frecFundamental * indiceParcial)
                                        * hslider("%indiceParcial Parcial", 1 / indiceParcial, 0, 1, 0.01);

// duplicamos el oscilador 10 veces para tener 10 parciales, probar que pasa con mas!
//mod = os.osc(10) * hslider("modulacion", 0, 0, 1, 0.01) + 1;
cuadrada = sum(numParcial, 40, parcial((numParcial*2) + 1, frecuencia) ) * volumen * velocity;// * mod;

process = cuadrada*envolvente*0.5, cuadrada*envolvente*0.5;
