function [ f ] = Form( klass )
    if ismember(klass,[(0:11),(16:18),(33:43)])
        f = 1;
        return;
    end
    if ismember(klass,[12,(19:32)])
        f = 2;
        return;
    end
    if ismember(klass,[13])
        f = 3;
        return;
    end
    if ismember(klass,[14])
        f = 4;
        return;
    end
    if ismember(klass,[15])
        f = 5;
        return;
    end
end

