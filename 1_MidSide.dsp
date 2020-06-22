/*
Procesador MID-SIDE

Un procesador Mid-Side parte de una señal estereo diseñada como L + R, y deconstruye
el componente Mid (centro) y Side (lateral). El algoritmo es muy sencillo:
    mid =  L+R
    side = L-R
Habitualmente, estos procesadores ofrecen algun control de nivel para Mid y Side, y
luego reconstruyen la señal estereo pero con M y S rebalanceados.
Algunos tipos de procesos (sobre todo filtros) son capaces de trabajar de manera
independiente sobre los componentes M y S de una señal estereo.
¡¡Este proceso debe probarse con un sonido estereo de entrada!! ----->>>>

|| Juan Ramos 2020 - Universidad Nacional de Quilmes ||
|| juan.ramos@unq.edu.ar ||
*/

// Controles
sliderMid = hslider("Mid", 1, 0, 1, 0.01);
sliderSide = hslider("Side", 1, 0, 1, 0.01);
volumen = hslider("Volumen", 0.8, 0, 1, 0.01);

// Producimos las señales Mid y Side a partir de L y R
// Las escalamos e intervenimos su nivel con los sliders
mid(l, r)  = (l + r) * 0.5 * sliderMid;      // mid =  L+R
side(l, r) = (l - r) * 0.5 * sliderSide;     // side = L-R

// Reconstituye la señal estereo desde el mid, side
// al usar la COMA, producimos DOS canales (L y R)!!!
reconstituir(l, r) = mid(l, r) + side(l, r) ,  // L = mid + side
                     mid(l, r) - side(l, r);   // R = mid - side

// necesitamos el volumen una vez por canal, separados por COMA
process(l, r) = reconstituir(l, r)  :  (*(volumen), *(volumen));