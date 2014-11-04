function [ hough ] = houghEllipse( Ibw , minr , maxr , iter )

    step = 0.1;
    t = 0:step:(2*pi);
    acc = zeros(iter,1);
    [height,width] = size(Ibw);
    e(iter).x = [];
     
    se = strel('disk',3);
    Ibwdil = imdilate(Ibw,se);

    function [ t ] = isTruePixel(p) 
        t = Ibw(p(2),p(1)) == 1;
    end

    [ys, xs] = find(Ibw);
    pixels = [xs ys];
    
    if length(pixels) < iter
        hough = [];
        return
    end
    
    dists = pdist2(pixels,pixels);
    [is,js] = find((dists > (minr*2)) & (dists < (maxr*2)));
    iter = min(iter,length(is));
    is = is(ceil(rand(iter,1).*length(is)));
    js = js(ceil(rand(iter,1).*length(js)));
    
    for h = 1:length(is);
        p1 = pixels(is(h), :);
        p2 = pixels(js(h), :);
        dp1p2 = dists(is(h),js(h));
        mp1p2 = (p2(2)-p1(2))/(p2(1)-p1(1));
        pcp1p2 = round((p1 + p2) / 2);
        mp3p4 = -1/mp1p2;
        cf = pcp1p2(2)-pcp1p2(1)*mp3p4;
        f = @(x) round(mp3p4*x+cf);
        
        p34s = pixels(f(pixels(:,1)) == pixels(:,2),:);
        p3 = mean(p34s(p34s(:,1)<pcp1p2(:,1),:),1);
        p4 = mean(p34s(p34s(:,1)>pcp1p2(:,1),:),1);
        
        pcp3p4 = round((p3 + p4) / 2);
        
        if isempty(pcp3p4) || isnan(pcp3p4(1)) || isnan(pcp3p4(2)) || isTruePixel(pcp3p4)
            continue;
        end
        
        cg = pcp3p4(2)-pcp3p4(1)*mp1p2;
        g = @(x) round(mp1p2*x+cg);
        
        p56s = pixels(g(pixels(:,1)) == pixels(:,2),:);
        p5 = mean(p56s(p56s(:,1)<pcp3p4(:,1),:),1);
        p6 = mean(p56s(p56s(:,1)>pcp3p4(:,1),:),1);
        
        e(h).a = pdist([pcp3p4;p3]);
        e(h).b = pdist([pcp3p4;p5]);
        e(h).alpha = atan(mp3p4);
        e(h).center = pcp3p4;
        
        if      isempty(e(h).a) || isempty(e(h).b) || isempty(e(h).alpha) || ...
                isnan(e(h).a) || isnan(e(h).b) || isnan(e(h).alpha) || ...
                e(h).a < minr || e(h).a > maxr || e(h).b < minr || e(h).b > maxr
            continue;
        end
        
        
        %e(h).x = arrayfun( @(t) round(pcp3p4(1) + e(h).a * cos(t) * cos(e(h).alpha) - e(h).b * sin(t) * sin(e(h).alpha)),t);
        %e(h).y = arrayfun( @(t) round(pcp3p4(2) + e(h).a * cos(t) * sin(e(h).alpha) + e(h).b * sin(t) * cos(e(h).alpha)),t);
        e(h).x = round(pcp3p4(1) + e(h).a * cos(t) * cos(e(h).alpha) - e(h).b * sin(t) * sin(e(h).alpha));
        e(h).y = round(pcp3p4(2) + e(h).a * cos(t) * sin(e(h).alpha) + e(h).b * sin(t) * cos(e(h).alpha));
        mask = (e(h).x > 0) & (e(h).x <= width) & (e(h).y > 0) & (e(h).y <= height);
        
        acc(h) = sum(Ibwdil(sub2ind([height,width],e(h).y(mask),e(h).x(mask))))/length(t);
        
    end
    
    [hough.quality,i] = max(acc);
    
    if hough.quality > 0
        hough.x = e(i).center(1);
        hough.y = e(i).center(2);
        hough.a = e(i).a;
        hough.b = e(i).b;
        hough.alpha = e(i).alpha;
        hough.xs = e(i).x;
        hough.ys = e(i).y;
    else
        hough = [];
    end
end