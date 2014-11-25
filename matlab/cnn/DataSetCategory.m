classdef DataSetCategory
    
    properties
        name;
        classes;
        scrambled;
        scrambled_class_ref;
    end
    
    methods
        function c = DataSetCategory( name , classes , path )
            samples_count = 0;
            samples_offset = 0;
            
            c.name = name;
            c.classes = DataSetClass.empty(length(classes),0);
            
            for i = 1:length(classes)
                c.classes(i) = DataSetClass(classes(i) , path);
                samples_count = samples_count + length(c.classes(i).images);
                fprintf('category %s: %d/100\n',c.name,int16((i/length(classes))*100));
            end
            
            c.scrambled = zeros(samples_count,prod(DataSetClass.size));
            c.scrambled_class_ref = zeros(samples_count,length(c.classes));
            
            for i = 1:length(classes)
                image_count = length(c.classes(i).images);
                scrambled_tmp = [c.classes(i).images.scrambled];
                scrambled_tmp = reshape(scrambled_tmp,image_count,size(c.scrambled,2));
                samples_indx = (1+samples_offset):(samples_offset+image_count);
                c.scrambled(samples_indx,:) = scrambled_tmp;
                c.scrambled_class_ref(samples_indx,i) = zeros(1,image_count) + 1;
                samples_offset = samples_offset + image_count;
            end
        end
    end
    
end

