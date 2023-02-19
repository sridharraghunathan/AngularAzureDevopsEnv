ARG PWD_DIR=/usr/src/app
FROM node:16 AS ui-build
ARG PWD_DIR
ENV PATH ${PWD_DIR}/node_modules/.bin:$PATH
WORKDIR ${PWD_DIR}
COPY . ./angularapp/
ARG Environment 
RUN cd angularapp/ && npm install @angular/cli@14 && npm install && npm run build:$Environment

#Nginx image download to run the angular application
FROM nginx:alpine
ARG PWD_DIR
#!/bin/sh
COPY ./nginx.conf /etc/nginx/nginx.conf
## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*
# Copy from the stahg 1
COPY --from=ui-build ${PWD_DIR}/angularapp/dist/environmentspecific/ /usr/share/nginx/html
EXPOSE 4200 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]