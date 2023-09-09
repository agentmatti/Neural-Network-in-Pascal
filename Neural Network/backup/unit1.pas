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
Const

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
Var
  emptyNeuron:tNeuron;
  i,j:Byte;
Begin
  //ein leeres neuron erstellen um damit das netzwerk erfüllen
  emptyNeuron.Value:=0;
  for i:=1 to Length(emptyNeuron.Wheight) Do Begin
    emptyNeuron.Wheight[i] := 0;
  end;

  // das netzwerk mit leeren Neuronen füllen
  For i:=1 to length(net) Do Begin
    For j:=1 to length(net[1]) Do net[i,j]:= emptyNeuron;
  end;

  // das net nun bisl verändern
  net := slightlyChanged(net);

  Result:=net;
end;

Function claculateNeuron(net:tNeuralNetwork; i,j:Byte):tNeuron;
Var
  k:Byte;
Begin
  net[i,j].value:=0;
  for k:=1 to length(net) Do Begin
    net[i,j].value:= net[i,j].value + net[i-1,k].value * net[i-1,k].Wheight[j];
  end;
 // net[i,j].value := Runden(net[i,j].value, decimals);

  Result:= net[i,j];
end;

Function calculateNetwork(net:tNeuralNetwork):tNeuralNetwork;
Var
  i,j : Byte;
Begin
  For i:=2 to length(net) Do Begin
    For j:=1 to length(net[1]) Do Begin
      Net[i,j]:= claculateNeuron(net,i,j)
      //For k:=1 to length(net[1,1].Wheight) Do
    end;
  end;
  Result:= net;
end;

Function HighestOutputValue(Net:tNeuralNetwork):Real;
Var
  i : Byte;
  highest : Real;
Begin
  highest:= LowestOutputValue(Net);
  for i:=1 to length(net[1]) Do Begin
    if highest<net[length(net),i].value then highest := net[length(net),i].value;
  end;
  result:=highest;
end;

Function HighestOutputNeuron (Net:tNeuralNetwork):Byte;
Var
  i,s : Byte;
  highest : Real;
  bestactions : Array [1..maxneurons] of Byte;
Begin
  s:=0;
  highest:= HighestOutputValue(net);
  for i:=1 to length(net[1]) Do Begin
    if highest=net[length(net),i].value then Begin
      s:=s+1;
      bestactions[s]:=i;
    end;
  end;
  if s>1 then Result:= Length(net[1])+1
  else Result:= bestactions[s];
end;

Procedure DisplayNet(net:tNeuralNetwork);
Var
  i,j,k : Byte;
Begin
  for i:=1 to length(net) Do Begin
   For j:=1 to length(net[1]) Do begin
    For k:=1 to length(net[1,1].Wheight) DO Begin
     Writeln('layer '+Inttostr(i)+'; neuron '+Inttostr(j)+'; wheight '+Inttostr(k)+' Value '+Floattostr(net[i,j].Wheight[k]));
    end;
   end;
  end;
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

