d = 25;
l = 1;
w = 1;
cx = l/d;
cy=w/d;
q=0;
a=zeros(d*d,d*d);
b=zeros(d*d,1);
for i=1:d*d
        x=mod(i-1,d);
        y=i-x-1;
        x=x*cx;
        y=y*cy*cy;
        q=pi*pi*(sin(pi*x)+cos(pi*y))*-1;
            if i==1 #top left corner
                a(i,i)=1;
                b(i,1)=cos(pi*y);
                #a(i,i+1)=1;
                #a(i,i+d)=1;
            elseif i==d #top right corner
                a(i,i)=1;
                b(i,1)=cos(pi*y);
                #a(i,i-1)=1;
                #a(i,i+d)=1;
            elseif i==d*d-d+1 #bottom left corner
                a(i,i)=1;
                b(i,1)=cos(pi*y);
                #a(i,i+1)=1;
                #a(i,i-d)=1;
            elseif i==d*d #bottom right corner
                a(i,i)=1;
                b(i,1)=cos(pi*y);
                #a(i,i-1)=1;
                #a(i,i-d)=1;
            elseif x==0 || x==l #left/right edge
                a(i,i)=1;
                b(i,1)=cos(pi*y);
                #a(i,i+1)=1;
                #a(i,i-1)=1;
                #a(i,i-d)=1;
            elseif y==w-cy #bottom edge
                a(i,i)=1;
                b(i,1)=sin(pi*x)-1;
                #a(i,i+1)=1;
                #a(i,i-1)=1;
                #a(i,i+d)=1;
            elseif y==0 #top edge
                a(i,i)=1;
                b(i,1)=sin(pi*x)+1;
                #a(i,i+1)=1*cy;
                #a(i,i-1)=1*cy;
                #a(i,i-d)=1*cx;
            else
                a(i,i)=-4;
                a(i,i+1)=1;
                a(i,i-1)=1;
                a(i,i+d)=1;
                a(i,i-d)=1;
                b(i,1)=q*cx*cx;
    end
end
#disp(a);
#disp(b);
c=a\b;
c = reshape(c, [d,d]);
c = transpose(c);
imagesc(c);
colorbar;


figure;
surf(c);
colorbar;