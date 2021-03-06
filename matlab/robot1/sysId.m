clc
close all
clear all 
l1 = 1;
l2 = 4084; %5376 %4197 % long 4727
Ts = 1/90; % in seconds
killerKb = csv2table('data2.csv',l1,l2);  % sysID_long.csv is bad data

output_A = table2array(killerKb(:,2));
output_B = table2array(killerKb(:,4));
input_A = table2array(killerKb(:,6));
input_B = table2array(killerKb(:,8));
control_A = zeros(l2,1);
control_B = zeros(l2,1);

%tempA = input_A;
%tempB = input_B;
%input_A = tempA + tempB; input_B = tempA - tempB;
 
output = [output_A output_B];
input = [input_A input_B];


R = 0.0610; L = 0.28; Num = 300; Kp = 20; Kp1 = 17; Ki = 0.05; 
sumR = 0; sumL = 0; sCR = 0; sCL = 0; CR = 0; CL = 0; CL_pppp = 0; CL_ppp = 0; CL_pp = 0;
CR_pppp = 0; CR_ppp = 0; CR_pp = 0; CL_p = 0; CR_p = 0;
Lerror_ppp = 0; Lerror_pp = 0; Lerror_p = 0; Rerror_ppp = 0; Rerror_pp = 0; Rerror_p = 0;

for(i = l1:l2)
wdr = input_A(i);  
wdl = input_B(i);

wR = output_A(i);    
wL = output_B(i);

Rerror = wdr - wR ; 
Lerror = wdl - wL ;

if ((Rerror < -20)||(Rerror > 20))
  sumR = 0;
  sCR = 0;
end
if ((Rerror > -8)&&(Rerror < 8)&&(sumR ~= Num))
  sumR = sumR + 1;
  sCR = sCR + CR;
  if (sumR == Num)
  CR_p = sCR/Num;
  end
end
if (sumR == Num)
  CR = CR_p + Kp1*(Rerror - Rerror_p)+ Ki*Rerror;
  sCR = 0;  
else
CR = Kp*Rerror ;
end

if ((Lerror < -20)||(Lerror > 20))
  sumL = 0;
  sCL = 0;
end
if ((Lerror > -8)&&(Lerror < 8)&&(sumL ~= Num))
  sumL = sumL + 1;
  sCL = sCL + CL;
  if (sumL == Num)
  CL_p = sCL/Num;
  end
end
if (sumL == Num)
  CL = CL_p + Kp1*(Lerror - Lerror_p)+ Ki*Lerror;
  sCL = 0;  
else
CL = Kp*Lerror ;
end

 CL_pppp = CL_ppp;
  CL_ppp = CL_pp;
  CL_pp = CL_p;

  CR_pppp = CR_ppp; 
  CR_ppp = CR_pp;
  CR_pp = CR_p;

  Lerror_ppp = Lerror_pp;
  Lerror_pp = Lerror_p;
  Lerror_p = Lerror;
  Rerror_ppp = Rerror_pp;
  Rerror_pp = Rerror_p;
  Rerror_p = Rerror; 
  
if (CR >= 400)
CR = 400; 
end
if (CL >= 400)
CL = 400;
end

if (CR <= 0)
CR = 0;
end
if (CL <= 0)
CL = 0;
end
  
PWMR = CR + 100 ;
PWML = CL + 100 ;

CL_p = CL; CR_p = CR; 

if (PWMR>=400)  
    PWMR=400;
end
if (PWMR<=0) 
    PWMR= 0 ;
end
  
if (PWML>=400) 
    PWML=400 ;
end
if (PWML<=0) 
PWML= 0 ;
end

  if (wdr == 0)
  PWMR = 0;
  end
  if (wdl == 0)
  PWML =0;
  end
  
  control_A(i) = PWMR; control_B(i) = PWML;
end

output = [output_A ];
input = [control_A*(12.1/400)];
data = iddata(output,input,Ts);
plot(data);

num = [2 2]; den = [1 2 2]; sys = idtf(num,den); 
sys.Structure.Denominator.Minimum = [1 0 0];
sys.Structure.Denominator.Maximum = [1 1 0.1];
sys.Structure.Denominator.Free = [0 1 1];
sys.Structure.Numerator.Minimum = [0 0];
sys.Structure.Numerator.Maximum = [3 1.5];
sys.Structure.Numerator.Free = [1 1];
sysTF = tfest(data,sys); sysTF = zpk(sysTF);

clf
compare(data,sysTF)

s = tf('s')
sysTf = (2.8766*(s + 0.1448))/((s + 0.5867)*(s + 0.1705))

compare(data,sysTf)

%% Wr response comparison for Paper


