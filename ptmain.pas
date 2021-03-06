unit ptmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    txtFn: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{PHP5 must be defined if you are using PHP5}
{$DEFINE PHP5}

{For PHP5 you have to define the subversion of PHP}
{$DEFINE PHP504}
{$DEFINE PHP510}
{$DEFINE PHP511}
{$DEFINE PHP512}
{$DEFINE PHP520}
{$DEFINE PHP530}

type
  Pzend_module_entry = ^Tzend_module_entry;
  Tzend_module_entry = record
    size: word;
    zend_api: dword;
    zend_debug: byte;
    zts: byte;
    {$IFDEF PHP5}
    ini_entry : pointer;
    {$IFDEF PHP510}
    deps : pointer;
    {$ENDIF}
    {$ENDIF}
    name: PAnsiChar;
    functions: Pointer;
    module_startup_func: pointer;
    module_shutdown_func: pointer;
    request_startup_func: pointer;
    request_shutdown_func: pointer;
    info_func: pointer;
    version: PAnsiChar;

    {$IFDEF PHP5}
     {$IFDEF PHP520}
      globals_size : Integer;//globals_size : size_t; //32 位下应该是 4 字节的
      globals_id_ptr : pointer;
      globals_ctor : pointer;
      globals_dtor : pointer;
     {$ENDIF}
    {$ENDIF}

    {$IFDEF PHP5}
    post_deactivate_func : pointer;
    {$ELSE}
    global_startup_func: pointer;
    global_shutdown_func: pointer;
    {$ENDIF}

    {$IFNDEF PHP520}
    global_id: integer;
    {$ENDIF}

    module_started: integer;
    _type: byte;
    handle: pointer;
    module_number: longint;
    {$IFDEF PHP530}
    build_id : PAnsiChar;  //可以看到是用什么编译的//例如 'API20090626,NTS,VC9'
    {$ENDIF}
  end;

  //function get_module : Pzend_module_entry; cdecl;
  get_module = function  : Pzend_module_entry; cdecl;

procedure TForm1.Button1Click(Sender: TObject);
var
  fn:string;
  Module:Thandle;
  f1:Pointer;
  pInfo:Pzend_module_entry;
  fun:get_module;
begin

  fn := txtFn.Text;

  //Module := LoadLibrary(PChar(fn)); //这种情况下应该先加载 php5.dll
  //Module := LoadLibraryEx(PChar(fn), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
  Module := LoadLibraryEx(PChar(fn), 0, DONT_RESOLVE_DLL_REFERENCES);

  ShowMessage(IntToStr(Integer(Module)));

  f1 := 0;
  f1 := GetProcAddress(Module, 'get_module');

  fun := f1;

  pInfo := fun();

  ShowMessage(IntToStr(Integer(f1)));
  //ShowMessage(IntToStr(Integer(pInfo.info_func)));
  ShowMessage(pInfo.name);

end;

end.
