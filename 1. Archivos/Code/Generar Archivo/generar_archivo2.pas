program generar_archivo2;

type
    persona = record
        dni : string;
        apynom : string;
        direccion : string;
        genero : string;
        salario : real;
    end;

    archivo_personas = file of persona;

var
    personas : archivo_personas;
    filepath : string;
    p : persona;

begin 
    writeln('nombre del archivo: ');
    readln(filepath);

    assign(personas, filepath);

    { crea archivo }
    rewrite(personas);

    readln(p.dni);
    while (p.dni <> '') do 
    begin
        readln(p.apynom);
        readln(p.direccion);
        readln(p.genero);
        readln(p.salario);

        write(personas, p);

        readln(p.dni);
    end;

    close(personas);
end.