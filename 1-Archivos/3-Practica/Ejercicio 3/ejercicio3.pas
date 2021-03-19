program ejercicio3;

type

    reg_employee = record
        code : integer;
        lastname : string;
        firstname : string;
        age : integer;
        dni : string;
    end;

    employees_file = file of reg_employee;

procedure show_initial_menu();
begin
    writeln('---------- Choose an option ----------');
    writeln('1. Create new employees file');
    writeln('2. Open employees file');
    writeln('--------------------------------------');
end;

procedure show_open_file_menu();
begin
    writeln('---------- Choose an option ----------');
    writeln('1. Search employees by first/last name');
    writeln('2. Show all employees');
    writeln('3. Show soon to be retired employees');
    writeln('--------------------------------------');
end;

function get_selection(): integer;
var selected_option : integer;
begin
    readln(selected_option);
    get_selection := selected_option;
end;

procedure read_employee(var e : reg_employee);
begin
    with e do 
    begin
    
        write('lastname: ');
        readln(lastname);

        if (lastname <> 'fin') then 
        begin
            write('firstname: ');
            readln(firstname);
            write('employee code:');
            readln(code);
            write('age: ');
            readln(age);
            write('dni: ');
            readln(dni);
        end;
      
    end;
end;

procedure write_employee(e : reg_employee);
begin
    with e do 
    begin

        writeln('employee code: ', code);
        writeln('lastname: ', lastname);
        writeln('firstname: ', firstname);
        writeln('age: ', age);
        writeln('dni: ', dni);

    end;
end;

procedure create_employees_file(filename : string);
var
    employees : employees_file;
    employee : reg_employee;
begin

    { create & connect the file }
    assign(employees, filename);
    rewrite(employees);

    { read employees data & write it to the file }
    read_employee(employee);
    while (employee.lastname <> 'fin') do
    begin
        write(employees, employee);
        read_employee(employee);    
    end;

    { close & save the file }
    close(employees);
end;

procedure search_by_name(filepath, first_or_last_name : string);
var
    employees : employees_file;
    employee : reg_employee;
begin
    
    { open & connect the file }
    assign(employees, filepath);
    reset(employees);

    { output all the employees who match the name }
    while (not eof(employees)) do
    begin

        read(employees, employee);
        if ((employee.firstname = first_or_last_name) or (employee.lastname = first_or_last_name)) then 
        begin
            writeln('--------------------');
            write_employee(employee);
        end;

    end;
    writeln('--------------------');

    { close the file }
    close(employees);
end;

procedure show_all_employees(filepath : string);
var
    employees : employees_file;
    employee : reg_employee;
begin
    
    { open & connect the file }
    assign(employees, filepath);
    reset(employees);

    { output all the employees }
    while (not eof(employees)) do
    begin

        read(employees, employee);
        writeln('--------------------');
        write_employee(employee);

    end;
    writeln('--------------------');

    { close the file }
    close(employees);
end;

procedure show_soon_to_be_retired(filepath : string);
var
    employees : employees_file;
    employee : reg_employee;
begin

    { open & connect the file }
    assign(employees, filepath);
    reset(employees);

    { output all the employees older than 70 }
    while (not eof(employees)) do
    begin

        read(employees, employee);

        if (employee.age >= 70) then 
        begin
            writeln('--------------------');
            write_employee(employee);
        end;

    end;
    writeln('--------------------');

    { close the file }
    close(employees);
end;

begin

    

end.