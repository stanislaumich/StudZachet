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
    InterBaseUniProvider, OracleUniProvider, Vcl.DBGrids, frxDBSet,
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
    FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
    FireDAC.Phys.FBDef,
    FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.Oracle,
    FireDAC.Phys.OracleDef,
    FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
    FireDAC.Comp.DataSet, ZBase, ZPort, ZReader,  ZRClasses, Utils;

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
        Button3: TButton;
        Button4: TButton;
        DataSource1: TDataSource;
        DBGrid1: TDBGrid;
        BitBtn8: TBitBtn;
        Edit7: TEdit;
        SaveDialog1: TSaveDialog;
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
        GroupBox10: TGroupBox;
        RadioButton3: TRadioButton;
        RadioButton4: TRadioButton;
        CheckBox2: TCheckBox;
        FDCFB: TFDConnection;
        FDCORA: TFDConnection;
        BitBtn13: TBitBtn;
        Query2: TFDQuery;
        Query3: TFDQuery;
        QSearch: TFDQuery;
        QMoveDown: TFDQuery;
        QInsFio: TFDQuery;
        QTemp: TFDQuery;
        DownQuery: TFDQuery;
        Prn_Page: TFDTable;
        Edit8: TEdit;
        Label12: TLabel;
        Button9: TButton;
        BitBtn14: TBitBtn;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Panel5: TPanel;
    Label13: TLabel;
    Edit9: TEdit;
    Button8: TButton;
    TabSheet5: TTabSheet;
    GroupBox11: TGroupBox;
    Memo1: TMemo;
    StringGrid2: TStringGrid;
    DateTimePicker2: TDateTimePicker;
    Button10: TButton;
    Button11: TButton;
    Label14: TLabel;
    Label15: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    BitBtn15: TBitBtn;
    ReadChip: TAction;
    GroupBox12: TGroupBox;
    Label16: TLabel;
    ComboBox5: TComboBox;
    BitBtn16: TBitBtn;
    WriteInDoc: TAction;
    Label17: TLabel;
    Label18: TLabel;
    Edit12: TEdit;
    Edit13: TEdit;
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
        procedure DownTable1AfterRefresh(DataSet: TDataSet);
        procedure CleardownAllExecute(Sender: TObject);
        procedure PrepareprintExecute(Sender: TObject);
        procedure MoveDownAllExecute(Sender: TObject);
        procedure Button6Click(Sender: TObject);
        procedure Button5Click(Sender: TObject);
        procedure Button7Click(Sender: TObject);
        procedure RadioButton3Click(Sender: TObject);
        procedure RadioButton4Click(Sender: TObject);
        procedure BitBtn13Click(Sender: TObject);
        procedure DeleteDownOneExecute(Sender: TObject);
        procedure RepPrintPage(Page: TfrxReportPage; CopyNo: Integer);
        procedure Button8Click(Sender: TObject);
        procedure Button9Click(Sender: TObject);
        procedure BitBtn10Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure ReadChipExecute(Sender: TObject);
    procedure WriteInDocExecute(Sender: TObject);
    private
        { Private declarations }
    public
        Procedure ClearString(StringGrid1: TStringGrid);
        procedure FillString(StringGrid1: TStringGrid; QSearch: TFDQuery);
        procedure Autow(Grid: TStringGrid);
        procedure SetValue(name: string; val: string);
        procedure SetVisible(name: string; val: boolean);
        Procedure LoadIni;
        Procedure SaveIni;
        function MakePRN: boolean; // true - breakprint
        function Askreprint: Integer;
        procedure SavePrintedToFile();
        procedure FillStringBSO(StringGrid1: TStringGrid; QSearch: TFDQuery);
    end;

var
    UMain: TUMain;
    searchlang: Integer;


  // +++++++++++++++++++++++++++++
const
  RdPortType = ZP_PORT_COM;


var
  g_hRd: THandle;
  RdPortName:string;// = 'COM3';
  // ++++++++++++++++++++++++++++++


implementation

{$R *.dfm}

uses UAskreprint;

