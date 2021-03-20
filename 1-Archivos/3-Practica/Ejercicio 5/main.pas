program ejercicio5;

uses menus, file_managment;

var
    user_selection : integer;
    phones : phones_file;

type

    MENU_OPTIONS = (CREATE, SHOW_LESS_STOCK, SHOW_WITH_DESC, EXPORT_ALL);

procedure get_user_selection();
begin
    readln(user_selection);

    { the user inputs values from 1 but the enum starts at 0 }
    user_selection := user_selection - 1;
end;

procedure create_file_option();
var 
    filename : string;
begin
    writeln('filename: ');
    readln(filename);
    assign(phones, filename);
    create_phones_file(phones);
end;

begin
    assing(phones, 'phones');
    create_phones_file(phones);

    // get_user_selection();
    // writeln;

    // case MENU_OPTIONS(user_selection) of
    //     CREATE:

    //     SHOW_LESS_STOCK:

    //     SHOW_WITH_DESC:

    //     EXPORT_ALL:

    //     else
    //         writeln('exiting');
    
    readln;
end.