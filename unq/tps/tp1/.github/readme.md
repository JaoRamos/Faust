# Trabajo práctico 1
## Práctica con retardos y reverberación

__Consigna__

> [!IMPORTANT]
> Tomando como base el código en https://github.com/JaoRamos/Faust/blob/master/unq/tps/tp1/tp1programacion.dsp modificar los parámetros de tiempos (y ganancias * opcionalmente) de todos los retardos del ejemplo, con el fin de simular muy _a grosso modo_ la acústica de alguna habitación o recinto de la vida real. Estos valores pueden buscarse simplemente a oido: _probando y viendo qué pasa_, como para ir familiarizándonos mejor con el efecto que nos da al oido una u otra cantidad de retardo, y la combinación de varios retardos al mismo tiempo.
> Aclarar en un comentario del código qué habitación o recinto se tomó de referencia (o adjuntar fotografía si se desea).  

Por ejemplo: 

```cpp 
pared1(in, dif) = in : @(msSamples(68  + dif)) * 0.60;
```
Aquí podemos modificar el número 68 que representa 68ms de retardo, y opcionalmente el *0.60 que es la ganancia de ese retardo.  
- Opcional: se pueden modificar otros parámetros, añadir sliders si se desea, e incluso añadir más cantidad de reflejos y bucles de realimentación.
- Opcional avanzado: puede analizarse la forma de onda de una respuesta impulso (ver video abajo de todo) e intentar copiar los tiempos e intensidades aproximadas de algunos reflejos.

## Fundamentación

La idea detrás de este código es producir una reverberación muy básica, tomando un modelo simplificado de
>**sonido directo** + **reflexiones tempranas** + **cola reverberante**  

Para hacerlo más simple se generaron 3 reflexiones tempranas, y 3 bucles de realimentacion para crear la cola reverberante. En una situación más realista habría múltiples reflejos por todas partes en un recinto hasta conformar un campo reverberante difuso.
<img src="https://github.com/JaoRamos/Faust/assets/64828457/67a644a2-85d0-49a8-8d99-551f897bd4a3" width="690" height="319">  
<sup>(modificado desde imagen original https://www.eumus.edu.uy/eme/ensenanza/acustica/presentaciones/acuarq/acu10d.html)</sup>

## Notas

- La variable dif solo añade una pequeña diferencia en el tiempo de retardo en caso de querer usar mas de un canal (mono), como para poder simular un efecto estereo muy rudimentario.
- Un caso real de reverberacion tendrá además todo tipo de filtraciones y coloreos producidos por las características de las superficies del recinto y el propio aire, podemos simular algo de eso con filtros pero aún no lo hemos visto en clase :)  
- Para utilizar el código se puede copiar y pegar directamente, o bien utilizar los botones de GitHub ![image](https://github.com/JaoRamos/Faust/assets/64828457/22d0dc5a-b860-4710-8df7-cedf4ef0dafd)
para copiar/descargar el código.
- Para entregar el TP se recomienda subir el archivo .dsp al campus *en la sección de entregas*, o en su defecto copiar y pegar el código allí. Pueden adjuntar también imágenes si lo desean.
- Recomiendo este video https://youtu.be/t2R_ma7A2EQ?t=86 (ver entre 1:25 y 7:14, no hace falta entender la matemática etc!!) para comprender un poco mejor lo que ocurre con el sonido en una sala o cualquier recinto.
- Si se sienten muy nerds: la velocidad del sonido en el aire es aproximadamente 343m/s (metros por segundo), eso quiere decir que el sonido tarda unos 2.91ms en recorrer 1 metro (podríamos redondearlo en 3ms). Es una referencia útil a la hora de imaginar cuánto puede tardar cada reflejo según la distancia que recorre :)
