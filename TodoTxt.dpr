program TodoTxt;

uses
  Vcl.Forms,
  TodoUnit in 'TodoUnit.pas' {TodoForm},
  AddTodoEntryUnit in 'AddTodoEntryUnit.pas' {AddTodoEntryForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTodoForm, TodoForm);
  Application.CreateForm(TAddTodoEntryForm, AddTodoEntryForm);
  Application.Run;
end.
