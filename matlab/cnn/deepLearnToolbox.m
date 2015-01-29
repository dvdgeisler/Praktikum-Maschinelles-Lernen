load ds;

w = DataSetClass.size(1);
h = DataSetClass.size(1);
n = size(ds.data,3);
n_train = 1000;
n_test = n - n_train;
i_test = randperm(n,n_test);
i_train = 1:n;
i_train(i_test) = [];

x = double(ds.data)/255;
y = double(ds.data_category_ref');

x_train = x(:,:,i_train);
x_test = x(:,:,i_test);
y_train = y(:,i_train);
y_test = y(:,i_test);

rand('state',0);
cnn.layers = {
    struct('type', 'i')                                             %input          layer   1
    struct('type', 'c', 'outputmaps', 8^1, 'kernelsize', 32)           %convolution    layer   2
    struct('type', 's', 'scale', 2)                                 %sub sampling   layer   3
    struct('type', 'c', 'outputmaps', 8^2, 'kernelsize', 16)         %convolution    layer   4
    struct('type', 's', 'scale', 2)                                 %subsampling    layer   5
    struct('type', 'c', 'outputmaps', 8^3, 'kernelsize', 8)       %convolution    layer   6
    struct('type', 's', 'scale', 2)                               %subsampling    layer   7
    struct('type', 'c', 'outputmaps', 8^4, 'kernelsize', 4)     %convolution    layer   8
    struct('type', 's', 'scale', 2)                                 %subsampling    layer   9
};
cnn = cnnsetup(cnn, x_train, y_train);

opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 10;

cnn = cnntrain(cnn, x_train, y_train, opts);

[er, bad] = cnntest(cnn, x_test, y_test);