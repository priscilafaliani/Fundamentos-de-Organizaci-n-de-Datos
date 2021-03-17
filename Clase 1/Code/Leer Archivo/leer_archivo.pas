program leer_archivos;

type
    int_file = file of integer;

procedure leer_archivo(var my_int_file  : int_file);
var
    number : integer;
begin
    reset(my_int_file );
    while (not eof(my_int_file )) do 
    begin
        read(my_int_file , number);
        write(number);
    end;
    close(my_int_file);
end;

var
    my_int_file : file of integer;

begin
    { abre y lee el archivo creado en generar_archivo }
    assign(my_int_file , '../Generar Archivo/hello.txt');
    leer_archivo(my_int_file );
    readln;
end.