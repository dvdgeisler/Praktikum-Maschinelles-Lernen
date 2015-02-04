function [ antw ] = inters(r1,r2)
    if r1(1)+r1(3)<r2(1) || r2(1)+r2(3)<r1(1) || r1(2)+r1(4)<r2(2) || r2(2)+r2(4)<r1(2)
        antw = false;
    else
        antw = true;
    end
end

