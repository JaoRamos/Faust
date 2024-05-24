/*
    Ejemplo para ejercicio de delay
    Introduccion a la Programacion Aplicada al Sonido
    Universidad Nacional de Quilmes

    Autor original: Juan Ramos
    Año: 2024
*/

import("stdfaust.lib");

// varios sliders para control de usuario
retardoSlider = hslider(???);
gainSlider    = hslider(???);
otroSliderETC = hslider(???);

// parte principal con un delay con feedback genérico
ecoFeedbackMono(???) = +~(@(???tiempo???) * (???gain???));

// unir dos ecos mono en uno estereo, acá podrian ponerse controles diferentes para cada canal L R
ecoestereo(???) = ecoFeedbackMono(???), ecoFeedbackMono(???);

// process final, a partir de una señal mono o estereo de entrada
process = ??? : ecoestereo(???) : ???mas cosas???;