procedure TUMain.Autow(Grid: TStringGrid);
var
    i, j, temp, max: Integer;
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
    Edit8.Text := ini.ReadString('ZACH', 'repfile', '');
    Edit9.Text := ini.ReadString('BILET', 'shablon', '');
    searchlang := ini.ReadInteger('OTHER', 'searchlang', 6);
    if searchlang = 6 then
        RadioButton3.Checked := true;
    if searchlang = 131 then
        RadioButton4.Checked := true;

    ini.free;
end;

procedure TUMain.MoveDownAllExecute(Sender: TObject);
var
    i: Integer;
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
    tsearchlang: Integer;
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
        tsearchlang := searchlang;
        if CheckBox2.Checked then
            tsearchlang := 6;
        QMoveDown.ParamByName('idlang').asinteger := tsearchlang;

        QMoveDown.ExecSQL;
        if Not DownQuery.Active then
            DownQuery.Active := true;
        DownQuery.Refresh;
        StatusBar1.Panels[0].Text := '�������� ' + StringGrid1.cells
          [1, StringGrid1.row] + ' ' + StringGrid1.cells[2, StringGrid1.row];
    end
    else
        StatusBar1.Panels[0].Text := '��� ���� ' + StringGrid1.cells
          [1, StringGrid1.row] + ' ' + StringGrid1.cells[2, StringGrid1.row];

end;

procedure TUMain.SavePrintedToFile();
var
    i, j: Integer;
    s: string;
    f: textfile;
begin
{$I-}
    Assignfile(f, Edit8.Text);
    Append(f);
    if IOResult <> 0 then
        rewrite(f);
    Prn_Page.first;
    while not Prn_Page.eof do
    begin
        s := Prn_Page.Fields[0].Asstring + ';' + Prn_Page.Fields[1].Asstring +
          ';' + Prn_Page.Fields[2].Asstring + ' ' + Prn_Page.Fields[3].Asstring;
        s := s + ' ' + Prn_Page.Fields[4].Asstring + '4' + Prn_Page.Fields
          [5].Asstring;

        for i := 6 to Prn_Page.FieldCount - 1 do
            if ((i = 12) or (i = 14) or (i = 7)) then
                continue
            else
                s := s + ';' + Prn_Page.Fields[i].Asstring;
        delete(s, 1, 1);
        Writeln(f, s);
        Prn_Page.next;
    end;

    Closefile(f);
{$I+}
end;

function TUMain.Askreprint: Integer;
var
    i: Integer;
begin
    FaskReprint.ShowModal;
    Askreprint := FaskReprint.tag;
end;

function TUMain.MakePRN: boolean; // true - breakprint
var
    i: Integer;
    ask: Integer;
begin
    // sleep(1000);
    Prn_Page.Close;
    Prn_Page.Open;
    ask := 1;

    while ask = 1 do // ������������!!!
    begin
        // Rep.PrepareReport()
        if Rep.PrepareReport() then
            Rep.Print;
        ask := Askreprint;
    end;
    SavePrintedToFile();
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('truncate table prn_page');
    QTemp.ExecSQL;
    MakePRN := ask = 2; // ������� ��������
end;

procedure TUMain.PrepareprintExecute(Sender: TObject);
var
    i: Integer;
    ex: boolean;
begin
    if CheckBox1.Checked then showmessage('���������� ��������!!!');
    // Rep.LoadFromFile(edit6.text{'s:\StudZachet\ZACHx4GOOD1.fr3'});
    // SetVisible('Memo21', CheckBox1.Checked);
    // SetValue('Memo19', DatetoStr(DateTimePicker1.Date));
    DownQuery.first;
    // PageControl1.ActivePageIndex := 1;
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('truncate table prn_page');
    QTemp.ExecSQL;
    i := 0;
    ex := true;
    While not DownQuery.eof do
    begin
        QTemp.Close;
        QTemp.SQL.Clear;
        QTemp.SQL.Add('insert into prn_page select * from prn where tab_num=' +
          DownQuery.FieldByName('tab_num').Asstring);
        QTemp.ExecSQL;
        if (i mod 4 = 3) then
        begin
            if MakePRN then
            begin
                ex := false;
                break;
            end;
        end;
        DownQuery.next;
        i := i + 1;
    end;
    if (i mod 4 <> 0) and ex then // ������� ��� ��� �������� ����������
    begin
        MakePRN;
    end;
    {
      QTemp.Close;
      QTemp.SQL.Clear;
      QTemp.sql.Add('truncate table prn_page');
      QTemp.ExecSQL;
      i:=0;
      while (not DownQuery.eof and (i<4)) do
      // ��������� 4 ��������, ��� ������� ������
      begin


      i:=i+1;
      DownQuery.Next;
      end;
    }

