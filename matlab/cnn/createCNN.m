function [ net ] = createCNN( size , numOutput )
    net = network;
    O = sample2d(reshape(1:prod(size),size));
    
    net.numInputs = prod(size);
    for i = 1:length(net.inputs)
        [x, y] = ind2sub(size,i);
        net.inputs{i}.name = ['input ' num2str(i) ' (' num2str(x) ',' num2str(y) ')'];
    end
    net.inputs{:}.size = 1;
    
    net.numLayers = prod(size-2);
    for i = 1:length(net.layers)
        [x, y] = ind2sub(size-2,i);
        net.layers{i}.name = ['cluster ' num2str(i) ' (' num2str(x) ',' num2str(y) ') 1'];
        net.inputConnect(i,O(x,y,:)) = 1;
    end
    
    net.layers{1:(end-1)}.size = 1;
    net.layers{1:(end-1)}.initFcn = 'initnw';
    net.layers{1:(end-1)}.netInputFcn = 'netsum';
    net.layers{1:(end-1)}.transferFcn = 'tansig';
    
    if sqrt(prod(size)) > numOutput
        subnet = createCNN(size - 2, numOutput);
        net.numLayers = net.numLayers + subnet.numLayers;
        net.layerConnect((prod(size-2)+1):end,(prod(size-2)+1):end) = subnet.layerConnect;
        net.layerConnect((prod(size-2)+1):end,1:prod(size-2)) = subnet.inputConnect;
        
        for i = 1:subnet.numLayers
            net.layers{prod(size-2)+i}.name = [subnet.layers{i}.name '.1'];
            net.layers{prod(size-2)+i}.size = subnet.layers{i}.size;
            net.layers{prod(size-2)+i}.initFcn = subnet.layers{i}.initFcn;
            net.layers{prod(size-2)+i}.netInputFcn = subnet.layers{i}.netInputFcn;
            net.layers{prod(size-2)+i}.transferFcn = subnet.layers{i}.transferFcn;
        end
    else
        net.numLayers = net.numLayers + 1;
        net.outputConnect(end) = 1;
        net.layers{end}.name = 'output';
        net.layers{end}.size = numOutput;
        net.layers{end}.initFcn = 'initnw';
        net.layers{end}.netInputFcn = 'netsum';
        net.layers{end}.transferFcn = 'softmax';
        net.layerConnect(end,1:(end-1)) = 1;
    end
    
end


