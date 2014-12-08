unit TodoUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DateUtils, Vcl.Grids, System.Math, RegularExpressions;

type
  TTodoEntry = Record
      status: Boolean;
      priority: Char;
      dateCreate: TDateTime;
      dateComplete: TDateTime;
      content: String;
      contexts: TStringList;
      projects: TStringList;
  End;

  TTodo = class(TObject)
    private
      FileLines: TStringList;
      TodoEntries: Array of TTodoEntry;
    public
      constructor Create(const FileName: String);
      procedure LoadFromFile(const FileName: String);
      procedure SaveToFile(const FileName: String);
      function AddEntry(
        status: Boolean;
        priority: Char;
        dateCreate: TDateTime;
        dateComplete: TDateTime;
        content: String;
        contexts: String;
        projects: String
      ) : Integer; Overload;
      function AddEntry(newEntry: TTodoEntry) : Integer; Overload;
      function ParseFromString(line: String) : TTodoEntry;
      procedure DeleteEntry(Index: Cardinal);
      procedure InsertEntry(entry: TTodoEntry; Index: Cardinal);
  end;

  TTodoForm = class(TForm)
    BtnAddEntry: TButton;
    TodoGrid: TStringGrid;
    procedure RefreshGrid();
    procedure UpdateGridCell(Entry: TTodoEntry; Row: Integer);
    procedure FormCreate(Sender: TObject);
    procedure BtnAddEntryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TodoGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    todo: TTodo;
  public
    { Public declarations }
    procedure AddEntryFromForm();
    procedure UpdateEntryFromForm(Index: Integer);
  end;

var
  TodoForm: TTodoForm;

implementation

uses AddTodoEntryUnit;

{$R *.dfm}

procedure TTodoForm.UpdateEntryFromForm(Index: Integer);
var
  error: Boolean;
  s: String;
  t: TDateTime;
begin
  error:=false;
  with todo.todoEntries[Index] do
  begin
    status:=true;
    priority:=' ';
    if Length(AddTodoEntryForm.EditPriority.Text) > 0 then
    begin
      priority:=AddTodoEntryForm.EditPriority.Text[1];
    end;
    s:=AddTodoEntryForm.EditDateCreate.Text;
    if s.Length = 10 then
    begin
      if (s[5] <> '.') or (s[8] <> '.') or not(TryStrToDate(s, dateCreate)) then
      begin
        error:=true;
      end
      else
      begin
        dateCreate:=StrToDate(s);
      end;
    end
    else
    begin
      error:=true;
    end;

    if error then
    begin
      ShowMessage('Invalid date format');
    end;

    if Length(AddTodoEntryForm.EditContent.Text) > 0 then
    begin
      content:=AddTodoEntryForm.EditContent.Text;
    end
    else
    begin
      ShowMessage('Empty content');
      error:=true;
    end;

    contexts:=TStringList.Create;
    projects:=TStringList.Create;

    contexts.Assign(AddTodoEntryForm.ListContexts.Items);
    projects.Assign(AddTodoEntryForm.ListProjects.Items);

  end;
  if not(error) then
  begin
    RefreshGrid;
  end;
end;

procedure TTodoForm.AddEntryFromForm;
var
  newEntry: TTodoEntry;
  Index: Integer;
  error: Boolean;
  s: String;
  t: TDateTime;
begin
  error:=false;
  with newEntry do
  begin
    status:=true;
    priority:=' ';
    if Length(AddTodoEntryForm.EditPriority.Text) > 0 then
    begin
      priority:=AddTodoEntryForm.EditPriority.Text[1];
    end;
    s:=AddTodoEntryForm.EditDateCreate.Text;
    if s.Length = 10 then
    begin
      if (s[5] <> '.') or (s[8] <> '.') or not(TryStrToDate(s, dateCreate)) then
      begin
        error:=true;
      end
      else
      begin
        dateCreate:=StrToDate(s);
      end;
    end
    else
    begin
      error:=true;
    end;

    if error then
    begin
      ShowMessage('Invalid date format');
    end;

    if Length(AddTodoEntryForm.EditContent.Text) > 0 then
    begin
      content:=AddTodoEntryForm.EditContent.Text;
    end
    else
    begin
      ShowMessage('Empty content');
      error:=true;
    end;

    contexts:=TStringList.Create;
    projects:=TStringList.Create;

    contexts.Assign(AddTodoEntryForm.ListContexts.Items);
    projects.Assign(AddTodoEntryForm.ListProjects.Items);

  end;
  if not(error) then
  begin
    Index:=todo.AddEntry(newEntry);
    RefreshGrid;
  end;
end;

procedure TTodoForm.BtnAddEntryClick(Sender: TObject);
begin
  AddTodoEntryForm.EmptyForm;
  AddTodoEntryForm.ShowModal;
end;

procedure TTodoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  todo.SaveToFile('todo.txt');
end;

