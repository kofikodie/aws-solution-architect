#!/bin/bash

# get the AWS CLI version
aws --version

# PRODUCER

# CLI v2
aws kinesis put-record --stream-name saa-c03-kinesis --partition-key user1 --data "user signup" --cli-binary-format raw-in-base64-out

# CONSUMER 

# describe the stream
aws kinesis describe-stream --stream-name saa-c03-kinesis

# Consume some data
aws kinesis get-shard-iterator --stream-name saa-c03-kinesis --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON
aws kinesis get-records --shard-iterator AAAAAAAAAAEPpmQtFdXgZ7qQiXJYBMa2Nz+20IiYmGFhTxy1uoZ4ceTzjoNcu7gNE7paoP9V7oVuHgT7eU9e7gDSucUkF30TCWvGTyFRKi90JW6YVAS5/hTzzrMIBxXPL93XEO1ADKTtwvk68v7so7Y/iEBJvBaRz3D/QTVC8JLLUufv7aZVhJkf4ReFYlMx2juE8vg/tDwiHRL8hN9VSSOJPnNVGJTUT3NNHsWoNdAiATrT+HVp8Q==