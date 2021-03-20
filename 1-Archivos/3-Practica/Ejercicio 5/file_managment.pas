unit file_managment;

interface

uses phone;

type 

    phones_file = file of reg_phone;

procedure read_phone_data(var phones : text; var phone : reg_phone);

procedure create_phones_file(var phones : phones_file);

implementation

procedure read_phone_data(var phones : text; var phone : reg_phone);
var phone : reg_phone;
begin
    if (not eof(phones)) then
    begin
        readln(phones, phone.code, phone.price, phone.brand, phone.name);
        writeln(phone.code, ' ', phone.price, ' ', phone.brand, ' ', phone.name);
    end
    else
        phone.current_stock := -1;
end;

procedure create_phones_file(var phones : phones_file);
var
    phone : reg_phone;
    phones_input : text;
begin
    { open the input file }
    assign(phones_input, 'celulares.txt');
    reset(phones_input);

    { create the new file }
    rewrite(phones);


    read_phone_data(phones_input);

    close(phones_input);
    close(phones);
end;

end.