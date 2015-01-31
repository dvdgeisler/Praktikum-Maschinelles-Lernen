classdef DataSet
    
    properties
        path
        types
        shapes
        scrambled
        scrambled_category_ref;
    end
    
    methods
        
        function ds = DataSet( path )
            samples_count = 0;
            samples_offset = 0;
            
            ds.path = path;
            dataSetStructure = load(sprintf('%s/dataset.mat',path));
            
            typeNames =  unique({dataSetStructure.class.type});
            shapeNames =  unique({dataSetStructure.class.shape});
            
            ds.types = DataSetCategory.empty(length(typeNames),0);
            ds.shapes = DataSetCategory.empty(length(shapeNames),0);
            
           % for typeName = typeNames
           %     classes = dataSetStructure.class(ismember({dataSetStructure.class.type},typeName));
           %     ds.types(ismember(typeNames,typeName)) = DataSetCategory( typeName{1} , classes , path );
           % end
            
            for shapeName = shapeNames
                classes = dataSetStructure.class(ismember({dataSetStructure.class.shape},shapeName));
                ds.shapes(ismember(shapeNames,shapeName)) = DataSetCategory( shapeName{1} , classes , path );
                samples_count = samples_count + size(ds.shapes(ismember(shapeNames,shapeName)).scrambled,1);
            end
            
            ds.scrambled = zeros(samples_count,prod(DataSetClass.size));
            ds.scrambled_category_ref = zeros(samples_count,length(ds.shapes));
            
            for i = 1:length(ds.shapes)
                image_count = size(ds.shapes(i).scrambled,1);
                samples_indx = (1+samples_offset):(samples_offset+image_count);
                ds.scrambled(samples_indx,:) = ds.shapes(i).scrambled;
                ds.scrambled_category_ref(samples_indx,i) = zeros(1,image_count) + 1;
                samples_offset = samples_offset + image_count;
            end
        end
        
    end
    
end

