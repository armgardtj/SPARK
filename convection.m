l = 1;
x = 10; %x-direction points
y = 10; %y-direction points
z = 10; %z-direction points
cx = 1/(x-1); %change in x
cy = 1/(y-1); %change in y
cz = 1/(z-1); %change in z
total = x * y * z;

kice = 2.22 * 3600; %thermal conductivity of ice at 0C (W/mK)
p = 917.5; % density of ice at 0C (kg/m^3)
cp = 2050; %heat capacity of ice at 0C (J/kgK)
D = kice/(p*cp); %thermal diffusivity
h = 5 * 3600; %convective heat coefficient in air (W/m^2K)

tdomain = 10;
ct = .1;
tpts = tdomain/ct + 1;

thot=1; %hot temperature (hot plate)
tcold=-1; %cold temperature (ice)
tinf=22; %infinity temperature (air)

T1 = zeros(total,1); %main matrix holding temperatures
T2 = zeros(x,y); %matrix storing kval's layer of temperatures for mapping
T3x = zeros(tpts);
T3y = zeros(tpts);

zval = 0.5;
kval = floor(zval / cz) + 1;

for n = 1:total; %sets all points to tcold, sets points in contact with hot plate to thot
  i = mod(mod(n-1,x*y),x) + 1;
  T1(n) = tcold;
  if (i==x)
      T1(n)=thot;
  end
end

for t = 1:tpts
  A=T1;
  for n = 1:total
    i = mod(mod(n-1,x*y),x) + 1;
    j = ceil((mod(n-1,x*y)+1)/x);
    k = ceil(n/(x*y));
    v = 6;
    
    if (i==1 && j==1 && k==1) %top left front corner
        A(n)=A(n)+T1(n+1)+T1(n+x)+T1(n+x*y);
        A(n)=A(n)/4;
    elseif (i==x && j==1 && k==1) %bottom left front corner
        A(n)=A(n)+T1(n-1)+T1(n+x)+T1(n+x*y);
        A(n)=A(n)/4;
    elseif (i==1 && k==1 && j==y) %top right front corner
        A(n)=A(n)+T1(n+1)+T1(n-x)+T1(n+x*y);
        A(n)=A(n)/4;
    elseif (i==x && j==y && k==1) %bottom right front corner
        A(n)=A(n)+T1(n-1)+T1(n-x)+T1(n+x*y);
        A(n)=A(n)/4;
    elseif (k==z && i==1 && j==1) %top left back corner
        A(n)=A(n)+T1(n+1)+T1(n+x)+T1(n-x*y);
        A(n)=A(n)/4;
    elseif (k==z && i==x && j==1) %bottom left back corner
        A(n)=A(n)+T1(n-1)+T1(n+x)+T1(n-x*y);
        A(n)=A(n)/4;
    elseif (k==z && i==1 && j==y) %top right back corner
        A(n)=A(n)+T1(n+1)+T1(n-x)+T1(n-x*y);
        A(n)=A(n)/4;
    elseif (k==z && i==x && j==y) %bottom right back corner
        A(n)=A(n)+T1(n-1)+T1(n-x)+T1(n-x*y);
        A(n)=A(n)/4;
    elseif (i==1 && k==1) %top front edge
        A(n)=A(n)+T1(n+1)+T1(n-x)+T1(n+x)+T1(n+x*y);
        A(n)=A(n)/5;
    elseif (i==x && k==1) %bottom front edge
        A(n)=A(n)+T1(n-1)+T1(n-x)+T1(n+x)+T1(n+x*y);
        A(n)=A(n)/5;
    elseif (j==1 && k==1) %left front edge
        A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n+x)+T1(n+x*y);
        A(n)=A(n)/5;
    elseif (j==y && k==1) %right front edge
        A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n-x)+T1(n+x*y);
        A(n)=A(n)/5;
    elseif (i==1 && j==1) %left top edge
        A(n)=A(n)+T1(n+1)+T1(n+x)+T1(n+x*y)+T1(n-x*y);
        A(n)=A(n)/5;
    elseif (i==1 && j==y) %right top edge
        A(n)=A(n)+T1(n+1)+T1(n-x)+T1(n+x*y)+T1(n-x*y);
        A(n)=A(n)/5;
    elseif (i==x && j==1) %left bottom edge
        A(n)=A(n)+T1(n-1)+T1(n+x)+T1(n+x*y)+T1(n-x*y);
        A(n)=A(n)/5;
    elseif (i==x && j==y) %right bottom edge
        A(n)=A(n)+T1(n-1)+T1(n-x)+T1(n+x*y)+T1(n-x*y);
        A(n)=A(n)/5;
    elseif (i==1 && k==z) %top back edge
        A(n)=A(n)+T1(n+1)+T1(n-x)+T1(n+x)+T1(n-x*y);
        A(n)=A(n)/5;
    elseif (i==x && k==z) %bottom back edge
        A(n)=A(n)+T1(n-1)+T1(n-x)+T1(n+x)+T1(n-x*y);
        A(n)=A(n)/5;
    elseif (j==1 && k==z) %left back edge
        A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n+x)+T1(n-x*y);
        A(n)=A(n)/5;
    elseif (j==y && k==z) %right back edge
        A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n-x)+T1(n-x*y);
        A(n)=A(n)/5;
    elseif (i==1) %top side
