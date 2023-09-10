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
  tBiases = Array[1..1,1..1] of real;
  // tbiases[number of the origin layer, number of the targeted neuron]

  tLayerWheightList = Array [1..2,1..1] of Real;
  tWholeWheightList = Array [1..1] of tLayerWheightList;
  // tWholeWheightList[number of the origin Layer, number origin Neuron. number of the targeted neuron]

  tNeuron = Record
    Value   : Real;
    Activation_Function : Byte;
  end;

  tNeuronLayer = Array [1..2] of tneuron;
  tNeuronLayers = Array [1..2] of tNeuronLayer;


  tNeuralNetwork = Record
    Biases : tBiases;
    Wheights : tWholeWheightList;
    Neurons :tNeuronLayers;
  end;

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

Function setInputNeurons(net:tNeuralNetwork): tNeuralNetwork;
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
end;

Function Threshhold (x:Real):real;
Begin
  if x<0 then result:=0 else result:=1;
end;

Function Sigmoid(x:Real):Real;
Begin
  Result:=1/(1+Exp(-x));
end;

//################### still need other routines #####################
Function ApplyActivationFunction(x:Real;func:Byte):Real;
Begin
  if func=1 then result:=Threshhold(x)
   else if func=2 then result:=Rectifier(x)
    else if func=3 then result:=Sigmoid(x)
     else Result:= x;
end;

Function ApplyActivationFunction_Neuron(neuron:tneuron):tneuron;
Begin
  neuron.Value:=ApplyActivationFunction(neuron.value,neuron.Activation_Function);
  Result:= neuron;
end;

Function InitializeNetwork (net:tNeuralNetwork):tNeuralNetwork;
Var
  i,j,k : Byte;
Begin
  for i:=1 to length(net.Biases) Do
   Begin
     For j:=1 to Length(net.biases[1]) Do
      net.biases[i,j]:= -0.5;            //changed for testing
   end;

  for i:=1 to length(net.Wheights) Do
   Begin
     For j:=1 to Length(net.Wheights[1]) Do
      Begin
        For k:=1 to Length(net.Wheights[1,1]) Do
          net.Wheights[i,j,k]:= 0.5;     //changed for testing
      end;
   end;

   for i:=1 to length(net.Neurons) Do
   Begin
     For j:=1 to Length(net.Neurons[1]) Do
      Begin
        net.Neurons[i,j].value:= 0;
        net.neurons[i,j].Activation_Function:=1;
        net.neurons[1,j].Activation_Function:=0;
      end;
   end;

  Result:=net;
end;

Function z (net:tNeuralNetwork; i,j:Byte):Real;
Var
  Neuron:tNeuron;
  l : Byte;
Begin

  Neuron:=net.Neurons[i,j];

  Writeln(Floattostr(Neuron.value));
  Writeln('-----');

  for l:=1 to length(net.wheights[1]) DO
    Neuron.value:=Neuron.value + (net.wheights[i-1,l,j] * net.Neurons[i-1,l].value);
  Writeln(Floattostr(Neuron.value));
  Neuron.value:=Neuron.value+net.biases[i-1,j];

  Writeln('------');
  Writeln(Floattostr(Neuron.value));
  Writeln('-------');

  Result:=Neuron.Value;
end;

Function calculateNeuron(net:tNeuralNetwork; i,j:Byte):tNeuron;
Var
  Neuron : tNeuron;
Begin
  Neuron:=net.Neurons[i,j];
  Neuron.value:=0;

  Neuron.value:= z(net,i,j);
  
  Neuron := ApplyActivationFunction_Neuron(Neuron);

  Result:= net.Neurons[i,j];
end;

Function calculateNetwork(net:tNeuralNetwork):tNeuralNetwork;
Var
  i,j:Byte;
Begin
  For i:=2 to length(net.neurons) do
   for j:=1 to length(net.neurons[1]) do
    net.Neurons[i,j]:= calculateNeuron(net,i,j);

  Result:= net;
end;

Procedure DisplayNet(net:tNeuralNetwork);
Var
  i,j:Byte;
Begin
  For i:=1 to length(net.neurons) do
   for j:=1 to length(net.neurons[1]) do Begin
     Writeln(Floattostr(Network.Neurons[i,j].value));
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

  Network.neurons[1,1].value:=1;
  Network.neurons[1,2].value:=1;

  Network:=calculateNetwork(Network);

  DisplayNet(Network);

  //Writeln(Floattostr(Network.Neurons[2,1].value));
  //Writeln(inttostr(length(Network.biases[1,1])));
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

