program ejercicio12;

const
    CODIGO_FIN = 32767;

type
    reg_acceso = record
        anio : integer;
        mes : integer;
        dia : integer;
        id_usuario : integer;
        tiempo : integer;
    end;

    archivo_maestro = file of reg_acceso;


procedure leer(var archivo : archivo_maestro; var registro : reg_acceso);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.anio := CODIGO_FIN;
end;


procedure buscar_anio(var archivo : archivo_maestro; anio : integer; var primer_acceso : reg_acceso);
begin
    leer(archivo, primer_acceso);
    while (primer_acceso.anio <> anio) do
        leer(archivo, primer_acceso);
end;


procedure realizar_informe(anio : integer);
var 
    maestro : archivo_maestro;
    acceso : reg_acceso;
    mes_actual, dia_actual, usuario_actual : integer;
    total_usuario, total_dia, total_mes, total_anio : integer;
begin
    assign(maestro, 'maestro');
    reset(maestro);

    buscar_anio(archivo, anio, acceso);
    if acceso.anio <> CODIGO_FIN then
    begin
        writeln('Anio ', anio);
        total_anio := 0;
        while acceso.anio = anio do
        begin
            mes_actual := acceso.mes;
            total_mes := 0;
            
            writeln('Mes ', mes_actual);
            while acceso.anio = anio and acceso.mes = mes_actual do
            begin
                dia_actual := acceso.dia;
                total_dia := 0;
                
                writeln('Dia ', dia_actual);
                while acceso.anio = anio and acceso.mes = mes_actual and acceso.dia = dia_actual do
                begin
                    
                    usuario_actual := acceso.id_usuario;
                    total_usuario := 0;

                    writeln('Id de usuario ', usuario_actual);
                    while acceso.anio = anio and acceso.mes = mes_actual and acceso.dia = dia_actual and acceso.id_usuario = usuario_actual do
                    begin
                        total_usuario := total_usuario + acceso.tiempo;
                        leer(maestro, acceso);
                    end;

                    writeln('Tiempo total de acceso en el dia ', dia_actual, ' mes ', mes_actual, ': ', total_usuario);

                    total_dia := total_dia + total_usuario;
                end;

                writeln('Total tiempo de acceso dia ', dia_actual, ' mes', mes_actual, ': ', total_dia);
                total_mes := total_mes + total_dia;
            end;

            writeln('Total tiempo de acceso mes', mes_actual, ': ', total_mes);
            total_anio := total_anio + total_mes;
        end;

        writeln('Total tiempo de acceso anio: ', total_anio);
    end
    else writeln('Anio no encontrado');

    close(maestro);
end;


procedure main();
var
    anio : integer;
begin
    writeln('Ingrese año sobre el cual realizar el informe');
    readln(anio);
    realizar_informe(anio);
end;

begin
    main();
end.