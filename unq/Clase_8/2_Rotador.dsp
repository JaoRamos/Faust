/*
Efecto super elemental de rotador estereo (paneador) automatizado, a partir de una señal mono.
Al final sumamos la señal original para obtener una suerte de control de profundidad.

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

rate = hslider("Rate (Hz) [scale:exp]", 1, 0.01, 30, 0.01);
profundidad = hslider("Profundidad", 0.5, 0, 1, 0.01);
oscilador = os.osc(rate)*0.5 + 0.5;
rotador = sp.panner(oscilador);

// aplicamos el rotador, y luego sumamos por separado la señal original
// a cada canal (ya que el original era MONO, y el paneado ESTEREO)
// al usar un parametro (entrada) podemos generar copias reutilizables
// de la señal, y asi las dirigiremos a distintos lugares.
process(entrada) = (entrada*profundidad : rotador) :
                   (+(entrada*(1-profundidad)),     // canal L
                    +(entrada*(1-profundidad)) );   // canal R
