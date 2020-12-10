# jekyll
FROM jekyll/builder:latest as jekyll

WORKDIR /tmp/jekyll-proj

COPY jekyll-proj/ .
RUN chown -R jekyll:jekyll /tmp/jekyll-proj
RUN gem install bundler
RUN bundle install
RUN bundle exec jekyll build

# nginx
FROM nginx:alpine as nginx

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=jekyll /tmp/jekyll-proj/_site/ /usr/share/nginx/html
