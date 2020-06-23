import("stdfaust.lib");
/*
Efecto de Phaser estereo simple.

El phaser mas elemental se compone de un filtro all-pass (pasa todo), que (en teoria) no
modifica la amplitud de las frecuencias (a diferencia de los demas filtros), pero cambia
las relaciones de FASE de estas frecuencias. Si luego sumamos su resultado con la señal
original, produciremos cancelaciones y todo tipo de efectos de fase en distintas partes
del espectro. Finalmente, si incorporamos una modulación en el parametro de retardo del
filtro all-pass, haremos que estas cancelaciones cambien constantemente, produciendo
el efecto que conocemos como PHASER.

Aquí tenemos un ejemplo de un phaser de 1 sola etapa, pero en dos canales independientes
para tener un pseudo phaser estereo. Simplemente reusamos la misma definicion y le ponemos
una pequeña diferencia fija en el canal derecho. Ademas, al escalar esta "diferencia"
logramos un pseudo control de amplitud estereo.
Los efectos de phaser mas complejos suelen tener multiples etapas de filtros all-pass,
ver los esquemas en: https://en.wikipedia.org/wiki/Phaser_(effect)

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

maximo = 512;   // maximo general de samples de delay para el filtro allpass/comb (potencia de 2 !)

// controles varios
rate = hslider("Rate [scale:exp]", 0.5, 0, 20, 0.01)*0.5 + 0.5;
retardo = hslider("Delay [scale:exp]", 30, 1, maximo, 0.01) : si.smoo;
feedback = 1-hslider("Feedback", 0.5, 0, 1, 0.01);  // "1-" porque allpass_fcomb usa un valor invertido
profundidad = hslider("Profundidad", 75, 0, 100, 1) / 100;
volumen =  hslider("Volumen", 50, 0, 100, 1) / 100;
separacion = hslider("Estereo", 1, 0, 1, 0.01) * (maximo/4) : si.smoo;    // crudo pero efectivo...!
oscilador = os.osc(rate);   // para hacer variar el phaser, pueden ser otras formas de onda

// inventamos un parametro de "diferencia" para tener distintos phasers con la misma definicion
// utilizando min() nos aseguramos que el valor nunca exceda el maximo
phaser(dif) = fi.allpass_fcomb(maximo,                                  // maximo delay posible
                               min(retardo*oscilador + dif, maximo),    // delay actual
                               feedback)                                // valor de feedback
              * profundidad;    // simplemente un control de nivel

// ambos canales iguales, pero con phaser derecho modificable por un slider
// con el parametro (x) nos aseguramos varias copias de la señal de entrada para reutilizar
process(x) = ((x : phaser(0)         ) + x) * volumen,      // canal izquierdo
             ((x : phaser(separacion)) + x) * volumen;      // canal derecho
