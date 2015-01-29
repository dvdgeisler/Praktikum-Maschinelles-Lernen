classdef DataSetClass
    
    properties(Constant)
        size            = [128 128];
%        scramblePattern = DataSetClass.scramble(reshape(1:prod(DataSetClass.size),DataSetClass.size));
%        gaussianFilter  = fspecial('gaussian', DataSetClass.size, 2.0);
    end
    
    methods(Static)
%         function s = scramble(I)
%             if size(I,1) <= 1 || size(I,2) <= 1
%                 s = I;
%             else
%                 w = size(I,1) / 2;
%                 h = size(I,2) / 2;
%                 s1 = I(1:w,1:h);
%                 s2 = I((w+1):(w+w),1:h);
%                 s3 = I(1:w,(h+1):(h+h));
%                 s4 = I((w+1):(w+w),(h+1):(h+h));
%                 ss1 = DataSetClass.scramble(s1);
%                 ss2 = DataSetClass.scramble(s2);
%                 ss3 = DataSetClass.scramble(s3);
%                 ss4 = DataSetClass.scramble(s4);
%                 s = [ss1,ss2,ss3,ss4];
%             end
%         end
    end
    
    properties
        id
        name
        path
        images
        data
    end
    
    methods       
        function c = DataSetClass( class , path )
            
            c.id = class.id;
            c.name = class.desc;
            c.path = sprintf('%s/%s',path,class.id);
            files = dir(c.path);
            for i = 3:length(files)
                file = sprintf('%s/%s',c.path,files(i).name);
                c.images(i-2).cdata         = imresize(imread(file),DataSetClass.size);
                c.images(i-2).gray          = rgb2gray(c.images(i-2).cdata);
%                c.images(i-2).canny         = edge(c.images(i-2).gray,'canny');
%                c.images(i-2).cannyGauss    = imfilter(c.images(i-2).canny,DataSetClass.gaussianFilter);
%                c.images(i-2).scrambled     = c.images(i-2).cannyGauss(DataSetClass.scramblePattern);
                fprintf('class %s (%s): %d/100\n',c.id,c.name,int16((i/length(files))*100));
            end
            c.data = reshape([c.images.gray],DataSetClass.size(1),DataSetClass.size(2),length(c.images));
        end
            

    end
end

