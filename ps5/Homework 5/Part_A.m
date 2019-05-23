%read in data and preprocess
source=imread('Bayesnoise_textbook.png');
%extract
extract_s=source(:,:,1);
extract_s=int8(extract_s);
%get greyscale for source
[r,c]=size(extract_s);
for i=1:r
    for j=1:c
        if extract_s(i,j)<119
            extract_s(i,j)=-1;
        else
            extract_s(i,j)=1;
        end
    end
end
gc=extract_s;
or=gc;
s=size(gc);
n=7;
yd=s(1);
xd=s(2);
h=-0.01;
fp=1;
c=0;
b=5;
while (fp) 
    c=c+1;
    fp=0;    
    for i=2:xd-1
        for j=2:yd-1
            fpe=(-gc(j,i))*(h-(b*(gc(j,i+1)+gc(j,i-1)+gc(j+1,i)+gc(j-1,i)))-(n*gc(j,i)));
            nfpe=gc(j,i)*(h-(b*(gc(j,i+1)+gc(j,i-1)+gc(j+1,i)+gc(j-1,i)))-(n*gc(j,i)));     
            if nfpe>fpe
                gc(j,i)=-gc(j,i);
                fp=1;
            end
        end
    end   
end
%correction read in and process
correction=imread('Bayes_textbook.png');
corr_coe=int8(correction(:,:,1));
%get greyscale for correction
[r,c]=size(corr_coe);
for i=1:r
    for j=1:c
        if corr_coe(i,j)<119
            corr_coe(i,j)=-1;
        else
            corr_coe(i,j)=1;
        end
    end
end
corr_b=corr_coe;
[r,c]=size(corr_b);
sum=r*c;
comparison=0;
for i=1:r
    for j=1:c
        if corr_b(i,j)==gc(i,j)
            comparison=comparison+1;
        end
    end
end
%report recovery rate
recovery=(comparison/sum)*100;
fprintf('The recovery is %.4f \n', recovery)
%get image
imshow(uint8(gc)*255);
figure();
imshow(uint8(or)*255);