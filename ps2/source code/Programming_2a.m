 %load data according to the question
 d = load( 'detroit.mat' );
 %process data 
 s = d.data(:, 9:10);
 %definition
 v = [1;1;1;1;1;1;1;1;1;1;1;1;1];
 e = [] ;
 %variables and factors
 HOM = d.data(:,10);
 LIC = d.data(:,4);
 FTP = d.data(:,1);
 WE = d.data(:,9);
 matrix = [v, FTP, WE];
 %procedures
 i = 2 
 while(i < 9)
     store = d.data(:,i);   
     new = [matrix, store];
     %formula
     b = (((new')*new)^(-1))*(new')*HOM;
     y = new * b ;
     sub = y - HOM;
     sub2 = sub.^2;
     e1 = sum(sub2);     
     l_e = e1/(2*13);    
     e = [e; l_e];     
     i = i + 1 ;
 end
result = e 
plot(result,'--','color',[0 0.9 0]);
 
 