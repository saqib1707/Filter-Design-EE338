function [BL, BH] = bandedge(m, filt)
    q = ceil(0.1*m - 1);
    r = m - 10*q;
    if filt == 1
        BL = 5 + 1.4*q + 4*r;
        BH = BL + 10;
    elseif filt == 2
        BL = 5 + 1.2*q + 2.5*r;
        BH = BL + 6;
    end;
    BL = BL*1000;
    BH = BH*1000;
end