domain = 1;
deltax = .1;
xpts = domain/deltax + 1;
ypts = domain/deltax + 1;
zpts = domain/deltax + 1;
numPts = xpts * ypts * zpts;

D = 0.1;

tdomain = 0.5;
deltat = .01;
tpts = tdomain/deltat + 1;

T1 = zeros(numPts);
T2 = zeros(xpts,ypts);
T3x = zeros(tpts);
T3y = zeros(tpts);

zval = 0.5;
kval = floor(zval / deltax) + 1;

for x = 1:numPts;
  k = ceil(x/(xpts*ypts));
  j = ceil((mod(x-1,xpts*ypts)+1)/xpts);
  i = mod(mod(x-1,xpts*ypts),xpts) + 1;
  
  T1(x) = 0;
  if i == 1 || i == xpts || j == 1 || j == ypts || k == 1 || k == zpts
    T1(x) = 1;
    end
    end


for t = 1:tpts
  for x = 1:numPts
    k = ceil(x/(xpts*ypts));
    j = ceil((mod(x-1,xpts*ypts)+1)/xpts);
    i = mod(mod(x-1,xpts*ypts),xpts) + 1;
    
    if !(i == 1 || i == xpts || j == 1 || j == ypts || k == 1 || k == zpts)
      T1(x) = T1(x) + D * deltat * ((T1(x+1) + T1(x-1) - 2 * T1(x) + T1(x+xpts) + T1(x-xpts) - 2 * T1(x) + T1(x+xpts*ypts) + T1(x - xpts*ypts) - 2 * T1(x))/deltax^2);
      end
      
      if (k == kval)
        T2(i,j) = T1(x);
        end
      
      end
      T3x(t) = (t-1) * deltat;
      T3y(t) = T2(kval,kval);
      end




plot(T3x,T3y)
figure;
surf(T2);
colorbar;