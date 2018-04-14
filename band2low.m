function [output_fr] = band2low(omega_w1, omega_w2, omega_w3, omega_w4, filt)
    input_fr = [omega_w1, omega_w2, omega_w3, omega_w4];
    output_fr = [0,0,0,0];
    for j=1:4
        if filt == 1
            output_fr(j) = (input_fr(j).^2 - omega_w2*omega_w3)/((omega_w3-omega_w2)*input_fr(j));
        elseif filt == 2
            output_fr(j) = ((omega_w4-omega_w1)*input_fr(j))/(omega_w1*omega_w4 - input_fr(j).^2);
        end;
    end;
end