d = 5
a=zeros(d*d,d*d);
b=zeros(d*d,1);
for i=1:d*d
    for j=1:d*d
        if i==j
            m=mod(i,d);
            g=i-m;
            if d*d*3/4>g && d*d*3/4<g+d*d*.1 && d/4>m && d/4<m+d*.1
                b(i,1)=100;
                a(i,:)=0;
                a(i,j)=1;
            elseif mod(i,d)==0
                a(i,j)=1;
                b(i,1)=25;
            elseif mod(i,d)==1
                a(i,j)=1;
                b(i,1)=50;
            elseif i<d
                a(i,j)=-3;
                a(i,j+1)=1;
                a(i,j-1)=1;
                a(i,j+d)=1;
            elseif i>d*d-d
                a(i,j)=-3;
                a(i,j+1)=1;
                a(i,j-1)=1;
                a(i,j-d)=1;
            else
                a(i,j)=-4;
                a(i,j+1)=1;
                a(i,j-1)=1;
                a(i,j+d)=1;
                a(i,j-d)=1;
            end
        end
    end
end
x=a\b;
x = reshape(x, [d,d]);
x = transpose(x);
imagesc(x);
colorbar;


figure
surf(x)
colorbar





