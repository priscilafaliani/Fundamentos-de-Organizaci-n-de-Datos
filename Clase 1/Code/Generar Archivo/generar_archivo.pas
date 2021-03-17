program generar_archivo;

var
    int_file : file of integer;
    filename : string[12];
    number : integer; 

begin
    writeln('Ingrese el nombre del archivo: ');
    readln(filename);

    { crea el archivo }
    assign(int_file, filename);    
    rewrite(int_file);
    
    { lee y escribe numeros en el archivo }
    writeln('Ingrese un numero: ');
    readln(number);
    while (number <> 0) do 
    begin
        write(int_file, number);
        writeln('Ingrese un numero: ');
        read(number);
    end;

    { guarda el archivo en memoria secundaria }
    close(int_file);
    readln;
end.