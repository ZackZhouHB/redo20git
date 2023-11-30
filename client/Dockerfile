# 1st stage build from node angular image
FROM node:14 AS web-build   

# defualt working path /usr/src/app/
WORKDIR /usr/src/app

# copy everything from client dir to target /usr/src/app/client dir, workdir set above
COPY ./ ./client     
# build get artifact 
RUN cd client && npm install && npm run build --prod

# Use official nginx image as the base image to host angular application built from 1st stage
FROM nginx:latest

# Copy the 1st build output artifact in /usr/src/app/client/dist/client/ 
# to defualt nginx path /usr/share/nginx/html
COPY --from=web-build /usr/src/app/client/dist/client/ /usr/share/nginx/html
# replace as cunstom nginx.conf 
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 4200
EXPOSE 4200
