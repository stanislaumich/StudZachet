unit UMainWin;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
    Vcl.PlatformDefaultStyleActnCtrls,
    System.Actions, Vcl.ActnList, Vcl.ActnMan, Vcl.ExtCtrls, frxClass,
    Vcl.StdCtrls, Vcl.Buttons,
    Vcl.Grids, frxPreview, inifiles, Data.DB, MemDS, DBAccess, Uni, UniProvider,
    InterBaseUniProvider, OracleUniProvider, Vcl.DBGrids, frxDBSet;

type
    TUMain = class(TForm)
        Panel1: TPanel;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        StatusBar1: TStatusBar;
        Rep: TfrxReport;
        GroupBox1: TGroupBox;
        GroupBox2: TGroupBox;
        Panel2: TPanel;
        Splitter1: TSplitter;
        GroupBox3: TGroupBox;
        GroupBox4: TGroupBox;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Edit1: TEdit;
        Edit2: TEdit;
        Edit3: TEdit;
        Edit4: TEdit;
        Edit5: TEdit;
        BitBtn1: TBitBtn;
        BitBtn2: TBitBtn;
        GroupBox5: TGroupBox;
        Label6: TLabel;
        Label7: TLabel;
        Label8: TLabel;
        Label9: TLabel;
        ComboBox1: TComboBox;
        ComboBox2: TComboBox;
        ComboBox3: TComboBox;
        ComboBox4: TComboBox;
        BitBtn3: TBitBtn;
        BitBtn4: TBitBtn;
        frxPreview1: TfrxPreview;
        StringGrid1: TStringGrid;
        ActionList1: TActionList;
        SearchOne: TAction;
        ClearOne: TAction;
        Label10: TLabel;
        DateTimePicker1: TDateTimePicker;
        Panel3: TPanel;
        CheckBox1: TCheckBox;
        BitBtn5: TBitBtn;
        TabSheet3: TTabSheet;
        GroupBox6: TGroupBox;
        Label11: TLabel;
        Edit6: TEdit;
        Button1: TButton;
        OpenDialog1: TOpenDialog;
        RadioButton1: TRadioButton;
        RadioButton2: TRadioButton;
        BitBtn6: TBitBtn;
        BitBtn7: TBitBtn;
        TabSheet4: TTabSheet;
        GroupBox7: TGroupBox;
        GroupBox8: TGroupBox;
        GroupBox9: TGroupBox;
        Button2: TButton;
        UniConnection1: TUniConnection;
        Query1: TUniQuery;
        InterBaseUniProvider1: TInterBaseUniProvider;
        OracleUniProvider1: TOracleUniProvider;
        UniConnection2: TUniConnection;
        Query2: TUniQuery;
        Button3: TButton;
        Button4: TButton;
        Query3: TUniQuery;
        QSearch: TUniQuery;
        DownTable: TUniTable;
        DataSource1: TDataSource;
        DBGrid1: TDBGrid;
        QMoveDown: TUniQuery;
        BitBtn8: TBitBtn;
        Edit7: TEdit;
        SaveDialog1: TSaveDialog;
        QTemp: TUniQuery;
        BitBtn9: TBitBtn;
        BitBtn10: TBitBtn;
        frxDBDataset1: TfrxDBDataset;
        BitBtn11: TBitBtn;
        MovedownOne: TAction;
        MoveDownAll: TAction;
        CleardownAll: TAction;
        DeleteDownOne: TAction;
        Prepareprint: TAction;
        Panel4: TPanel;
        BitBtn12: TBitBtn;
        Button5: TButton;
        Button6: TButton;
        Button7: TButton;
        QueryFIO: TUniQuery;
        Qinsfio: TUniQuery;
    GroupBox10: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    CheckBox2: TCheckBox;
        procedure ClearOneExecute(Sender: TObject);
        procedure SearchOneExecute(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure CheckBox1Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure Button2Click(Sender: TObject);
        procedure Button4Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure BitBtn8Click(Sender: TObject);
        procedure BitBtn4Click(Sender: TObject);
        procedure MovedownOneExecute(Sender: TObject);
        procedure DownTableAfterRefresh(DataSet: TDataSet);
        procedure CleardownAllExecute(Sender: TObject);
        procedure PrepareprintExecute(Sender: TObject);
        procedure MoveDownAllExecute(Sender: TObject);
        procedure Button6Click(Sender: TObject);
        procedure Button5Click(Sender: TObject);
        procedure Button7Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    private
        { Private declarations }
    public
        Procedure ClearString(StringGrid1: TStringGrid);
        procedure FillString(StringGrid1: TStringGrid; QSearch: TUniQuery);
        procedure Autow(Grid: TStringGrid);
        procedure SetValue(name: string; val: string);
        procedure SetVisible(name: string; val: boolean);
        Procedure LoadIni;
        Procedure SaveIni;
    end;

var
    UMain: TUMain;
    searchlang:integer;
implementation

{$R *.dfm}

procedure TUMain.Autow(Grid: TStringGrid);
var
    i, j, temp, max: integer;
begin
    for i := 0 to Grid.colcount - 1 do
    begin
        max := 0;
        for j := 0 to Grid.rowcount - 1 do
        begin
            temp := Grid.canvas.textWidth(Grid.cells[i, j]);
            if temp > max then
                max := temp;
        end;
        Grid.colWidths[i] := max + Grid.gridLineWidth + 4;
    end;
  Grid.Repaint;
end;

Procedure TUMain.LoadIni;
// -----------------------------------------------------------------------
var
    s: string;
    ini: tinifile;
begin
    ini := tinifile.Create(extractfilepath(Application.ExeName) +
      '\zachetka.ini');
    Edit6.Text := ini.ReadString('ZACH', 'shablon', '');
    searchlang := ini.ReadInteger('OTHER', 'searchlang', 6);
    if searchlang=6 then RadioButton3.Checked:=true;
    if searchlang=131 then RadioButton4.Checked:=true;

    ini.free;
end;

procedure TUMain.MoveDownAllExecute(Sender: TObject);
var
    i: integer;
begin
    { if StringGrid1.cells[0, StringGrid1.row] = '' then
      exit;
      StringGrid1.row := 1;
      QTemp.Close;
      QTemp.SQL.Clear;
      QTemp.SQL.Add('select * from prn where tab_num = ' + StringGrid1.cells[0,
      StringGrid1.row]);
      QTemp.Open;
      if QTemp.RecordCount = 0 then
      begin
      while StringGrid1.row < StringGrid1.rowcount  do
      begin
      QMoveDown.ParamByName('tab_num').Asstring :=
      StringGrid1.cells[0, StringGrid1.row];
      QMoveDown.ExecSQL;
      if (StringGrid1.row<StringGrid1.rowcount-1) then StringGrid1.row := StringGrid1.row + 1;
      end;
      end
      else
      StatusBar1.Panels[0].Text := '��� ���� ' + StringGrid1.cells
      [1, StringGrid1.row] + ' ' + StringGrid1.cells[2, StringGrid1.row];
      if Not DownTable.Active then
      DownTable.Active := true;
      DownTable.Refresh;
    }
end;

procedure TUMain.MovedownOneExecute(Sender: TObject);
var
tsearchlang:Integer;
begin
    if StringGrid1.cells[0, StringGrid1.row] = '' then
        exit;
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('select * from prn where tab_num = ' + StringGrid1.cells[0,
      StringGrid1.row]);
    QTemp.Open;
    if QTemp.RecordCount = 0 then
    begin
        QMoveDown.ParamByName('tab_num').Asstring := StringGrid1.cells
          [0, StringGrid1.row];
        tsearchlang:=searchlang;
        if CheckBox2.Checked then tsearchlang:=6;
        QMoveDown.ParamByName('idlang').asinteger:=tsearchlang;

        QMoveDown.ExecSQL;
        if Not DownTable.Active then
            DownTable.Active := true;
        DownTable.Refresh;
        StatusBar1.Panels[0].Text := '�������� ' + StringGrid1.cells
          [1, StringGrid1.row] + ' ' + StringGrid1.cells[2, StringGrid1.row];
    end
    else
        StatusBar1.Panels[0].Text := '��� ���� ' + StringGrid1.cells
          [1, StringGrid1.row] + ' ' + StringGrid1.cells[2, StringGrid1.row];

end;

procedure TUMain.PrepareprintExecute(Sender: TObject);
begin
    Rep.LoadFromFile('s:\StudZachet\ZACHx4GOOD1.fr3');
    SetVisible('Memo21', CheckBox1.Checked);
    SetValue('Memo19',DatetoStr(DateTimePicker1.Date));
    Rep.PrepareReport();
    PageControl1.ActivePageIndex := 1;
end;

procedure TUMain.RadioButton3Click(Sender: TObject);
begin
 if RadioButton3.Checked then searchlang:=6;
end;

procedure TUMain.RadioButton4Click(Sender: TObject);
begin
 if RadioButton4.Checked then searchlang:=131;
end;

Procedure TUMain.SaveIni;
var
    s: string;
    ini: tinifile;
begin
    ini := tinifile.Create(extractfilepath(Application.ExeName) +
      '\zachetka.ini');
    ini.WriteString('ZACH', 'shablon', Edit6.Text);
    ini.WriteInteger('OTHER', 'searchlang', searchlang);
    ini.free;
end; // -------------------------------------------------------------------------------------------

Procedure TUMain.ClearString(StringGrid1: TStringGrid);
var
    i, j: integer;
begin
    for i := 0 to StringGrid1.colcount - 1 do
        for j := 0 to StringGrid1.rowcount - 1 do
            StringGrid1.cells[i, j] := '';
    StringGrid1.rowcount := 2;
end;

procedure TUMain.DownTableAfterRefresh(DataSet: TDataSet);
begin
    DownTable.last;
    StatusBar1.Panels[1].Text := '� �������: ' +
      inttostr(DownTable.RecordCount);
end;

procedure TUMain.FillString(StringGrid1: TStringGrid; QSearch: TUniQuery);
var
    i, j: integer;
begin
    ClearString(StringGrid1);
    StringGrid1.colcount := QSearch.FieldCount;
    StringGrid1.rowcount := QSearch.RecordCount + 1;
    QSearch.first;
    for i := 0 to QSearch.RecordCount do
    begin
        if QSearch.eof then
            break;
        for j := 0 to QSearch.FieldCount - 1 do
            StringGrid1.cells[j, i + 1] := QSearch.Fields[j].Asstring;
        QSearch.next;
        // if Qsearch.eof then break;

    end;
    Autow(StringGrid1);
end;

procedure TUMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

    SaveIni;
end;

procedure TUMain.FormCreate(Sender: TObject);
var
    i: integer;
begin
    DateTimePicker1.Date := Date;
    LoadIni;

    QTemp.SQL.Add('select distinct n_otdel from student');
    QTemp.Open();
    while not QTemp.eof do
    begin
        ComboBox1.items.Add(QTemp.FieldByName('n_otdel').Asstring);
        QTemp.next;
    end;
    ComboBox1.Text := '';
    QTemp.SQL.Clear;
    QTemp.SQL.Add('select distinct fname from student');
    QTemp.Open();
    while not QTemp.eof do
    begin
        ComboBox2.items.Add(QTemp.FieldByName('fname').Asstring);
        QTemp.next;
    end;
    ComboBox2.Text := '';
    QTemp.SQL.Clear;
    QTemp.SQL.Add('select distinct n_vob from student');
    QTemp.Open();
    while not QTemp.eof do
    begin
        ComboBox3.items.Add(QTemp.FieldByName('n_vob').Asstring);
        QTemp.next;
    end;
    ComboBox3.Text := '';
    QTemp.SQL.Clear;
    { ����
      Qtemp.SQL.Add('select distinct n_vob from student');
      QTemp.Open();
      while not Qtemp.eof do
      begin
      ComboBox3.items.Add(QTemp.FieldByName('n_vob').Asstring);
      QTemp.Next;
      end;
      ComboBox3.Text:='';
      QTemp.SQL.Clear;
    }

end;

procedure TUMain.SearchOneExecute(Sender: TObject);
var
 tsearchlang:integer;
begin
    QSearch.Close;
    QSearch.SQL.Clear;
    QSearch.SQL.Add
      ('select s.tab_num, f.fam, f.name, f.otch,s.dat_n, s.n_zach,s.n_vob, s.dat_max, s.n_otdel, s.fname from student s, fio f where ');
    QSearch.SQL.Add
      ('f.tabnum=s.tab_num and idlang='+inttostr(searchlang)+' ');
    if Edit1.Text <> '' then
        QSearch.SQL.Add(' and f.fam like ' +
          Quotedstr(AnsiUpperCase(Edit1.Text) + '%'));
    if Edit2.Text <> '' then
        QSearch.SQL.Add(' and f.name like ' +
          Quotedstr(AnsiUpperCase(Edit2.Text) + '%'));
    if Edit3.Text <> '' then
        QSearch.SQL.Add(' and f.otch like ' +
          Quotedstr(AnsiUpperCase(Edit3.Text) + '%'));
    if Edit4.Text <> '' then
        QSearch.SQL.Add(' and s.n_zach like ' + Quotedstr(Edit4.Text + '%'));
        QSearch.SQL.Add(' order by s.tab_num');
    // Qsearch.sql.Add('');

    QSearch.Open;
    QSearch.last;
    FillString(StringGrid1, QSearch);
    // Edit1.Text := '';
end;

procedure TUMain.SetValue(name: string; val: string);
var
    C: tfrxcomponent;
begin
    C := Rep.FindObject(name);
    tfrxmemoview(C).memo.Text := val;
end;

procedure TUMain.SetVisible(name: string; val: boolean);

begin
    (Rep.FindObject(name) as tfrxmemoview).Visible := val;
end;

procedure TUMain.BitBtn4Click(Sender: TObject);
begin
    QSearch.Close;
    QSearch.SQL.Clear;
    QSearch.SQL.Add
      ('select tab_num, fam, name, otch,dat_n, n_zach,n_vob, dat_max, n_otdel, fname from student where 1=1 ');
    if ComboBox1.Text <> '' then
        QSearch.SQL.Add(' and n_otdel like ' + Quotedstr(ComboBox1.Text));
    if ComboBox2.Text <> '' then
        QSearch.SQL.Add(' and fname like ' + Quotedstr(ComboBox2.Text));
    if ComboBox3.Text <> '' then
        QSearch.SQL.Add(' and n_vob like ' + Quotedstr(ComboBox3.Text));
    QSearch.Open;
    QSearch.last;
    FillString(StringGrid1, QSearch);
end;

procedure TUMain.BitBtn8Click(Sender: TObject);
var
    i, j: integer;
    f: textfile;
    s: string;
begin
    if Edit7.Text = '' then
        if SaveDialog1.Execute then
            Edit7.Text := SaveDialog1.filename + '.csv'
        else
            exit;
    Assignfile(f, Edit7.Text);
    Rewrite(f);
    DownTable.first;
    while not DownTable.eof do
    begin
        s := '';
        for i := 1 to DownTable.FieldCount - 1 do
            if ((i = 12) or (i = 14) or (i = 7)) then
                continue
            else
                s := s + ';' + DownTable.Fields[i].Asstring;
        delete(s, 1, 1);
        Writeln(f, s);
        DownTable.next;
    end;
    Closefile(f);
end;

procedure TUMain.Button1Click(Sender: TObject);
begin
    If OpenDialog1.Execute() then
        Edit6.Text := OpenDialog1.filename;
end;

procedure TUMain.Button2Click(Sender: TObject);
begin
    Query1.Close;
    if RadioButton1.Checked then
        Query1.ParamByName('d').AsInteger := 1;
    if RadioButton2.Checked then
        Query1.ParamByName('d').AsInteger := 3;
    Query1.Active := true;
    Showmessage('Ready');
end;

procedure TUMain.Button3Click(Sender: TObject);
begin
    Query3.ExecSQL;
    Showmessage('Done');
end;

procedure TUMain.Button4Click(Sender: TObject);
var
    i: integer;
begin
    Query1.first;
    while not Query1.eof do
    begin
        Query2.ParamByName('TAB_NUM').AsInteger := Query1.FieldByName('TAB_NUM')
          .AsInteger;
        Query2.ParamByName('KOD_SP').AsInteger := Query1.FieldByName('KOD_SP')
          .AsInteger;
        Query2.ParamByName('FAM').Asstring := Query1.FieldByName('FAM')
          .Asstring;
        Query2.ParamByName('NAME').Asstring :=
          Query1.FieldByName('NAME').Asstring;
        Query2.ParamByName('OTCH').Asstring :=
          Query1.FieldByName('OTCH').Asstring;
        Query2.ParamByName('DAT_N').AsDate := Query1.FieldByName('DAT_N')
          .AsDateTime;
        Query2.ParamByName('DAT_K').AsDate := Query1.FieldByName('DAT_K')
          .AsDateTime;
        Query2.ParamByName('N_ZACH').AsLargeInt :=
          StrtoInt64(Trim(Query1.FieldByName('N_ZACH').Asstring));
        Query2.ParamByName('N_VOB').Asstring :=
          Query1.FieldByName('N_VOB').Asstring;
        Query2.ParamByName('FNAME').Asstring :=
          Query1.FieldByName('FNAME').Asstring;
        Query2.ParamByName('N_OTDEL').Asstring :=
          Query1.FieldByName('N_OTDEL').Asstring;
        Query2.ParamByName('SIGNATURE').AsBlob :=
          Query1.FieldByName('SIGNATURE').AsBytes;
        Query2.ParamByName('PHOTO').AsBlob :=
          Query1.FieldByName('PHOTO').AsBytes;
        Query2.ParamByName('DAT_MAX').AsDate := Query1.FieldByName('MAX')
          .AsDateTime;
        Query2.ExecSQL;
        Query1.next;
    end;
    Showmessage('Done');
end;

procedure TUMain.Button5Click(Sender: TObject);
begin
    QueryFIO.Close;
    Queryfio.ParamByName('dt').AsDate:=date;
    QueryFIO.Open;
    Queryfio.Last;
    Queryfio.first;
    Showmessage('Done');
end;

procedure TUMain.Button6Click(Sender: TObject);
begin
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('truncate table fio');
    QTemp.ExecSQL;
    Showmessage('Done');
end;

procedure TUMain.Button7Click(Sender: TObject);
begin
    QueryFIO.first;
    while not Queryfio.eof do
    begin
        Qinsfio.ParamByName('TABNUM').AsInteger :=
          QueryFIO.FieldByName('TAB_NUM').AsInteger;

        Qinsfio.ParamByName('IDLANG').AsInteger :=
          QueryFIO.FieldByName('klangvich').AsInteger;

        Qinsfio.ParamByName('FAM').Asstring :=
          QueryFIO.FieldByName('FAM').Asstring;
        Qinsfio.ParamByName('NAME').Asstring :=
          QueryFIO.FieldByName('NAME').Asstring;
        Qinsfio.ParamByName('OTCH').Asstring :=
          QueryFIO.FieldByName('OTCH').Asstring;
        Qinsfio.ExecSQL;
        QueryFIO.next;
    end;
    Showmessage('Done');

end;

procedure TUMain.CheckBox1Click(Sender: TObject);
begin
    if CheckBox1.Checked then
        Panel3.Color := clRed
    else
        Panel3.Color := clCream;
    Panel3.Repaint;
end;

procedure TUMain.CleardownAllExecute(Sender: TObject);
begin
    DownTable.Active := false;
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('delete from prn where 1=1');
    QTemp.ExecSQL;
    DownTable.Active := true;
    DownTable.Refresh;
end;

procedure TUMain.ClearOneExecute(Sender: TObject);
begin
    Edit1.Text := '';
    Edit2.Text := '';
    Edit3.Text := '';
    Edit4.Text := '';
    Edit5.Text := '';
    ClearString(StringGrid1);
    Edit1.SetFocus;
end;

end.