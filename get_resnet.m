function [layers, lgraph] = get_resnet()
netWidth = 16;
layers = [
    imageInputLayer([224 224 3],'Name','input')
    convolution2dLayer(3,netWidth,'Padding','same','Name','convInp')
    batchNormalizationLayer('Name','bn_res')
    reluLayer('Name','relu_sp')
    
    convolutionalUnit(netWidth,1,'conv_sa1')
    additionLayer(2,'Name','add_11')
    reluLayer('Name','relu_11')
    convolutionalUnit(netWidth,1,'conv_sa2')
    additionLayer(2,'Name','add_12')
    reluLayer('Name','relu_12')
    
    convolutionalUnit(2*netWidth,2,'conv_sc1')
    additionLayer(2,'Name','add_21')
    reluLayer('Name','relu_21')
    convolutionalUnit(2*netWidth,1,'conv_sc2')
    additionLayer(2,'Name','add_22')
    reluLayer('Name','relu_22')
    
    convolutionalUnit(4*netWidth,2,'conv_se1')
    additionLayer(2,'Name','add_31')
    reluLayer('Name','relu_31')
    convolutionalUnit(4*netWidth,1,'conv_se2')
    additionLayer(2,'Name','add_32')
    reluLayer('Name','relu_32')
    
    averagePooling2dLayer(8,'Name','globalPool')
    fullyConnectedLayer(3,'Name','fcFinal')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')
    ];
lgraph = layerGraph(layers);
lgraph = connectLayers(lgraph,'relu_sp','add_11/in2');
lgraph = connectLayers(lgraph,'relu_11','add_12/in2');
skip1 = [
    convolution2dLayer(1,2*netWidth,'Stride',2,'Name','skipConv1')
    batchNormalizationLayer('Name','skipBN1')];
lgraph = addLayers(lgraph,skip1);
lgraph = connectLayers(lgraph,'relu_12','skipConv1');
lgraph = connectLayers(lgraph,'skipBN1','add_21/in2');

lgraph = connectLayers(lgraph,'relu_21','add_22/in2');
skip2 = [
    convolution2dLayer(1,4*netWidth,'Stride',2,'Name','skipConv2')
    batchNormalizationLayer('Name','skipBN2')];
lgraph = addLayers(lgraph,skip2);
lgraph = connectLayers(lgraph,'relu_22','skipConv2');
lgraph = connectLayers(lgraph,'skipBN2','add_31/in2');
lgraph = connectLayers(lgraph,'relu_31','add_32/in2');

layers = lgraph.Layers;

function layers = convolutionalUnit(numF,stride,tag)
layers = [
    convolution2dLayer(3,numF,'Padding','same','Stride',stride,'Name',[tag,'conv1'])
    batchNormalizationLayer('Name',[tag,'BN1'])
    reluLayer('Name',[tag,'relu1'])
    convolution2dLayer(3,numF,'Padding','same','Name',[tag,'conv2'])
    batchNormalizationLayer('Name',[tag,'BN2'])];
