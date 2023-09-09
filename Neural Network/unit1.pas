unit Unit1;

{$mode objfpc}{$H+}
{$AppType Console}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
//===================================================================
// Coder-Name: Agent_Matti
//===================================================================
//               eigene globale Deklarationen
//-------------------------------------------------------------------
Type
  tWheightList = Array [1..1] of Real;

  tNeuron = Record
    Value   : Real;
    Activation_Function : Byte;
  end;

  tNeuralNetwork = 0;

Var
  Network : tNeuralNetwork;
//===================================================================
//               eigene coole abgeschlossene Routinen
//-------------------------------------------------------------------

//################### stand alone rouitenes #########################

Function Runden(z:REAL;s:BYTE):REAL;
Var rh:LONGWORD;
Var i:BYTE;
begin
  rh:=1;
  For i:=1 TO s do rh:=rh*10;
  Result:=((round(z*rh))/rh);
end;

Function slightlyChanged(Net:tNeuralNetwork):tneuralNetwork;
Begin
  Result:=net;
end;

Function setInputNeurons(net:tNeuralNetwork; inputs:tLayerNeuonValues): tNeuralNetwork;
Begin
  Result:=net;
end;

Function istGrade(Number:longword):Boolean;
Begin
  if ((number Div 2)*2)= number then Result:=true
  else Result:= false;
end;

Function Rectifier(x:Real):Real;
Begin
  if x>0 then result:=x else result:=0;
  result:= max(x,0);
end;

//################### still need other routines #####################

Function InitializeNetwork (net:tNeuralNetwork):tNeuralNetwork;
Begin
  Result:=net;
end;

Function claculateNeuron(net:tNeuralNetwork; i,j:Byte):tNeuron;
Begin
  Result:= net[i,j];
end;

Function calculateNetwork(net:tNeuralNetwork):tNeuralNetwork;
Begin
  Result:= net;
end;

Procedure DisplayNet(net:tNeuralNetwork);
Begin

end;

//===================================================================
//               zusammenfassende Hilfsroutinen
//-------------------------------------------------------------------

Procedure start;
Var i:Byte;
begin
  WriteLn('---------------------------------------------------------');
  Network:=InitializeNetwork(Network);

  WriteLn('---------------------------------------------------------');
end;

//===================================================================
//               Ereignisbehandlungsroutinen (EBR)
//-------------------------------------------------------------------
 { TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  start;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  start;
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
 i : Longword;
begin
  For i:=1 to 10000 DO start;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
end;

end.

