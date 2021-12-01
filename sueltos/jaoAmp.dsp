declare name "Simulador de Amp Jao medio bit";
declare version "0.1";
declare author "Jao Corporation";
declare description "Simulador de Amp Jao medio bit";

import("stdfaust.lib");

gain = hslider("Gain", 40, 1, 200, 0.1);
prefiltro = hslider("Pasaaltos pre", 1400, 20, 1500, 10);
agudos =  hslider("Parlante (pasabajos)", 3500, 100, 8000, 10);
delaySlider =  hslider("Delay", 0.5, 0, 0.9, 0.01);
blend = hslider("Blend Clean", 5, 0, 10, 0.01);
master =  hslider("Volumen Master", 0.3, 0, 1, 0.01);

pre = ((fi.highpass(1, prefiltro)) * gain : ma .tanh) / (gain/10 : ma.tanh : *(2));
cleanMezcla = fi.highpass(1, 100) : medios : *(blend);

medios = fi.peak_eq(-6, 1200, 400) : fi.peak_eq(3, 2500, 1000);
delay = @(ma.SR / 3) : *(delaySlider) : fi.lowpass(1, 500);
tono = fi.lowpass(3, agudos);

cadena = _ <: cleanMezcla, (pre : medios) :> tono : + ~ delay : *(master);

process = cadena <: _, _;