/*
Tabs/pestañas (interfaz grafica)

Podemos mejorar notablemente la interfaz grafica utilizando pestañas para agrupar
los distintos controles, por ejempo segun categorias.
Para ello utilizamos la primitiva:
    tgroup("nombre", elementos);

Aqui "elementos" seran elementos que utilicen conjuntos de vgroup o hgroup,
y automaticamente se organizaran en pestañas.

[Advertencia: a veces las pestañas se amontonan si la ventana del DSP es muy pequeña,
conviene agrandarla o seleccionar Popup UI en el panel de la izquierda!]

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

import("stdfaust.lib");

// GRUPOS DEFINIDOS de oscilador, salida y reverb
    numOscilador = hgroup("[0]Oscilador", formaOnda);
        // "slider" estilo menu (si.. ya no es un slider, pero siempre es un numero)
        formaOnda = vslider(
            "Forma de onda[style:menu{'Triangular':0;'Diente de sierra':1;'Cuadrada':2}]",
            1, 0, 2, 1 );
    // (recordemos que con un numero entre corchetes [x] forzamos un orden en particular para los elementos)
    salida = hgroup("[2]Salida", filtro : volumen);
        volumen = * (hslider("Volumen", 50, 0, 100, 0.1) / 100);
        filtro = fi.lowpass(2, hslider("Corte agudos (Hz)[scale:exp]", 2000, 500, 20000, 1));
    reverb = hgroup("[1]Reverb", dm.freeverb_demo); // reverb estereo

// GRUPO/PESTAÑA "FORZADA"
// Con h:xxxx/ o v:xxxx/ podemos forzar un grupo horizontal o vertical a donde pertenecera cada control
// este "grupo" se transformara en una pestaña
// Lo escribimos usando / como si fueran carpetas o una direccion web
    velocity = nentry("h:[3]MIDI/gain", 0, 0, 1, 0.01);
    frecuencia = nentry("h:[3]MIDI/freq", 220, 1, 4000, 0.01);
    gate = nentry("h:[3]MIDI/gate", 0, 0, 1, 1) : si.smoo;  // smoo para evitar clics de audio (envolvente)

// los osciladores que van a sonar
triangular = os.triangle(frecuencia);
sierra = os.sawtooth(frecuencia);
cuadrada = os.square(frecuencia);

// esta vez utilizamos select3 para tener 3 opciones
sinte = select3(numOscilador, triangular, sierra, cuadrada) * velocity * gate : salida <: reverb;

// creamos el grupo de pestañas, definidas segun cada hgroup (o vgroup)
process = tgroup("Super sinte genial", sinte);