procedure TTodoForm.FormCreate(Sender: TObject);
begin
  todo:=TTodo.Create('todo.txt');

  TodoGrid.FixedRows:=1;
  TodoGrid.FixedCols:=1;
  TodoGrid.RowCount:=2;
  TodoGrid.ColWidths[0]:=30;
  TodoGrid.ColWidths[1]:=30;

  TodoGrid.Cells[1,0]:='P';
  TodoGrid.Cells[2,0]:='Content';
  TodoGrid.Cells[3,0]:='Date Create';
  TodoGrid.Cells[4,0]:='Date Ended';
  TodoGrid.Cells[5,0]:='Contexts';
  TodoGrid.Cells[6,0]:='Projects';

  if Length(todo.TodoEntries) > 0 then
    RefreshGrid;

end;

procedure TTodoForm.RefreshGrid;
var
  I: Integer;
begin
  TodoGrid.RowCount:=Length(todo.TodoEntries) + 1;
  for I := 0 to Length(todo.TodoEntries) - 1 do
  begin
    UpdateGridCell(todo.TodoEntries[I], I + 1);
  end;
end;

procedure TTodoForm.TodoGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
  Entry: TTodoEntry;
begin
  TodoGrid.MouseToCell(X, Y, Col, Row);
  if Col = 0 then
  begin
    if (Row > 0) and (Row < Length(todo.TodoEntries)) then
    begin
      Entry:=todo.TodoEntries[Row - 1];
      Entry.status:=not(Entry.status);
      if Entry.status then
      begin
        Entry.dateComplete:=0;
      end
      else
      begin
        Entry.dateComplete:=Now;
      end;
      todo.DeleteEntry(Row - 1);
      todo.AddEntry(Entry);
      RefreshGrid;
    end;
  end;

  if Col > 0 then
  begin
    if (Row > 0) and (Row < Length(todo.TodoEntries)) and (todo.TodoEntries[Row - 1].status) then
    begin
      AddTodoEntryForm.FillForm(todo.TodoEntries[TodoGrid.Row - 1], TodoGrid.Row - 1);
      AddTodoEntryForm.ShowModal;
    end;
  end;
end;

procedure TTodoForm.UpdateGridCell(Entry: TTodoEntry; Row: Integer);
var
  s, text: String;
begin
  if not(Entry.status) then
  begin
    TodoGrid.Cells[0, Row] := 'x';
  end
  else
  begin
    TodoGrid.Cells[0, Row] := '';
  end;

  TodoGrid.Cells[1, Row] := Entry.priority;
  TodoGrid.Cells[2, Row] := Entry.content;
  TodoGrid.Cells[3, Row] := FormatDateTime('yyyy.mm.dd', Entry.dateCreate);
  if CompareDateTime(Entry.dateComplete, Entry.dateCreate) > 0 then
    TodoGrid.Cells[4, Row] := FormatDateTime('yyyy.mm.dd', Entry.dateComplete);

  Entry.contexts.Delimiter:=' ';
  TodoGrid.Cells[5, Row] := Entry.contexts.DelimitedText;

  Entry.projects.Delimiter:=' ';
  TodoGrid.Cells[6, Row] := Entry.projects.DelimitedText;
end;

{ TTodo }

function TTodo.AddEntry(status: Boolean; priority: Char; dateCreate,
  dateComplete: TDateTime; content, contexts, projects: String) : Integer;
var
  newEntry: TTodoEntry;
  i: integer;
begin
  newEntry.status:=status;
  newEntry.priority:=priority;
  newEntry.dateCreate:=dateCreate;
  newEntry.dateComplete:=dateComplete;
  newEntry.content:=content;
  //newEntry.contexts:=contexts;
  //newEntry.projects:=projects;
  Result := AddEntry(newEntry);
end;

function TTodo.AddEntry(newEntry: TTodoEntry): Integer;
var
  DoAdd: Boolean;
  I: integer;
begin
  DoAdd:=false;
  I:=0;
  while (I < Length(TodoEntries)) and (not(DoAdd)) do
  begin

    if newEntry.status then
    begin
      if not(TodoEntries[I].status) then
      begin
        DoAdd:=true;
      end
    end;

    if (newEntry.status = TodoEntries[I].status) and (newEntry.priority in ['A'..'Z']) then
    begin
      if (TodoEntries[I].priority in ['A'..'Z']) then
      begin
        if TodoEntries[I].priority > newEntry.priority then
          DoAdd:=true;
        if (TodoEntries[I].priority = newEntry.priority) and (CompareDateTime(TodoEntries[I].dateCreate, newEntry.dateCreate) > 0) then
          DoAdd:=true;
      end
      else
      begin
        DoAdd:=true;
      end;
    end;
    if not(DoAdd) then
      Inc(I);
  end;

  InsertEntry(newEntry, I);
  Result := I;

end;

constructor TTodo.Create(const FileName: String);
begin
  SetLength(TodoEntries, 0);

  loadFromFile(FileName);
end;

procedure TTodo.DeleteEntry(Index: Cardinal);
var
  ALength, TailElements: Cardinal;
begin
  ALength:=Length(TodoEntries);
  Assert(ALength > 0);
  Assert(Index < ALength);

  Finalize(TodoEntries[Index]);
  TailElements:= ALength - Index;
  if TailElements > 0 then
  begin
    Move(TodoEntries[Index + 1], TodoEntries[Index], SizeOf(TTodoEntry) * TailElements);
  end;

  Initialize(TodoEntries[ALength - 1]);
  SetLength(TodoEntries, ALength - 1);


