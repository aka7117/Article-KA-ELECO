function Price = PriceFinderVeh(L)

Price = zeros(1,numel(L));

LL = L;

for i = 1:numel(LL)
    
   if  0<=LL(i) && LL(i)<60000
       
       Price(i) = 1.1*6.5;
       
   elseif LL(i)>=60000 && LL(i)<85000
       
       Price(i) = 1.15*9.4;
         
   elseif LL(i)>= 85000
       
       Price(i) = 1.2*13.2;
       
   else
       
       Price(i) = 6.5;
           
   end
    
end

end