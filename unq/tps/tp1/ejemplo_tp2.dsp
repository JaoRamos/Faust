/*
    Ejemplo para ejercicio de sintesis
    Introduccion a la Programacion Aplicada al Sonido
    Universidad Nacional de Quilmes

    Autor original: Juan Ramos
    Año: 2023
*/

import("stdfaust.lib");

// El código está totalmente incompleto!!! 
// Pero sirve de base para comenzar a trabajar

frec = nentry("freq", 440 , 0, 4000, 0.0001);
gate = ??
gain = ??
envolvente = ??

oscilador = os.osc(frec);

process = oscilador * ???
