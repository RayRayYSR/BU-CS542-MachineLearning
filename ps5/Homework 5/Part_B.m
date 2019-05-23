%read in data and preprocess
source=imread('Lenanoise.png');
source=int16(source);
src=source;
s=size(source);
yd=s(1);
xd=s(2);
form=@(x,N)(mod(x-1,N)+1);
d_lam=1;
lam_s=1;
check=true; 
procedure=1;   
while(check) 
    check=false;    
    for i=1:xd
        for j=1:yd  
            %1st case
            minu=(-d_lam*abs(max(0,source(j,i)-procedure)-src(j,i)))-(lam_s*(abs(max(0,source(j,i)-procedure)-source(form(j-1,yd),i))+abs(max(0,source(j,i)-procedure)-source(j,form(i+1,xd)))+abs(max(0,source(j,i)-procedure)-source(j,form(i-1,xd)))+abs(max(0,source(j,i)-procedure)-source(form(j+1,yd),i))));
            %2nd case
            plus=(-d_lam*abs(min(255,source(j,i)+procedure)-src(j,i)))-(lam_s*(abs(min(255,source(j,i)+procedure)-source(form(j-1,yd),i))+abs(min(255,source(j,i)+procedure)-source(j,form(i+1,xd)))+abs(min(255,source(j,i)+procedure)-source(form(j+1,yd),i))+abs(min(255,source(j,i)+procedure)-source(j,form(i-1,xd)))));
            %3rd case
            same=(-d_lam*abs(source(j,i)-src(j,i)))-(lam_s*(abs(source(j,i)-source(form(j-1,yd),i))+abs(source(j,i)-source(j,form(i+1,xd)))+abs(source(j,i)-source(form(j+1,yd),i))+abs(source(j,i)-source(j,form(i-1,xd)))));
            %variable and compare
            xi=source(j,i);      
            if plus>same
                source(j,i)=min(255,xi+procedure);
                check=true;
            end
            if same<minu
                source(j,i)=max(0,xi-procedure);
                check=true;
            end           
        end
    end
end
recover=imread('Lena.png');
%get image
imshow(uint8(source));
figure();
imshow(uint8(src));