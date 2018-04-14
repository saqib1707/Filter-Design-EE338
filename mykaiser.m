function [I] = mykaiser(x)
    I = 1;
    for l=1:100
       I = I + (((x/2)^l)/factorial(l))^2;
    end;
end

