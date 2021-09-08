/*
// hslider("label",init,min,max,step)
process = _ * hslider("volumen", 0.5, -5.0, 5.0, 0.00001);
*/
/*
// puedo crear definiciones adicionales
// asi puedo englobar/encapsular elementos
monoAmp = (_, hslider("volume", 0.1, 0, 1, 0.01)) : *;
process = monoAmp;
*/
/*
// amplificador estereo
monoAmp = (_, hslider("volume", 0.1, 0, 1, 0.01)) : *;
stereoAmp = monoAmp, monoAmp;
process = stereoAmp;
*/
/*
// slider verticales (por ahora se ven feos!!)
monoAmp = (_, vslider("volume", 0.1, 0, 1, 0.01)) : *;
stereoAmp = monoAmp, monoAmp;
process = stereoAmp;
*/
/*
// metadatos en las etiquetas [.....]
monoAmp = (_, hslider("volume[style:knob]", 0.1, 0, 1, 0.0001)) : *;
stereoAmp = monoAmp, monoAmp;
process = stereoAmp;
*/

/*
// Tipos de notacion para escribir "lo mismo"
//  _,0.1:* sintaxis principal
//  _*0.1 notación infija
//  *(0.1) notación de prefijo

// process = (_ , 0.1) : *; // dos elementos en paralelo, conectados secuencialmente a otro
// process = _ * 0.1;  // mas similar a la aritmetica
//process = *(0.1);
*/
/*
// control de Mute
process = _ * (1 - checkbox("Silenciar"));
*/

/*
// grupos de elementos (GUI)
// GUI = Graphical User Interface
mute = *(1-checkbox("mute"));
monoamp = *(vslider("volume[style:knob]", 0.1, 0, 1, 0.01)) : mute;
stereoamp = vgroup("Fender", monoamp, monoamp);
process = stereoamp;
*/

/*
// parametros
mute = *(1-checkbox("mute"));
// %c   parametro c en la etiqueta
monoamp(c) = *(vslider("Volumen %c[style:knob]", 0.1, 0, 1, 0.01)) : mute;
stereoamp = hgroup("Marshall", monoamp(0), monoamp(1));
process = stereoamp;
*/
/*
mute = *(1-checkbox("mute"));
monoamp(c) = *(vslider("volume[style:knob]", 0.1, 0, 1, 0.01)) : mute;
multiamp(N) = hgroup("Marshall", par(i, N, monoamp(i+1)));
process = multiamp(8); // probar multiamp(4) u otros valores (solo enteros positivos)
*/
