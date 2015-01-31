classdef DataSetCategory
    
    properties
        name;
        classes;
        net;
        data;
        data_class_ref;
    end
    
    methods
        function c = DataSetCategory( name , classes , path )
            dataCount = 0;
            dataOffset = 0;
            
            c.name = name;
            c.classes = DataSetClass.empty(length(classes),0);
            
            for i = 1:length(classes)
                c.classes(i) = DataSetClass(classes(i) , path);
                dataCount = dataCount + length(c.classes(i).images);
                fprintf('category %s: %d/100\n',c.name,int16((i/length(classes))*100));
            end
            
            c.data = zeros(DataSetClass.size(1),DataSetClass.size(2),dataCount);
            c.data_class_ref = zeros(dataCount,length(c.classes));

            for i = 1:length(classes)
                image_count = length(c.classes(i).images);
                samples_indx = (1+dataOffset):(dataOffset+image_count);
                
                c.data(:,:,samples_indx) = c.classes(i).data;
                
                c.data_class_ref(samples_indx,i) = zeros(1,image_count) + 1;
                dataOffset = dataOffset + image_count;
            end
        end
    end
    
end

