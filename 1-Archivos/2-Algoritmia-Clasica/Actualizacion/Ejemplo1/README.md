# Variante simple de un proceso de actualización

#### Precondiciones:
1. Existe archivo maestro.
2. Existe un único archivo detalle.
3. Cada registro del detalle modifica a un registro del maestro. El archivo detalle solo tiene datos que corresponden a uno del archivo maestro, por lo que no genera altas.
4. No todos los registros del maestro son necesariamente modificados.
5. Cada elemento del maestro modificado, es alterado por sólo un registro del archivo detalle.
6. Ambos archivos están ordenados por igual criterio.

### Consideraciones:
* El proceso termina cuando se termina de recorrer el archivo detalle.
* Se debe buscar el registro, ya que no todos necesariamente sean modificados.
* No se verifica el EOF del archivo maestro, dada la tercera precondición (siempre existe un registro correspondiente).