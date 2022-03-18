<h1> Getting started with localstack </h1>

To start localstack on your machine run:

`docker compose up`


This will build a container named localstack-example and run create-resources.sh
which creates the following aws resources: <ol>

<li>iam - creates admin role</li>
<li>S3 - creates a S3 bucket named lambda-functions</li>
<li>SQS - creates testQueue queue<</li>
<li>SNS - creates the testTopic topic</li>
<li>The script then subscribes the testTopic to the testQueue</li>
<li>lambda - creates the example lambda and sets the event source mapping to it</li>
</ol>
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

To add additional npm dependencies to the lambda:<ol>
- add `require` to your lambda<br>
- add the dependency to your package.json</ol>

