# jekyll
FROM ruby:2.7.3-alpine3.13 as jekyll

WORKDIR /tmp/jekyll-proj

COPY jekyll-proj/ .
RUN apk add --no-cache build-base gcc bash cmake git nodejs
RUN ruby --version && gem install jekyll && gem install bundler && bundle install && bundle exec jekyll build

# nginx
FROM nginx:stable-alpine

RUN rm /usr/share/nginx/html/index.html
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=jekyll /tmp/jekyll-proj/_site/ /usr/share/nginx/html

## add permissions for nginx user
RUN chown -R nginx:nginx /var/cache/nginx && chown -R nginx:nginx /var/log/nginx && chown -R nginx:nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && chown -R nginx:nginx /var/run/nginx.pid

USER nginx

EXPOSE 8080

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]