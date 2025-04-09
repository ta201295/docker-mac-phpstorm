FROM node:20-alpine

# Cài đặt các công cụ hữu ích
RUN apk add --no-cache git

# Cài đặt các package toàn cục
RUN npm install -g npm@latest
RUN npm install -g @vue/cli
RUN npm install -g vite
RUN npm install -g laravel-mix
RUN npm install -g cross-env
RUN npm install -g typescript

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Tạo user node với UID/GID 1000
RUN deluser --remove-home node \
  && addgroup -S node -g 1000 \
  && adduser -S -G node -u 1000 node

# Chuyển quyền sở hữu thư mục cho user node
RUN mkdir -p /home/node/.npm && chown -R node:node /home/node

# Sử dụng user node
USER node
