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
  NetsPerGen = 50; //the amount od networks per generaton
  networksToSave = 5; // the amount of netwoks who get selected to be the next parents

Type
  tWheightList = Array [1..maxNeurons] of Real;

  tLayerNeuonValues = Array [1..maxneurons] of real;

  tNeuron = Record
    Value   : Real;
    Wheight : tWheightList;
  end;

  tNeuralNetwork = Array [1..Layers,1..maxNeurons] of tNeuron;

  tGradedBrain = Record
    net             : tNeuralNetwork;
    score           : Real;
    place           : Byte;
  end;

  tOneNetworkGeneration = Array [1..NetsPerGen] of tGradedBrain;
Var
  Network : tNeuralNetwork;
  cluster : tOneNetworkGeneration;
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

Function initialiseGeneration(gen:tOneNetworkGeneration):tOneNetworkGeneration;
Var
  i : Byte;
  emptyGradedBrain : tGradedBrain;
Begin
  emptyGradedBrain.score := 0;
  emptyGradedBrain.place := 0;
  emptyGradedBrain.net := InitializeNetwork(emptyGradedBrain.net);


  for i:=1 to length(gen) do Begin
    gen[i].net := InitializeNetwork(emptyGradedBrain.net);
    gen[i].score := 0;
   gen[i].place := 0;
  end;

  Result := gen;
end;

Function setInputNeuronsForGen(gen:tOneNetworkGeneration; inputs:tLayerNeuonValues): tOneNetworkGeneration;
Var
  i : Byte;
Begin
  for i:=1 to Length(gen) Do Begin
   gen[i].net := setInputNeurons(gen[i].net, inputs);
  end;
  result:= gen;
end;

Function calculateGen(gen:tOneNetworkGeneration):tOneNetworkGeneration;
Var
  i : Byte;
Begin
  for i:=1 to length(gen) Do gen[i].net := calculateNetwork(gen[i].net);
  Result := gen;
end;

Function sortGen(gen:tOneNetworkGeneration):tOneNetworkGeneration;
Var
  i,j : Byte;
  hold : tGradedBrain;
Begin
  for i:=1 to length(gen)-1 Do Begin
   For j:=2 to length(gen) Do Begin
   if Gen[i].score<Gen[j].score then Begin
     hold:= Gen[j];
     Gen[j] := Gen[i];
     Gen[i] := hold;
    end
   end;
  end;

  for i:=1 to length(gen) Do gen[i].place := i;

  Result := gen;
end;

Function cleanAndRefillGen(gen:tOneNetworkGeneration; keep:Byte):tOneNetworkGeneration;
Var
  i,s : Byte;
Begin
  s:=0;
  For i:=keep+1 to length(gen) DO begin
    s:=s+1;
    gen[i].net := slightlyChanged(gen[s].net);
    if (s=keep) then s := 0;
  end;

  Result := gen;
end;

Function scoreGen(gen:tOneNetworkGeneration;rightNeuron,wrongNeuron:Byte):tOneNetworkGeneration;
Var
  i : Byte;
Begin
  For i:=1 to length(gen) DO begin
   if HighestOutputNeuron(gen[i].net) = rightNeuron then gen[i].score:=1
   else if HighestOutputNeuron(gen[i].net) = wrongNeuron then gen[i].score :=0
   else gen[i].score :=-1;
  end;
  Result:=gen;
end;

Function amountOfNetsWithScore(gen:tOneNetworkGeneration; score:Real):Byte;
Var
  i,s : Byte;
Begin
  s:=0;
  for i:=1 to length(gen) Do Begin
   if gen[i].score=score Then s:=s+1;
  end;
  Result:=s;
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
 // WriteLn('---------------------------------------------------------');
 //
 // randomize;
 // Writeln( inttostr( length( Network ) ) );
 // Writeln( inttostr( length( Network[1] ) ) );
 //
 // For i:=1 to length(testInputs) DO testInputs[i]:=1;
 //
 //// Network := InitializeNetwork(Network);
 // Network := slightlychanged(Network);
 // Network := setInputNeurons(Network, testInputs);
 // Network := calculateNetwork(Network);
 //
 // testAction := HighestOutputNeuron(Network);
 //
 // Writeln( Floattostr( Network[1,1].wheight[1] ) );
 // Writeln( Floattostr( Network[2,1].Value ) );
 // Writeln( inttostr(testAction));
 //
 // WriteLn('---------------------------------------------------------');
  RandomNumber:=Random(2000000);
  testInputs[1]:=randomNumber;
  For i:=2 to length(testInputs) DO testInputs[i]:=0;

  //cluster := initialiseGeneration(cluster);

  Cluster := setInputNeuronsForGen(cluster, testInputs);

  Cluster := calculateGen(cluster);

  If istGrade(RandomNumber) then Begin
    rightNeuron := 1;
    wrongNeuron := 2;
  end
  else Begin
   rightNeuron := 2;
   WrongNeuron := 1;
   End;


  cluster := scoreGen(cluster,rightNeuron,WrongNeuron);

  Writeln( inttostr(RandomNumber) );
  Writeln( inttostr(rightNeuron) );
  Writeln( Floattostr ((amountOfNetsWithScore(cluster,1))/50) );

  cluster := sortGen(cluster);

  Writeln(inttostr(HighestOutputNeuron(Cluster[1].Net)));

  cluster := cleanAndRefillGen(cluster,amountOfNetsWithScore(cluster,1));

  WriteLn('---------------------------------------------------------');
end;

//===================================================================
//               Ereignisbehandlungsroutinen (EBR)
//-------------------------------------------------------------------
 { TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  cluster := initialiseGeneration(cluster);
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
  For i:=1 to 1000 DO start;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  DisplayNet(cluster[1].Net);
end;

end.

