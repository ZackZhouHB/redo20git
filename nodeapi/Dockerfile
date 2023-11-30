# build 1st stage on node, similiar as client
FROM node:14 AS nodeapi-build
WORKDIR /usr/src/app
COPY ./ ./nodeapi/
RUN cd nodeapi && npm install


FROM node:14
WORKDIR /usr/src/app/

# copy 1st build artifact from /usr/src/app/nodeapi/
# to current workdir /usr/src/app/
COPY --from=nodeapi-build /usr/src/app/nodeapi/ ./
RUN ls
EXPOSE 5000
# start node app
CMD ["/bin/sh", "-c", "cd /usr/src/app/ && npm start"]

