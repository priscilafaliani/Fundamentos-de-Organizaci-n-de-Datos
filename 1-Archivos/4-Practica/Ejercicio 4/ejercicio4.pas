program ejercicio4;

const
    MAQUINAS = 5;

type
    reg_sesion = record
        codigo_usuario : integer;
        fecha : string;
        tiempo : integer;
    end;

    log_maquina = file of reg_sesion;

    logs_maquinas = array[1..MAQUINAS] of log_maquina;

    reg_sesion_total = record
        codigo_usuario : integer;
        fecha : string;
        total : integer;
    end;

    log_final = file of reg_sesion_total;

procedure generar_log_maestro(var logs_detalle : logs_maquinas);
var 
    maestro : log_final;
begin
    assign(maestro, '\var\log\maestro');
    rewrite(maestro);

    abrir_todos_los_logs(logs_detalle);


    

    close(maestro);
    cerrar_todos_los_logs(logs_detalle);
end;