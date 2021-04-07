program ejercicio9;

const
    CODIGO_FIN = 32767;

type
    reg_mesa = record
        codigo_provincia : integer;
        codigo_localidad : integer;
        numero_mesa : integer;
        cant_votos : integer;
    end;

    archivo_maestro = file of reg_mesa;


procedure leer(var archivo : archivo_maestro; var registro : reg_mesa);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.codigo_provincia := CODIGO_FIN;
end;


procedure presentar_listado();
var
    maestro : archivo_maestro;
    mesa : reg_mesa;
    prov_actual, loc_actual, votos_provincia, votos_localidad : integer;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    leer(maestro, mesa);
    while (mesa.codigo_provincia <> CODIGO_FIN) do
    begin
        prov_actual := mesa.codigo_provincia;
        votos_provincia := 0;

        writeln('Codigo de provincia: ', prov_actual);

        while (mesa.codigo_provincia = prov_actual) do
        begin
            loc_actual := mesa.codigo_localidad;
            votos_localidad := 0;

            while (mesa.codigo_provincia = prov_actual) and (mesa.codigo_localidad = loc_actual) do
            begin
                votos_localidad := votos_localidad + mesa.cant_votos;
                leer(maestro, mesa);
            end; 

            writeln('Codigo de localidad: ', loc_actual);
            writeln('Total votos localidad: ', votos_localidad);

            votos_provincia := votos_provincia + votos_localidad;
        end;

        writeln('Total votos provincia: ', votos_provincia);
    end;

    close(maestro);
end;

begin
    realizar_reporte();
end;