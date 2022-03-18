FROM node:15 as lambda

ARG PORT=8000
ENV PORT=$PORT
WORKDIR /usr/src
COPY . .

RUN apt-get update
RUN apt-get install zip

RUN cd src && zip -r lambdas.zip .

FROM localstack/localstack
COPY --from=lambda /usr/src/src/lambdas.zip ./lambdas.zip
