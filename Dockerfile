# Use a multi-step build process for our production container
# Step 1: Build Phase (notice the 'as' keyword)
FROM node:alpine as builder
WORKDIR /var/app
COPY ./package.json ./
RUN npm install
COPY ./ ./
RUN npm run build

# Step 2: Build Phase
FROM nginx

# normally this is just documentation for developers (doesn't actually open port)
# however, elastic beanstalk uses this to know that it should open port 80
EXPOSE 80

# where nginx expects static content to be
WORKDIR /usr/share/nginx/html

# 'from' flag takes in the build stage (or image name) to use as the source
# location of this copy instruction instead of the build's context
COPY --from=builder /var/app/build .
