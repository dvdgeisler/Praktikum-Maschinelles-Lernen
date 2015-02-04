function ri = interset(vor,akt)
    ri = [];
    l1 = size(akt,1);
    l2 = size(vor,1);
    for i=1:l1
        for j=1:l2
            if inters(akt(i,:),vor(j,:))
                ri = [ri;akt(i,:)];
                break;
            end
        end
    end
end

