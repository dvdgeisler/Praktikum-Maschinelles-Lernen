function [ Is ] = trafficSignDetection( path , debug )

    function [ Ibw , Ibwrgb ] = calcBW( Irgb , threshold )
        rdist = double(Irgb(:,:,1))-193;
        gdist = double(Irgb(:,:,2))-18;
        bdist = double(Irgb(:,:,3))-28;
        dist = sqrt(rdist.*rdist + gdist.*gdist + bdist.*bdist);
    
        Ibw = dist < threshold;
        Ibwrgb = repmat(uint8(Ibw)*255,[1,1,3]);
    end

    function [ M , rect ] = calcEllipse( hough )
        x_min = min(hough.xs);
        x_max = max(hough.xs);
        y_min = min(hough.ys);
        y_max = max(hough.ys);
        M = [hough.xs;hough.ys];
        rect = [x_min y_min (x_max-x_min) (y_max-y_min)];
    end

    function [ Ic , x , y , w , h ] = autoCrop(I) 
        [ys, xs] = find(I);
        
        x_min = min(xs);
        x_max = max(xs);
        y_min = min(ys);
        y_max = max(ys);
        
        x = x_min;
        y = y_min;
        w = x_max - x_min;
        h = y_max - y_min;
        
        if ~isempty(w) && ~isempty(y) && w > 0 && y > 0
            Ic = imcrop(I, [x y w h]);
        else
            Ic = [];
        end
    end

    function [ rect ] = maxRect(rect0,rect1)
       xs = [ rect0(1) , (rect0(1) + rect0(3)) , rect1(1) , (rect1(1) + rect1(3)) ]; 
       ys = [ rect0(2) , (rect0(2) + rect0(4)) , rect1(2) , (rect1(2) + rect1(4)) ];
       
       x_min = min(xs);
       y_min = min(ys);
       x_max = max(xs);
       y_max = max(ys);
       width = x_max - x_min;
       height = y_max - y_min;
       
       rect = [x_min y_min width height];
    end

    function [ Ic ] = signCrop(I,rect,border)
        x1 = max(rect(1) - border, 0);
        y1 = max(rect(2) - border, 0);
        x2 = min(rect(1) + rect(3) + border, size(I,2));
        y2 = min(rect(2) + rect(4) + border, size(I,2));
        
        Ic = imcrop(I , [x1 y1 (x2-x1) (y2-y1)]);
    end

    function [ Irgb ] = drawAutoCropInformation(Irgb,rect)
       Irgb = insertShape(Irgb,'Rectangle',rect);
       Irgb = insertText(Irgb,rect(1:2)-[0,22],sprintf('x=%d, y=%d',rect(1),rect(2)),'FontSize',12);
       Irgb = insertText(Irgb,rect(1:2)-[0,44],sprintf('w=%d, h=%d',rect(3),rect(4)),'FontSize',12);
    end

    function [ Irgb ] = drawHoughDetails(Irgb,hough)
        I = zeros(105,size(Irgb,2),3)+255;
       
        I = insertText(I,[10,10],sprintf('center: x=%d, y=%d',hough.x,hough.y),'FontSize',12);
        I = insertText(I,[10,32],sprintf('axis: a=%d, b=%d',hough.a,hough.b),'FontSize',12);
        I = insertText(I,[10,54],sprintf('Angle: alpha=%f',hough.alpha),'FontSize',12);
        I = insertText(I,[10,76],sprintf('Quality: %d',hough.quality),'FontSize',12);
        
        Irgb = [Irgb;I];
    end

    function [ Irgb ] = getFrame(i)
        Irgb = vid.raw.frames(i).cdata(:,ceil(vid.raw.width*(2/3)):end,:);
    end

    vid.path = path;
    vid.raw = mmread(vid.path);
    vid.raw.frames(1).bw = zeros(vid.raw.height,vid.raw.width);

    h = 0;
    
    if debug
        figure;
        h = imshow([zeros(size(vid.raw.frames(1).cdata)),zeros(size(getFrame(1))),getFrame(1)]);
    end

    for i = 1:length(vid.raw.frames)

        Irgb = getFrame(i);
        [Ibw, Ibwrgb] = calcBW(Irgb,64);

        [Ibwc, xc, yc, wc, hc] = autoCrop(Ibw);
        
        if ~isempty(wc) && ~isempty(hc) && (wc > 30) && (hc > 30)
        
            if debug
                Ibwrgb = drawAutoCropInformation(Ibwrgb, [xc yc wc hc]);
                Irgb = drawAutoCropInformation(Irgb, [xc yc wc hc]);
            end
            
            hough = houghEllipse(Ibwc,10,50,100)
            if ~isempty(hough)
                hough.x = hough.x + xc;
                hough.y = hough.y + yc;
                hough.xs = hough.xs + xc;
                hough.ys = hough.ys + yc;
                
                [M, rect] = calcEllipse(hough);
                
                    Ibwrgb = insertShape(Ibwrgb,'Polygon',M(:)','Color','cyan','LineWidth',2);
                    Irgb = insertShape(Irgb,'Polygon',M(:)','Color','cyan','LineWidth',2);
                    
                if hough.quality > 0.75
                 
                    r = maxRect(rect,[xc (yc-45) max(wc,100) (hc+45)]);
                    Irgbsi = signCrop(Irgb, r,20);
                    Ibwrgbsi = signCrop(Ibwrgb, r,20);

                    pI = [Ibwrgbsi,Irgbsi];
                    pI = drawHoughDetails(pI,hough);
                    
                    figure;
                    imshow(pI);
                    if ~debug
                        imwrite(pI,sprintf('sign_%d_%d.png',i,cputime));
                    end
                end
            end
        end

        if debug
            set(h, 'CData', [vid.raw.frames(i).cdata,Ibwrgb,Irgb]);
            pause(0.1);
        end
    end
end

