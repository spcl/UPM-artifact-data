#!/bin/bash

# cd ~/serverless-benchmarks1
# mkdir benchmarks-data/400.inference/recognition-vgg19
# cp -r benchmarks-data/400.inference/411.image-recognition/fake-resnet benchmarks-data/400.inference/recognition-vgg19/
# cp ~/aws-ml-apps/sam-alexnet/app/model benchmarks-data/400.inference/recognition-vgg19/model.pt
for ((i=1; i<=16; i=i+1))
do
    cd ~/serverless-benchmarks${i}
    
    # mkdir benchmarks-data/400.inference/recognition-alexnet
    # cp -r benchmarks-data/400.inference/411.image-recognition/fake-resnet benchmarks-data/400.inference/recognition-alexnet/
    # cp ~/other_benchmarks/aws-ml-apps/sam-alexnet/app/model benchmarks-data/400.inference/recognition-alexnet/model.pt
    cp benchmarks/400.inference/411.image-recognition/python/_mman* benchmarks/400.inference/recognition-vgg19/python/
    # mkdir benchmarks-data/400.inference/recognition-vgg19
    # cp -r benchmarks-data/400.inference/411.image-recognition/fake-resnet benchmarks-data/400.inference/recognition-vgg19/
    # cp ~/other_benchmarks/aws-ml-apps/sam-alexnet/app/model benchmarks-data/400.inference/recognition-vgg19/model.pt
done