%        A(n)=A(n)+T1(n+1)+T1(n+x)+T1(n-x)+T1(n+x*y)+T1(n-x*y);
%        A(n)=A(n)/6;
        lap = (T1(n+x) + T1(n-x) - 2 * T1(n))/cy^2 + (T1(n+x*y) + T1(n - x*y) - 2 * T1(n))/cz^2;
        q = h*cx*cy*(tinf-tcold)*ct;
        A(n)=A(n) + ct/p/cp*(kice*lap+q);
    elseif (i==x) %bottom side
        lap = (T1(n+x) + T1(n-x) - 2 * T1(n))/cy^2 + (T1(n+x*y) + T1(n - x*y) - 2 * T1(n))/cz^2;
        A(n)=A(n)+T1(n-1)+T1(n+x)+T1(n-x)+T1(n+x*y)+T1(n-x*y);
        A(n)=A(n) + ct/p/cp*(kice*lap+q);
    elseif (j==1) %left side
%        A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n+x)+T1(n+x*y)+T1(n-x*y);
%        A(n)=A(n)/6;
        lap = (T1(n+1) + T1(n-1) - 2 * T1(n))/cx^2 + (T1(n+x*y) + T1(n - x*y) - 2 * T1(n))/cz^2;
        q = h*cx*cy*(tinf-tcold)*ct;
        A(n)=A(n) + ct/p/cp*(kice*lap+q);
    elseif (j==y) %right side
%        A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n-x)+T1(n+x*y)+T1(n-x*y);
%        A(n)=A(n)/6;
        lap = (T1(n+1) + T1(n-1) - 2 * T1(n))/cx^2 + (T1(n+x*y) + T1(n - x*y) - 2 * T1(n))/cz^2;
        q = h*cx*cy*(tinf-tcold)*ct;
        A(n)=A(n) + ct/(p*cp)*(kice*lap+q);
    elseif (k==1) %front side
%        A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n+x)+T1(n-x)+T1(n+x*y);
%        A(n)=A(n)/6;
        lap = (T1(n+1) + T1(n-1) - 2 * T1(n))/cx^2 + (T1(n+x) + T1(n-x) - 2 * T1(n))/cy^2;
        q = h*cx*cy*(tinf-tcold)*ct;
        A(n)=A(n) + ct/p/cp*(kice*lap+q);
    elseif (k==z) %back side
%        A(n)=A(n)+T1(n+1)+T1(n-1)+T1(n+x)+T1(n-x)+T1(n-x*y);
%        A(n)=A(n)/6;
        lap = (T1(n+1) + T1(n-1) - 2 * T1(n))/cx^2 + (T1(n+x) + T1(n-x) - 2 * T1(n))/cy^2;
        q = h*cx*cy*(tinf-tcold)*ct;
        A(n)=A(n) + ct/p/cp*(kice*lap+q);
    else
        A(n) = A(n) + D*ct*((T1(n+1) + T1(n-1) - 2 * T1(n))/cx^2 + (T1(n+x) + T1(n-x) - 2 * T1(n))/cy^2 + (T1(n+x*y) + T1(n - x*y) - 2 * T1(n))/cz^2);
    end
%    if i == 1 || i == x || j == 1 || j == y || k == 1 || k == z
%      q = h*(T1(n)*tinf);
%      A(n) = A(n)+q;
%    end
    if (i==x) %resets all points on hot plate to thot
      A(n)=thot;
    end
    if (k == kval) %checks to see if node is to be mapped
      T2(i,j) = A(n);
    end
    end
    T1=A;
    asdfsdaf = reshape(T1, [x,y,z]);
    %above reshapes to view matrix more easily
    T3x(t) = (t-1) * ct;
    T3y(t) = T2(kval,kval);
end


%plot(T3x,T3y);

figure;
surf(T2);
colorbar;