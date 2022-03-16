#!/usr/bin bash

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


#  aws \
#   --endpoint-url=http://localhost:4566 \
#   --region us-east-1 \
#   iam create-role \
#   --role-name admin-role \
#   --path / \
#   --assume-role-policy-document file:./admin-policy.json


create_queue()
{
    aws \
            sqs create-queue \
            --queue-name "$1" \
            --endpoint-url http://localhost:4566 \
            --region us-east-1
}
_create_topic()
{
    aws \
          sns create-topic \
          --name "$1" \
          --endpoint-url http://localhost:4566 \
          --region us-east-1
}
_subscribe_topic_to_queue()
{
    aws \
      sns subscribe \
      --region us-east-1 \
      --endpoint-url http://localhost:4566 \
      --topic-arn "arn:aws:sns:us-east-1:000000000000:$1" \
      --protocol sqs \
      --notification-endpoint "arn:aws:sqs:us-east-1:000000000000:$2"
}

_publish_topic(){
  aws \
  sns publish\
  --endpoint-url=http://localhost:4566 \
  --topic-arn arn:aws:sns:us-east-1:000000000000:test \
  --message 'Test Topic!'
}

_send_message_to_queue(){
  aws \
  sqs send-message \
  --endpoint-url=http://localhost:4566 \
  --queue-url http://localhost:4576/000000000000/testConsumer \
  --message-body 'Test Message!'
}
_receive_message_from_queue(){
    aws \
    sqs receive-message \
    --endpoint-url=http://localhost:4566 \
    --queue-url http://localhost:4566/000000000000/testConsumer

}

_get_all_topics()
{
    aws \
      --endpoint-url=http://localhost:4566 sns list-topics
}
_get_all_queues() {
    aws \
    --endpoint-url=http://localhost:4566 sqs list-queues
}
_get_all_subscriptions()
{
  aws sns list-subscriptions --endpoint-url=http://localhost:4566
}
_get_all_lists()
{
  _get_all_queues
  _get_all_topics
  _get_all_subscriptions
}
_starter()
{
  QUEUENAME=$1"Consumer"
  TOPICNAME=$2
  _create_queue $QUEUENAME
  _create_topic $TOPICNAME
  _subscribe_topic_to_queue $TOPICNAME $QUEUENAME
}
_purge_queue()
{
  aws\
  sqs purge-queue \
  --queue-url "http://localhost:4566/000000000000/$1" \
  --region us-east-1 \
  --endpoint-url http://localhost:4566

}

_make_bucket()
{
  aws \
    s3 mb s3://$1 \
    --endpoint-url http://localhost:4566 \
    --region east-us-1 || true
}


_create_lambda() {
  zip="$1"
  name="$2"
  handler="$3"
  desc="$4"
#  env=""
  sqs="$5"
  aws \
    s3 cp src/"$zip" s3://lambda-functions \
    --endpoint-url http://localhost:4566 \
    --region east-us-1

  aws \
    lambda create-function \
    --endpoint-url=http://localhost:4566 \
    --region us-east-1 \
    --function-name "$name" \
    --role arn:aws:iam::000000000000:role/admin-role \
    --handler "$handler" \
    --runtime nodejs10.x \
    --description "$desc" \
    --timeout 60 \
    --memory-size 128 \
    --code S3Bucket=lambda-functions,S3Key="$zip" \
#    --environment "$env"
  aws \
    lambda create-event-source-mapping \
    --function-name "$name" \
    --batch-size 1 \
    --event-source-arn "arn:aws:sqs:us-east-1:000000000000:$sqs" \
    --region us-east-1 \
    --endpoint-url=http://localhost:4566

}

invoke_lambda(){
    aws \
    lambda invoke \
    --endpoint-url http://localhost:4566 \
    --function-name testConsumerLambda \
    outfile.txt

}





#create_admin
echo "make bucket"
_make_bucket lambda-functions
echo "create queue"
create_queue testConsumer
echo "create topic"
_create_topic test
echo "subscribe"
_subscribe_topic_to_queue test testConsumer
#publish_topic
#send_message_to_queue
#receive_message_from_queue
echo "create lambda"
_create_lambda \
  lambdas.zip \
  testConsumerLambda \
  index.handler \
  "SQS Lambda handler for test sqs." \
  test



echo "All resources initialized! 🚀"