end;

procedure TUMain.RadioButton3Click(Sender: TObject);
begin
    if RadioButton3.Checked then
        searchlang := 6;
end;

procedure TUMain.RadioButton4Click(Sender: TObject);
begin
    if RadioButton4.Checked then
        searchlang := 131;
end;

procedure TUMain.RadioButton5Click(Sender: TObject);
begin
if Radiobutton5.Checked then Panel5.color:=clGradientActiveCaption;
end;

procedure TUMain.RadioButton6Click(Sender: TObject);
begin
if Radiobutton6.Checked then Panel5.color:=clYellow;
end;

procedure TUMain.ReadChipExecute(Sender: TObject);
var
  rOpen: TZR_RD_Open_Params;
  rRdInf: TZR_Rd_Info;
  rInfo: TZR_Card_Info;
  s: String;
  hr: HResult;
  ss:string;
begin
// ��� �� ��������� ��� � edit11

RdPortName := ComboBox5.Text;//'COM3';

  CheckZRError(ZR_Initialize(ZP_IF_NO_MSG_LOOP));
  g_hRd := 0;

  try
    Memo1.Lines.Add(format('Open reader (%s)...', [RdPortName]));
    FillChar(rOpen, SizeOf(rOpen), 0);
    rOpen.pszName := PChar(RdPortName);
    rOpen.nType := RdPortType;
    FillChar(rRdInf, SizeOf(rRdInf), 0);
    CheckZRError(ZR_Rd_Open(g_hRd, rOpen, @rRdInf));
    if (rRdInf.nType <> ZR_RD_Z2M) and (rRdInf.nType <> ZR_RD_M3N) and
      (rRdInf.nType <> ZR_RD_CPZ2MF) and (rRdInf.nType <> ZR_RD_Z2MFI) then
    begin
      Memo1.Lines.Add('It is not Mifare Reader!');
      Readln;
      exit;
    end;

    CheckZRError(ZR_Rd_SearchCards(g_hRd, 1));
    hr := ZR_Rd_FindNextCard(g_hRd, @rInfo);
    CheckZRError(hr);

        Memo1.Lines.Add(format('%s %s', [
            CardTypeStrs[rInfo.nType], ZKeyNumToStr(rInfo.nNum, rInfo.nType)]));
      Edit11.Text:=ZKeyNumToStr(rInfo.nNum, rInfo.nType);
      ss:=EDit11.Text;
      if ss[1]='[' then
       begin
         Edit11.Text:=('�� �������');
       end;
    if g_hRd <> 0 then
      ZR_CloseHandle(g_hRd);
    ZR_Finalyze();

  Except
   on E:Exception do
    begin
     E:=Nil;
     ShowMessage('��� ���� � �����������, ���� �� ��������� �����������');
     if g_hRd <> 0 then
      ZR_CloseHandle(g_hRd);
    ZR_Finalyze();
    end;
  end;







end;

procedure TUMain.RepPrintPage(Page: TfrxReportPage; CopyNo: Integer);
begin
    // ShowMessage('������� ��������');
end;

Procedure TUMain.SaveIni;
var
    s: string;
    ini: tinifile;
begin
    ini := tinifile.Create(extractfilepath(Application.ExeName) +
      '\zachetka.ini');
    ini.WriteString('ZACH', 'shablon', Edit6.Text);
    ini.WriteString('ZACH', 'repfile', Edit8.Text);
    ini.WriteInteger('OTHER', 'searchlang', searchlang);
    ini.WriteString('BILET', 'shablon', Edit9.Text);
    ini.free;
end; // -------------------------------------------------------------------------------------------

Procedure TUMain.ClearString(StringGrid1: TStringGrid);
var
    i, j: Integer;
