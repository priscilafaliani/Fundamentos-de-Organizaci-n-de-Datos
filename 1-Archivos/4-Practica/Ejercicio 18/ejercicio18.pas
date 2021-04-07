program ejercicio18;

const 

    CODIGO_FIN = 'zzz';

type
    reg_evento = record
        nombre : string;
        fecha : string;
        sector : string;
        entradas_vendidas : integer;
    end;

    archivo_maestro = file of reg_evento;


procedure leer(var archivo : archivo_maestro; var registro : reg_evento);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.nombre := CODIGO_FIN;
end;


procedure realizar_informe();
var
    maestro : archivo_maestro;
    evento : reg_evento;
    nombre_actual, fecha_actual : string;
    ventas_evento, ventas_funcion : integer;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    leer(maestro, evento);
    while (evento.nombre <> CODIGO_FIN) do
    begin
        nombre_actual := evento.nombre;
        ventas_evento := 0;

        writeln('Nombre evento ', evento.nombre);
        while evento.nombre = nombre_actual do
        begin
            fecha_actual := evento.fecha;
            ventas_funcion := 0;

            while (evento.nombre = nombre_actual) and (evento.fecha = fecha_actual) do
            begin
                writeln('Ventas en el sector ', evento.sector, ': ', evento.entradas_vendidas);
                ventas_funcion := ventas_funcion + evento.entradas_vendidas;
                leer(maestro, evento);
            end;

            writeln('Cantidad total de entradas vendidas en funcion ', evento.fecha, ': ', ventas_funcion);
            ventas_evento := ventas_evento + ventas_funcion;
        end;

        writeln('Cantidad total vendida por el evento ', nombre_actual, ': ', ventas_evento);
    end;

    close(maestro);
end;

begin
    realizar_informe();
end.