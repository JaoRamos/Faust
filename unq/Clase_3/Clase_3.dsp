/*
retardoslider = hslider("Retardo en segundos", 0.5, 0, 1, 0.01);
gainslider = hslider("Realimentacion", 0.5, 0, 1, 0.01);

rebote(retardo, gain) = @(retardo) * (gain);
ecomono(retardo, gain) = +~rebote(retardo, gain);
// mantendremos ambos canales ligeramente distintos
ecoestereo(retardo, gain) = ecomono(retardo/3, gain), ecomono(retardo, gain/2);

// multiplicamos por 44100 para tener la cantidad de muestras de retardo
process = _ <:  ecoestereo(retardoslider * 44100, gainslider);
*/

/*
rebote(retardo, gain) = @(retardo) : *(gain);
// reducimos progresivamente la señal original si el gain supera un "limite"
// quedando solo la señal del retardo ya existente en el bucle de realimentacion
limite = 0.95;

congelador(retardo, gain) = *(1 - max(0, gain - limite) / (1-limite)) : +~rebote(retardo, gain);

ecoestereo(retardo, gain) = congelador(retardo, gain), congelador(retardo, gain);
process = ecoestereo(44100/4, hslider("Realimentacion", 0, 0, 1, 0.01));

*/

rebote(retardo, gain) = @(retardo) : *(gain);
ecomono(retardo, gain) = +~rebote(retardo, gain);
// mantendremos ambos canales ligeramente distintos
ecoestereo(retardo, gain) = ecomono(retardo/3, gain), ecomono(retardo, gain/2);
retardoslider = hslider("Retardo en segundos", 0.5, 0, 1, 0.01);
gainslider = hslider("Realimentacion", 0.5, 0, 1, 0.01);
// multiplicamos por 44100 para tener la cantidad de muestras de retardo
process = ecoestereo(retardoslider * 44100, gainslider);
