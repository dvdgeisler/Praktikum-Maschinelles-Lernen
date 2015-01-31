classdef DataSet
    
    properties
        path
        shapes
        %scrambled;
        %scrambled_category_ref;
        data;
        data_category_ref;
    end
    
    methods
        
        function ds = DataSet( path )
            dataCount = 0;
            dataOffset = 0;
            
            ds.path = path;
            dataSetStructure = load(sprintf('%s/dataset.mat',path));
            
            shapeNames =  unique({dataSetStructure.class.shape});
            ds.shapes = DataSetCategory.empty(length(shapeNames),0);
            
            for shapeName = shapeNames
                classes = dataSetStructure.class(ismember({dataSetStructure.class.shape},shapeName));
                ds.shapes(ismember(shapeNames,shapeName)) = DataSetCategory( shapeName{1} , classes , path );
                dataCount = dataCount + size(ds.shapes(ismember(shapeNames,shapeName)).data,3);
            end
            
            ds.data = zeros(DataSetClass.size(1),DataSetClass.size(2),dataCount);
            ds.data_category_ref = zeros(dataCount,length(ds.shapes));
            
            for i = 1:length(ds.shapes)
                image_count = size(ds.shapes(i).data,3);
                samples_indx = (1+dataOffset):(dataOffset+image_count);
                ds.data(:,:,samples_indx) = ds.shapes(i).data;
                ds.data_category_ref(samples_indx,i) = zeros(1,image_count) + 1;
                dataOffset = dataOffset + image_count;
            end
        end
        
    end
    
end

