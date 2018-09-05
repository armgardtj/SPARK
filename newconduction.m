l = 1;
x = 10; %x points on ice
y = 10; %y points on ice
yt = y*2-1 %total nodes (ice+hot plate)
cx = l/(x-1);
cy = l/(y-1);
total = x*yt;

kice = 2.22 * 3600; %thermal conductivity of ice at 0C (W/mK)
pice = 917.5; % density of ice at 0C (kg/m^3)
cpice = 2050; %heat capacity of ice at 0C (J/kgK)
Dice = kice/(pice*cpice); %thermal diffusivity
kwater = .561;
pwater = 1000;
cpwater = 4.2176;
Dwater = kwater/(pwater*cpwater);
kal = 205*3600;
pal = 2712;
cpal = 900;
Dal = kal/(pal*cpal);
h = 5 * 3600; %convective heat coefficient in air (W/m^2K)

tdomain = .5;
ct = .001;
tpts = tdomain/ct + 1;

thot=25; %hot temperature (hot plate)
tcold=-1; %cold temperature (ice)
tinf=22; %infinity temperature (air)

T1 = zeros(total,1); %main matrix holding temperatures
T2 = zeros(x,yt); %matrix storing kval's layer of temperatures for mapping

%i = mod(mod(n-1,x*y),x) + 1;
%j = ceil((mod(n-1,x*y)+1)/x);
%k = ceil(n/(x*y));

for n = 1:total; %sets all points to tcold, sets points in contact with hot plate to thot
  j = mod(n-1,yt)+1;
  T1(n) = tcold;
  if (j>y)
      T1(n)=thot;
  end
end
asdfsdaf = reshape(T1, [yt,x]);
for t = 1:tpts
  A=T1;
  for n = 1:total
    i = ceil(n/yt);
    j = mod(n-1,yt)+1;
    
    if (i==1 && j==1) %top left corner (ice)
        A(n)=A(n)+T1(n+1)+T1(n+yt);
        A(n)=A(n)/3;
    elseif (i==1 && j==yt) %bottom left corner (hot plate)
        %A(n)=A(n)+T1(n-1)+T1(n+yt);
        %A(n)=A(n)/3;
        A(n)=thot;
    elseif (i==x && j==1) %top right corner (ice)
        A(n)=A(n)+T1(n+1)+T1(n-yt);
        A(n)=A(n)/3;
    elseif (i==x && j==yt) %bottom right corner (hot plate)
        %A(n)=A(n)+T1(n-1)+T1(n-yt);
        %A(n)=A(n)/3;
        A(n)=thot;
    elseif (j==1) %top edge (ice)
        %A(n)=A(n)+T1(n+1)+T1(n-yt)+T1(n+yt);
        %A(n)=A(n)/4;
        lap = (T1(n+yt) + T1(n-yt) - 2 * T1(n))/cx^2;
        q = h*cx*(tinf-tcold)*ct;
        A(n)=A(n) + ct/p/cp*(kice*lap+q);
    elseif (j==yt) %bottom edge (hot plate)
        %A(n)=A(n)+T1(n-1)+T1(n-yt)+T1(n+yt);
        %A(n)=A(n)/4;
        A(n)=thot;
    elseif (i==1 && j<=y) %left edge (ice)
        %A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n+yt);
        %A(n)=A(n)/4;
        lap = (T1(n+1) + T1(n-1) - 2 * T1(n))/cy^2;
        q = h*cy*(tinf-tcold)*ct;
        A(n)=A(n) + ct/p/cp*(kice*lap+q);
    elseif (i==x && j<=y) %right edge (ice)
        %A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n-yt);
        %A(n)=A(n)/4;
        lap = (T1(n+1) + T1(n-1) - 2 * T1(n))/cy^2;
        q = h*cy*(tinf-tcold)*ct;
        A(n)=A(n) + ct/p/cp*(kice*lap+q);
    elseif (i==1 && j>y) %left edge (hot plate)
        %A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n+yt);
        %A(n)=A(n)/4;
        A(n)=thot;
    elseif (i==x && j>y) %right edge (hot plate)
        %A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n-yt);
        %A(n)=A(n)/4;
        A(n)=thot;
    elseif (j==y) %between ice and hot plate
        A(n)=(kice*T1(n-1)+kal*T1(n+1))/(kal+kice);
    elseif (j < y)
        A(n) = A(n) + ct*Dice*((T1(n+1) + T1(n-1) - 2 * T1(n))/cy^2 + (T1(n+yt) + T1(n-yt) - 2 * T1(n))/cx^2);
    else
      A(n) = A(n) + ct*Dal*((T1(n+1) + T1(n-1) - 2 * T1(n))/cy^2 + (T1(n+yt) + T1(n-yt) - 2 * T1(n))/cx^2);
    end
%    if i == 1 || i == x || j == 1 || j == y || k == 1 || k == z
%      q = h*(T1(n)*tinf);
%      A(n) = A(n)+q;
%    end
    T2(i,j) = A(n);
    end
    T1=A;
    asdfsdaf = reshape(T1, [yt,x]); 
    %above reshapes to view matrix more easily
end

figure;
surf(T2);
colorbar;