/*
import("stdfaust.lib");
parteDecimal(x) = x - int(x);
fase(f) = f/ma.SR : (+ : parteDecimal) ~ _;
senialCuadrada(f) = fase(f) > 0.9125;
ondaCuadrada(f) = ((senialCuadrada(f)) * 2) - 1;
process = ondaCuadrada(220) * 0.2;
*/

/*
import("stdfaust.lib");
parteDecimal(x) = x - int(x);
fase = numeroSuma : (+ : parteDecimal) ~ _;

frecuencia = hslider("frec", 220, 60, 880, 0.01);
numeroSuma = frecuencia / ma.SR;

process = ((fase*2)-1) * 0.2;
*/

/*
import("stdfaust.lib");
parteDecimal(x) = x - int(x);
rampa = 0.005 : + ~ _;
// A ~ A

fase = parteDecimal(rampa)*(ma.PI*0.7);
process = sin(fase)*0.5;
*/