begin
    for i := 0 to StringGrid1.colcount - 1 do
        for j := 0 to StringGrid1.rowcount - 1 do
            StringGrid1.cells[i, j] := '';
    StringGrid1.rowcount := 2;
end;

procedure TUMain.DeleteDownOneExecute(Sender: TObject);
begin
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('delete from prn where tab_num=' + DownQuery.FieldByName
      ('tab_num').Asstring);
    QTemp.ExecSQL;
    DownQuery.Refresh;
end;

procedure TUMain.DownTable1AfterRefresh(DataSet: TDataSet);
begin
    DownQuery.last;
    StatusBar1.Panels[1].Text := '� �������: ' +
      inttostr(DownQuery.RecordCount);
end;

procedure TUMain.FillString(StringGrid1: TStringGrid; QSearch: TFDQuery);
var
    i, j: Integer;
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
    i: Integer;
    f: textfile;
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
    Assignfile(f, extractfilepath(Application.ExeName) + '\log.txt');
{$I-}
    Append(f);
    if IOResult <> 0 then
        rewrite(f);
    Writeln(f, datetostr(Date));
    Closefile(f);
{$I+}
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
       PageControl1.ActivePageIndex := 0;
end;

procedure TUMain.SearchOneExecute(Sender: TObject);
var
    tsearchlang: Integer;
begin
    QSearch.Close;
    QSearch.SQL.Clear;
    QSearch.SQL.Add
      ('select s.tab_num, f.fam, f.name, f.otch,s.dat_n, s.n_zach,s.n_vob, s.dat_max, s.n_otdel, s.fname from student s, fio f where ');
    QSearch.SQL.Add('f.tabnum=s.tab_num and idlang=' +
      inttostr(searchlang) + ' ');
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

procedure TUMain.WriteInDocExecute(Sender: TObject);
begin
// �������, ��� �� �� ��� � ����
//

// ���� �� �� ��������
end;

procedure TUMain.BitBtn10Click(Sender: TObject);

begin
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('select * from prn');
    QTemp.Open;
    if QTemp.RecordCount<=0 then exit;
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('truncate table prn_page');
    QTemp.ExecSQL;
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('insert into prn_page select * from prn where tab_num=' +
      DownQuery.FieldByName('tab_num').Asstring);
    QTemp.ExecSQL;
    Prn_Page.Close;
    Prn_Page.Open;
    Rep.Clear;
    if radiobutton5.Checked then
     begin
    Rep.LoadFromFile(Edit6.Text { 's:\StudZachet\ZACHx4GOOD1.fr3' } );
    SetVisible('Memo21', CheckBox1.Checked);
    SetValue('Memo19', datetostr(DateTimePicker1.Date));
    end
    else
    begin
     Rep.LoadFromFile(Edit6.Text { 's:\StudZachet\ZACHx4GOOD1.fr3' } );
    SetVisible('Memo21', CheckBox1.Checked);
    SetValue('Memo19', datetostr(DateTimePicker1.Date));
    end;
    Rep.PrepareReport(true);
    Rep.ShowPreparedReport;
    // rep.RefreshActivePreviewedReport;
    // Rep.Print;
    PageControl1.ActivePageIndex := 1;
end;

procedure TUMain.BitBtn13Click(Sender: TObject);
begin
    if DownQuery.Active then
        DownQuery.Refresh
    else
        DownQuery.Active := true;

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
    i, j: Integer;
    f: textfile;
    s: string;
begin
    if Edit7.Text = '' then
        if SaveDialog1.Execute then
            Edit7.Text := SaveDialog1.filename + '.csv'
        else
            exit;
    Assignfile(f, Edit7.Text);
    rewrite(f);
    DownQuery.first;
    while not DownQuery.eof do
    begin
        s := DownQuery.Fields[1].Asstring + ';' + DownQuery.Fields[2].Asstring +
          ';' + DownQuery.Fields[3].Asstring;
        s := s + ' ' + DownQuery.Fields[4].Asstring + ' ' + DownQuery.Fields
          [5].Asstring;

        for i := 6 to DownQuery.FieldCount - 1 do
            if ((i = 12) or (i = 14) or (i = 7)) then
                continue
            else
                s := s + ';' + DownQuery.Fields[i].Asstring;
        delete(s, 1, 1);
        Writeln(f, s);
        DownQuery.next;
    end;
    Closefile(f);
