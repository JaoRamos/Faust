rebote(retardo, gain) = @(retardo) : *(gain);
// reducimos progresivamente la señal original si el gain supera un "limite"
// quedando solo la señal del retardo ya existente en el bucle de realimentacion
limite = 0.95;
congelador(retardo, gain) = *(1 - max(0, gain - limite) / (1-limite)) : +~rebote(retardo, gain);
ecoestereo(retardo, gain) = congelador(retardo, gain), congelador(retardo, gain);
process = ecoestereo(44100/4, hslider("Realimentacion", 0, 0, 1, 0.01));