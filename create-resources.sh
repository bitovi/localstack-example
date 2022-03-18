#!/bin/bash

cat <<EOF > admin-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

echo "*************************"
echo "Create admin"
aws \
 --endpoint-url=http://localhost:4566 \
 --region us-east-1 \
 iam create-role \
 --role-name admin-role \
 --path / \
 --assume-role-policy-document file:./admin-policy.json
echo "Make S3 bucket"
aws \
  s3 mb s3://lambda-functions \
  --endpoint-url http://localhost:4566 \
  --region east-us-1 || true
echo "Create SQS queue testConsumer"
aws \
  sqs create-queue \
  --queue-name testQueue \
  --endpoint-url http://localhost:4566 \
  --region us-east-1
echo "Create SNS Topic test"
aws \
  sns create-topic \
  --name testTopic \
  --endpoint-url http://localhost:4566 \
  --region us-east-1
echo "Subscribe testTopic to testQueue"
aws \
  sns subscribe \
  --region us-east-1 \
  --endpoint-url http://localhost:4566 \
  --topic-arn arn:aws:sns:us-east-1:000000000000:testTopic \
      --protocol sqs \
      --notification-endpoint arn:aws:sqs:us-east-1:000000000000:testQueue
echo "Initialize lambda testConsumerLambda"
aws \
  s3 cp lambdas.zip s3://lambda-functions \
  --endpoint-url http://localhost:4566 \
  --region east-us-1
aws \
  lambda create-function \
  --endpoint-url=http://localhost:4566 \
  --region us-east-1 \
  --function-name exampleLambda \
  --role arn:aws:iam::000000000000:role/admin-role \
  --handler index.handler \
  --runtime nodejs10.x \
  --description "SQS Lambda handler for test sqs." \
  --timeout 60 \
  --memory-size 128 \
  --code S3Bucket=lambda-functions,S3Key=lambdas.zip
aws \
  lambda create-event-source-mapping \
  --function-name exampleLambda \
  --batch-size 1 \
  --event-source-arn "arn:aws:sqs:us-east-1:000000000000:testQueue" \
  --region us-east-1 \
  --endpoint-url=http://localhost:4566
echo "All resources initialized! 🚀"


: '
publish_topic
  aws \
  sns publish\
  --endpoint-url=http://localhost:4566 \
  --topic-arn arn:aws:sns:us-east-1:000000000000:testTopic \
  --region us-east-1 \
  --message 'Test Topic!'


send_message_to_queue
  aws \
  sqs send-message \
  --endpoint-url=http://localhost:4566 \
  --queue-url http://localhost:4576/000000000000/testQueue \
  --region us-east-1 \
  --message-body 'Test Message!'
'
