unit AddTodoEntryUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, TodoUnit;

type
  TAddTodoEntryForm = class(TForm)
    EditPriority: TLabeledEdit;
    EditContent: TLabeledEdit;
    EditDateCreate: TLabeledEdit;
    EditAddContext: TLabeledEdit;
    ListContexts: TListBox;
    EditAddProject: TLabeledEdit;
    ListProjects: TListBox;
    BtnAddEntry: TButton;
    btnSaveEntry: TButton;
    procedure EditPriorityKeyPress(Sender: TObject; var Key: Char);
    procedure EditAddContextKeyPress(Sender: TObject; var Key: Char);
    procedure EditAddProjectKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAddEntryClick(Sender: TObject);
    procedure btnSaveEntryClick(Sender: TObject);
  private
    { Private declarations }
    CurrentEntryIndex: Integer;
  public
    { Public declarations }
    procedure EmptyForm();
    procedure FillForm(Entry: TodoUnit.TTodoEntry;  Index: Integer);
  end;

var
  AddTodoEntryForm: TAddTodoEntryForm;

implementation

{$R *.dfm}

procedure TAddTodoEntryForm.EditPriorityKeyPress(Sender: TObject;
  var Key: Char);
begin
  //if Key in ['a'..'z','A'..'Z',',','.',' '] then
  if (Key in ['a'..'z']) then
  begin
    Key:=UpCase(Key);
  end;
  if not(Key in ['A'..'Z', #8]) then
  begin
    Key:=#0;
  end;
end;

procedure TAddTodoEntryForm.EmptyForm;
begin
  btnSaveEntry.Enabled:=false;
  BtnAddEntry.Enabled:=true;
  EditPriority.Text:='';
  EditContent.Text:='';
  EditAddContext.Text:='';
  EditAddProject.Text:='';
  ListContexts.Items.Clear;
  ListProjects.Items.Clear;
  EditDateCreate.Text:=FormatDateTime('yyyy.mm.dd', Now);
end;

procedure TAddTodoEntryForm.FillForm(Entry: TodoUnit.TTodoEntry; Index: Integer);
begin
  btnSaveEntry.Enabled:=true;
  BtnAddEntry.Enabled:=false;
  CurrentEntryIndex:=Index;

  EditPriority.Text:=Entry.priority;
  EditContent.Text:=Entry.content;
  ListContexts.Items:=Entry.contexts;
  ListProjects.Items:=Entry.projects;
  EditDateCreate.Text:=FormatDateTime('yyyy.mm.dd', Entry.dateCreate);
end;

procedure TAddTodoEntryForm.BtnAddEntryClick(Sender: TObject);
begin
  TodoForm.AddEntryFromForm;
end;

procedure TAddTodoEntryForm.btnSaveEntryClick(Sender: TObject);
begin
  TodoForm.UpdateEntryFromForm(CurrentEntryIndex);
  Close;
end;

procedure TAddTodoEntryForm.EditAddContextKeyPress(Sender: TObject;
  var Key: Char);
var
  s: String;
begin
  if (Key = #13) then
  begin
    if (Length(EditAddContext.Text) > 0) and (ListContexts.Items.IndexOf(EditAddContext.Text) < 0) then
    begin
      s:='+' + EditAddContext.Text;
      ListContexts.Items.Add(s);
    end;
  end;
end;

procedure TAddTodoEntryForm.EditAddProjectKeyPress(Sender: TObject;
  var Key: Char);
var
  s: String;
begin
  if (Key = #13) then
  begin
    if (Length(EditAddProject.Text) > 0) and (ListProjects.Items.IndexOf(EditAddProject.Text) < 0) then
    begin
      s:='@' + EditAddProject.Text;
      ListProjects.Items.Add(s);
    end;
  end;
end;

end.