end;

procedure TTodo.InsertEntry(Entry: TTodoEntry; Index: Cardinal);
var
  ALength, TailElements: Cardinal;
begin
  ALength:=Length(TodoEntries);
  Assert(Index <= ALength);
  SetLength(TodoEntries, ALength + 1);
  Finalize(TodoEntries[ALength]);
  TailElements:=ALength - Index;
  if TailElements > 0 then
  begin
    Move(TodoEntries[Index], TodoEntries[Index + 1], SizeOf(TTodoEntry) * TailElements);
  end;
  Initialize(TodoEntries[Index]);
  TodoEntries[Index]:=Entry;
end;

procedure TTodo.loadFromFile(const FileName: String);
var
  Line: String;
  NewEntry: TTodoEntry;
begin
  FileLines:=TStringList.Create;
  if FileExists(FileName) then
  begin
    FileLines.LoadFromFile(FileName);
    for Line in FileLines do
    begin
      NewEntry:=ParseFromString(Line);
      AddEntry(NewEntry);
    end;

  end;
end;

function TTodo.ParseFromString(line: String) : TTodoEntry;
var
  StringList: TStringList;
  text,s: String;
  newEntry: TTodoEntry;
  RegExp: TRegEx;
  match: TMatch;
  group: TGroup;
  b: Boolean;
begin
  RegExp := TRegEx.Create('(?:(x )?(?:([1-2][0-9]{3}.[0-9]{2}\.[0-9]{2} )?))?(?:(\([A-Z]\) )?)(?:([1-2][0-9]{3}.[0-9]{2}\.[0-9]{2} )?)([^+@]*)([^@]*)?(.*)',[roSingleLine]);
  match:=RegExp.Match(line);
  if match.Success then
  begin
    if match.Groups.Item[1].Value.Trim = 'x' then
    begin
      newEntry.status:=false;
      if match.Groups.Item[2].Value.Length > 0 then
      begin
        try
          if (match.Groups.Item[2].Value[5] = '.') or (match.Groups.Item[2].Value[8] = '.') or not(TryStrToDate(match.Groups.Item[2].Value, newEntry.dateComplete)) then
          begin
            newEntry.dateComplete:=StrToDate(match.Groups.Item[2].Value);
          end;
        finally
        end;
      end;
    end
    else
    begin
      newEntry.status:=true;
    end;

    if match.Groups.Item[3].Value.Length = 4 then
      newEntry.priority:=match.Groups.Item[3].Value[2];

    if match.Groups.Item[4].Value.Length > 0 then
      begin
        try
          if (match.Groups.Item[4].Value[5] = '.') or (match.Groups.Item[4].Value[8] = '.') or not(TryStrToDate(match.Groups.Item[4].Value, newEntry.dateCreate)) then
          begin
            newEntry.dateCreate:=StrToDate(match.Groups.Item[4].Value);
          end;
        finally

        end;
      end;
    newEntry.content:=match.Groups.Item[5].Value.Trim;

    newEntry.contexts:=TStringList.Create;

    newEntry.contexts:=TStringList.Create;
    newEntry.contexts.LineBreak:=' +';
    newEntry.contexts.DelimitedText:=match.Groups.Item[6].Value.Trim;

    newEntry.projects:=TStringList.Create;
    newEntry.projects.Delimiter:=' ';
    newEntry.projects.DelimitedText:=match.Groups.Item[7].Value.Trim;

    Result := newEntry;
  end;
end;

procedure TTodo.SaveToFile(const FileName: String);
var
  Entry: TTodoEntry;
  Words: TStringList;
  Lines: TStringList;
  s, text: String;
begin
  Lines:=TStringList.Create;
  Lines.QuoteChar:=#0;
  for Entry in TodoEntries do
  begin
    Words:=TStringList.Create;
    Words.QuoteChar:=#0;
    if not(Entry.status) then
    begin
      Words.Add('x');
      if CompareDateTime(Entry.dateComplete, Entry.dateCreate) > 0 then
      begin
        s:=FormatDateTime('yyyy.mm.dd', Entry.dateComplete);
        Words.Add(s);
      end;
    end;
    if (Entry.priority <> ' ') and (Entry.priority <> #0) then
      Words.Add('(' + Entry.priority + ')');
    s:=FormatDateTime('yyyy.mm.dd', Entry.dateCreate);
    Words.Add(s);

    Words.Add(Entry.content.Trim);

    if Entry.contexts.Count > 0 then
    begin
      s:='';
      for text in Entry.contexts do
        s:=s + ' ' + text;
      Words.Add(s.Trim);
    end;

    if Entry.projects.Count > 0 then
    begin
      s:='';
      for text in Entry.projects do
        s:=s + ' ' + text;
      Words.Add(s.Trim);
    end;
    Words.Delimiter:=' ';
    Lines.Add(Words.DelimitedText)
  end;
  Lines.SaveToFile(FileName);
end;

end.
