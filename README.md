<h1> Getting started with localstack </h1>

To start localstack on your machine run:

`docker compose up`


This will build a container named localstack-example and run create-resources.sh
which creates the following aws resources: 

iam - creates admin role<br>
S3 - creates a S3 bucket named lambda-functions<br>
SQS - creates testQueue queue<br>
SNS - creates the testTopic topic<br>
The script then subscribes the testTopic to the testQueue<br>
lambda - creates the example lambda and sets the event source mapping to it<br>

To publish a topic run: 

`aws 
sns publish
--endpoint-url=http://localhost:4566 
--topic-arn arn:aws:sns:us-east-1:000000000000:testTopic 
--region us-east-1 
--message 'Test Topic!'`

To send a message to the testQueue run:

`aws \
sqs send-message 
--endpoint-url=http://localhost:4566 
--queue-url http://localhost:4576/000000000000/testQueue 
--region us-east-1 
--message-body 'Test Message!'`


