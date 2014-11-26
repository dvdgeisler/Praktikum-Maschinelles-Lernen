trai_dir = '..\..\Data\pix\FullIJCNN2013\';
Dat = fopen(strcat(trai_dir,'gt.txt'));
data = struct('imageFilename',{},'objectBoundingBoxes',{});
names = {};
neg = {};
while ~feof(Dat)
   line = fgetl(Dat);
   C = strsplit(line,';');
   tmp = strcat(trai_dir,C{1});
   if Form(str2num(C{6}))==2
       p1 = [str2num(C{2}) str2num(C{3})];
       p2 = [str2num(C{4}) str2num(C{5})];
       data(length(data)+1).imageFilename = tmp;
       names{length(names)+1} = data(length(data)).imageFilename;
       data(length(data)).objectBoundingBoxes = [p1(1),p1(2),p2(1)-p1(1),p2(2)-p1(2)];
   elseif ~ismember(tmp,names)
       neg{length(neg)+1} = tmp;
       names{length(names)+1} = tmp;
   end
end
fclose(Dat);