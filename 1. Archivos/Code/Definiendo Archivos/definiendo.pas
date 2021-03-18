program definiendo;

type
    persona = record
        DNI : string;
        apellido : string;
        nombre : string;
        direccion : string;
        genero : string;
        salario : real;
    end;

    archivo_enteros = file of integer;
    archivo_reales = file of real;
    archivo_char = file of char;
    archivo_strings = file of string;
    archivo_personas = file of persona;

var
    enteros : archivo_enteros;
    reales : archivo_reales;
    caracteres : archivo_char;
    strings : archivo_strings;
    personas : archivo_personas;

begin
    assign(enteros, 'enteros.dat');
    assign(reales, 'reales.dat');
    assign(caracteres, 'caracteres.dat');
    assign(strings, 'strings.dat');
    assign(personas, 'personas.dat');
end.
