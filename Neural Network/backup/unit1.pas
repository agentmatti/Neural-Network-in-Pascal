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
  Layers     = 5; //amout of layers
  maxNeurons = 4; //max amount of Neurons in a layer
  delta      = 0.5; // the max amount the network changes
  decimals   = 5; //the amount of decimal-places

Type
  tWheightList = Array [1..maxNeurons] of Real;

  tLayerNeuonValues = Array [1..maxneurons] of real;

  tNeuron = Record
    Value   : Real;
    Wheight : tWheightList;
  end;

  tNeuralNetwork = Array [1..Layers,1..maxNeurons] of tNeuron;

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
Var
  i,j,k : Byte;
  smallchange : Real;
  prefix : shortint;
  Longdelta : integer;
Begin

  For i:=1 to length(net) Do Begin
    For j:=1 to length(net[1]) Do Begin
      For k:=1 to length(net[1,1].Wheight) Do
        Begin
        longdelta := round(Delta*1000);
        smallchange := (Random(longdelta)-(longdelta/2) )/ (1000);
        //prefix := (Random(1)*2)-1;
        net[i,j].Wheight[k] := net[i,j].Wheight[k] + smallchange; //* prefix;
      end;

    end;
  end;
  Result:=net;
end;

Function setInputNeurons(net:tNeuralNetwork; inputs:tLayerNeuonValues): tNeuralNetwork;
Var
  i : Byte;
Begin
  for i:= 1 to length(net[1]) Do Begin
    net[1,i].Value:=Inputs[i];
  end;
  Result:=net;
end;

Function LowestOutputValue(Net:tNeuralNetwork):Real;
Var
  i : Byte;
  lowest : Real;
Begin
  lowest:= 0;
  for i:=1 to length(net[1]) Do Begin
    if lowest>net[length(net),i].value then lowest := net[length(net),i].value;
  end;
  Result:=Lowest;
end;

Function istGrade(Number:longword):Boolean;
Begin
  if ((number Div 2)*2)= number then Result:=true
  else Result:= false;
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
Var
 testInputs : tLayerNeuonValues;
 i,rightNeuron, WrongNeuron : Byte;
 RandomNumber : longword;
begin
  WriteLn('---------------------------------------------------------');


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

