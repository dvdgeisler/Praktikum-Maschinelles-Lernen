
d = [pwd,'/vid/example3/'];
files = dir(d);

for path = {files(11:end).name}
    fullpath = [d,path{1}]
    trafficSignDetection(fullpath,1)
end