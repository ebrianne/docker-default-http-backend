# jekyll
FROM jekyll/builder:latest as jekyll

COPY jekyll-proj/ /tmp
WORKDIR /tmp/jekyll-proj
RUN chown -R jekyll:jekyll /tmp
RUN gem install bundler
RUN bundle install
RUN bundle exec jekyll build

# nginx
FROM nginx:alpine as nginx

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=jekyll /tmp/jekyll-proj/_site/ /var/www/public/
