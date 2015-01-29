function [ r ] = deepLearning( ds , hiddenLayers )
    
    f = 16;
    X = ds.scrambled';
    C = ds.scrambled_category_ref';
    
    r.net = patternnet(hiddenLayers);
    r.net.inputs{1}.size = size(X,1);
    r.net.layers{length(hiddenLayers)+1}.size = size(C,1);
    
    r.tnet(length(hiddenLayers)).net = network;
    
    for i = 1:length(hiddenLayers)
        r.tnet(i).net = patternnet(hiddenLayers(i));
        r.tnet(i).net.inputs{1}.processFcns = {'mapminmax'};
        r.tnet(i).net = train(r.tnet(i).net,X,C);
        
        if(i == 1)
            r.net.IW{1} = r.tnet(i).net.IW{1};
        else
            r.net.LW{i,i-1} = r.tnet(i).net.IW{1};
        end
        r.net.b{i} = r.tnet(i).net.b{1};
        
        if(i == length(hiddenLayers))
            r.net.LW{i+1,i} = r.tnet(i).net.LW{2,1};
            r.net.b{length(hiddenLayers)+1} = r.tnet(i).net.b{2};
        end
        
        r.tnet(i).net.outputConnect(2) = 0;
        r.tnet(i).net.outputConnect(1) = 1;
        
        X = r.tnet(i).net(X);
    end
    
end

