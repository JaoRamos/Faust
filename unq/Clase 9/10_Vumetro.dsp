/*
Vumetro (interfaz grafica)

Advertencia: explicacion larga, pero uso muy facil!!!

Podemos crear un "vumetro" para tener una indicacion visual de -por ejemplo- el nivel
de una señal (¡pero podria ser otra cosa!).
Para ello podemos utilizar las primitivas hbargraph y vbargraph (horizontal/vertical).
Toman tres parametros:
    - Etiqueta / nombre
    - Minimo
    - Maximo

Necesitaremos algunos pasos mas para usar estos medidores. En primer lugar adaptar la
señal a la escala adecuada (por ejemplo pasarla a dB). Ya que normalmente las señales
de audio varian entre numeros negativos y positivos, es conveniente utilizar abs para
obtener el valor absoluto (descartando el signo), y tener solo numeros positivos. Todo
dependera de como sea la señal de origen.

Luego, si deseamos convertir señales lineales (-1 a +1) a valores en dB, utilizamos
la funcion ba.linear2db que nos devolvera un valor en dB entre -infinito y 0 o mas.

Por ultimo, y muy importante: si deseamos tanto VER el nivel, como ESCUCHAR (o seguir
procesando) la señal original, requerimos dos copias de esta señal. Pero debido al
funcionamiento interno del compilador de Faust, cualquier señal que no siga el camino
hacia el final de process, sera ignorada. La señal del vumetro.. morira en el vumetro.
En el editor puede que esto no influya en nada, pero si deseamos compilar nuestro DSP
para otras plataformas, es posible que no funcione como esperamos. La solucion para
esto es utilizar la funcion attach, que tiene dos entradas, dos parametros, y UNA
salida. Es mas simple de lo que parece: le pasamos una señal "duplicada", y attach
dirigira una copia directo a la salida (para continuar los procesos de audio) y la
otra hacia -por ejemplo- hbargraph. Aunque podemos hacer esto sin attach, esta funcion
asegura que el compilador siempre respete al vumetro, por mas que su señal no llegue
hasta process (ya que el vumetro no tiene salidas...).
Tras toda esta explicacion.... simplemente podemos copiar el ejemplo y replicarlo en
nuestros proyectos. Nada mas!

Poner un audio en la entrada y probar los tres medidores!

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

// medidor lineal, nivel entre 0 y 1
medidor_0a1 = abs : hbargraph("Nivel (lineal)", 0, 1);

// medidor logaritmico en dB entre -60 y 0
medidor_db = abs : ba.linear2db : hbargraph("Nivel (dB)", -60, 0);

// podemos ver cualquier numero en realidad, no solo señales de audio
// aqui no necesitamos abs, solo un slider o cualquier otro numero
medidor_slider = slider : hbargraph("La barra de poder", 0, 100);
    slider = hslider("Funciona no solo con audio!", 50, 0, 100, 1);

// attach fuerza que la segunda señal (hacia el vumetro) se compile aunque no "suene"
// en su primer argumento, dejamos _ para que la señal pase directo a la salida
// en el segundo ponemos "algo", en este caso nuestro medidor
// cambiar por cualquiera de los tres medidores!
process = _ <: attach(_, medidor_db ) ;