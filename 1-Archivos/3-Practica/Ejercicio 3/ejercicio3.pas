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

    OPTIONS = (CREATE, OPEN, SEARCH_BY, SHOW_ALL, TO_BE_RETIRED);

{ GLOBAL file used in the procedures }
var
    employees : employees_file;

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

function get_selection(): OPTIONS;
var selected_option : integer;
begin
    readln(selected_option);
    
    { the minus 1 is needed bc the user inputs > 1 values but OPTIONS starts at 0 }
    get_selection := OPTIONS(selected_option - 1);
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

procedure create_employees_file();
var
    employee : reg_employee;
begin
    { read employees data & write it to the file }
    read_employee(employee);
    while (employee.lastname <> 'fin') do
    begin
        write(employees, employee);
        read_employee(employee);    
    end;
end;

procedure search_by_name(first_or_last_name : string);
var
    employee : reg_employee;
begin
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
end;

procedure show_all_employees();
var
    employee : reg_employee;
begin
    { output all the employees }
    while (not eof(employees)) do
    begin
        read(employees, employee);
        writeln('--------------------');
        write_employee(employee);
    end;
    writeln('--------------------');
end;

procedure show_soon_to_be_retired();
var
    employee : reg_employee;
begin
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
end;

procedure create_file(filepath : string);
begin
    { create & connect the file }
    assign(employees, filepath);
    rewrite(employees);

    { write to the file }
    create_employees_file();

    { close & save the file }
    close(employees);
end;

procedure open_file(filepath : string; user_selection : OPTIONS);
var
    searched_name : string;
begin
    { open & connect the file }
    assign(employees, filepath);
    reset(employees);

    case user_selection of
    SEARCH_BY:
    begin
        write('first/last name to be searched: ');
        readln(searched_name);

        search_by_name(searched_name);
    end;

    SHOW_ALL:
        show_all_employees();

    TO_BE_RETIRED:
        show_soon_to_be_retired();
    end;

    { close & save the file }
    close(employees);
end;

var 
    user_selection : OPTIONS;
    filepath : string;
begin

    show_initial_menu();
    user_selection := get_selection();
    writeln;

    { the filepath is needed in any option }
    write('filepath: ');
    readln(filepath);

    case user_selection of 
        CREATE:
            create_file(filepath);
            
        OPEN:
        begin
            show_open_file_menu();
            { 
                in the second menu, the user inputs 1, 2 or 3,
                but this OPTIONS are valued 3, 4, 5

                user input -> 1 
                in OPTIONS -> 3

                then -> succ(succ(1)) -> 3
            }
            user_selection := succ(succ(get_selection()));
            writeln;

            open_file(filepath, user_selection);
        end;
    end;

    readln;
end.