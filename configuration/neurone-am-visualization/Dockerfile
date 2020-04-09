FROM node:10.15.3-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

#######################
FROM nginx:1.15.11-alpine  

# Copy the Pre-built binary file from the previous stage
COPY --from=0 /app/dist /usr/share/nginx/html

RUN cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.orig && \
    sed -i 's/listen[[:space:]]*80;/listen 3000;/g' /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]