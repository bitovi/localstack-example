FROM node:15


ARG PORT=8000
ENV PORT=$PORT
WORKDIR app
COPY .. .
COPY src/package.json .
COPY prep-lambdas.sh prep-lambdas.sh

CMD prep-lambdas.sh

RUN npm install
EXPOSE $PORT
CMD npm start

