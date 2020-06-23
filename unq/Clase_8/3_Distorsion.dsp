/*
Efecto de distorsion

En este ejemplo saturamos la señal con un control de ganancia para producir un efecto tipo
distorsion muy elemental. Existen maneras simples de distorsionar una señal, por ejemplo
haciendo un recorte directo una vez pasado cierto nivel (tambien llamado clip). Sin embargo
para tener un sonido algo mas natural, es conveniente utilizar un recorte progresivo. Para
ello existen muchas tecnicas. Aqui realizaremos un recorte aprovechando la funcion trigonometrica
tanh (tangente hiperbolica). En este caso no es tan relevante que es la tangente hiperbolica...
sino que lo importante es la curva que produce, podemos verla en:
https://es.wikipedia.org/wiki/Tangente_hiperb%C3%B3lica

Podemos utilizar esta curva como un "reductor de amplitud" con un maximo de 1, pero que llega
GRADUALMENTE al 1. Si pensamos el eje X como nivel de entrada (nuestra señal de origen), entonces
el eje Y es el resultado de la funcion. A medida que aumenta el nivel (X) el resultado se limita
en 1. De un modo similar funcionan los distorsionadores analogicos para instrumentos musicales,
pero en lugar de una funcion como tanh, este recorte lo producen valvulas, transistores, diodos,
etc...

Para producir la distorsion le añadimos un control de ganancia (amplificador) para que luego
tanh recorte la señal. A mayor ganancia, mas distorsionado el resultado.
Podemos conectar una guitarra en la entrada (o una grabacion de linea), pero el timbre sera
similar a un Fuzz y poco agradable, ya que no estamos incluyendo la simulacion de un parlante
y otros componentes cruciales para el sonido caracteristico de una guitarra distorsionada. Esto
lo veremos mas adelante.

Para un efecto mas extraño podemos incorporar una asimetria en la señal a distorsionar. Las
valvulas, por ejemplo, producen una distorsion ligeramente asimetrica. Sumando un valor fijo
podemos correr la señal "hacia el lado positivo o negativo", y tras distorsionarla escucharemos
efectos muy particulares, al extremo de parecer una señal de pulsos. Incluso podemos generar
un pseudo estereo generando una minima diferencia de asimetria en ambos canales.

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

// controles
volumen = hslider("[5]Volumen", 0.5, 0, 1, 0.01);
separacion = hslider("[2]Diferencia estereo", 0.3, 0, 1, 0.01);
offset = hslider("[1]Asimetria", 0, 0, 2, 0.01);
gain =  hslider("[0]Ganancia [scale:exp]", 5, 0, 100, 0.01);
graves = hslider("[3]Graves", 70, 0, 100, 1) / 100;
agudos = hslider("[4]Agudos", 50, 0, 100, 1) / 100;

distorsion(in, difEstereo) = ma.tanh(in * gain :          // amplificamos la entrada por el gain
                                     fi.highpass(1, 1020 - graves*1000)  // "graves"
                                     + offset + difEstereo)  // asimetria y diferencia extra estereo
                             : fi.highpass(1, 5)     // para corregir el descentrado del offset
                             : fi.lowpass(1, 1000 + agudos*10000)    // "agudos"
                             * volumen;
 
process(x) = distorsion(x, 0         ),     // canal izquierdo
             distorsion(x, separacion);     // canal derecho