end;

procedure TUMain.FillStringBSO(StringGrid1: TStringGrid; QSearch: TFDQuery);
var
    i, j: Integer;
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
    end;
    Autow(StringGrid1);
end;

procedure TUMain.Button11Click(Sender: TObject);
begin
QTemp.Close;
QTemp.SQL.Clear;
QTemp.SQL.Add('select f.tabnum,nzach, getfio(f.tabnum,6) fio,nbso,nchip from sdoc d, fio f where ');
QTemp.SQL.Add('f.tabnum=d.tabnum and f.idlang=6');
QTemp.Open();
FillStringBSO(Stringgrid2,QTemp);
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
        Query1.ParamByName('d').asinteger := 1;
    if RadioButton2.Checked then
        Query1.ParamByName('d').asinteger := 3;
    Query1.Active := true;
    ShowMessage('Ready');
end;

procedure TUMain.Button3Click(Sender: TObject);
begin
    Query3.ExecSQL;
    ShowMessage('Done');
end;

procedure TUMain.Button4Click(Sender: TObject);
var
    i: Integer;
begin
    Query1.first;
    while not Query1.eof do
    begin
        Query2.ParamByName('TAB_NUM').asinteger := Query1.FieldByName('TAB_NUM')
          .asinteger;
        Query2.ParamByName('KOD_SP').asinteger := Query1.FieldByName('KOD_SP')
          .asinteger;
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
          Query1.FieldByName('SIGNATURE').AsVariant;
        Query2.ParamByName('PHOTO').AsBlob := Query1.FieldByName('PHOTO')
          .AsVariant;
        Query2.ParamByName('DAT_MAX').AsDate := Query1.FieldByName('MAX')
          .AsDateTime;
        Query2.ExecSQL;
        Query1.next;
    end;
    ShowMessage('Done');
end;

procedure TUMain.Button5Click(Sender: TObject);
begin
    QueryFIO.Close;
    QueryFIO.ParamByName('dt').AsDate := Date;
    QueryFIO.Open;
    QueryFIO.last;
    QueryFIO.first;
    ShowMessage('Done');
end;

procedure TUMain.Button6Click(Sender: TObject);
begin
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('truncate table fio');
    QTemp.ExecSQL;
    ShowMessage('Done');
end;

procedure TUMain.Button7Click(Sender: TObject);
begin
    QueryFIO.first;
    while not QueryFIO.eof do
    begin
        QInsFio.ParamByName('TABNUM').asinteger :=
          QueryFIO.FieldByName('TAB_NUM').asinteger;

        QInsFio.ParamByName('IDLANG').asinteger :=
          QueryFIO.FieldByName('klangvich').asinteger;

        QInsFio.ParamByName('FAM').Asstring :=
          QueryFIO.FieldByName('FAM').Asstring;
        QInsFio.ParamByName('NAME').Asstring :=
          QueryFIO.FieldByName('NAME').Asstring;
        QInsFio.ParamByName('OTCH').Asstring :=
          QueryFIO.FieldByName('OTCH').Asstring;
        QInsFio.ExecSQL;
        QueryFIO.next;
    end;
    ShowMessage('Done');

end;

procedure TUMain.Button8Click(Sender: TObject);
begin
  If OpenDialog1.Execute() then
        Edit9.Text := OpenDialog1.filename;
end;

procedure TUMain.Button9Click(Sender: TObject);
begin
    if OpenDialog1.Execute() then
    begin
        Edit8.Text := OpenDialog1.filename;
    end;
end;

procedure TUMain.CheckBox1Click(Sender: TObject);
begin
    if CheckBox1.Checked then
        Panel3.Color := clRed
    else
        Panel3.Color := clCream;
    Panel3.Repaint;

    BitBtn10Click(CheckBox1);
end;

procedure TUMain.CleardownAllExecute(Sender: TObject);
begin
    DownQuery.Active := false;
    QTemp.Close;
    QTemp.SQL.Clear;
    QTemp.SQL.Add('delete from prn where 1=1');
    QTemp.ExecSQL;
    DownQuery.Active := true;
    DownQuery.Refresh;
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
