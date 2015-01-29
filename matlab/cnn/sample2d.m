function [ O ] = sample2d( I )
    w = size(I,1);
    h = size(I,2);
    O = zeros(w-2,h-2,3,3);
    
    cx = 1;
    for x = 2:(w-1)
        cy = 1;
        for y = 2:(h-1)
             O(cx,cy,:,:) = I((x-1):(x+1),(y-1):(y+1));
             cy = cy + 1;
        end
        cx = cx + 1;
    end
end

