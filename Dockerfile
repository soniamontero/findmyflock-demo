FROM ruby:2.5.1-alpine3.7

RUN apk add --no-cache git build-base postgresql-dev nodejs tzdata

RUN bundle config --global frozen 1

WORKDIR /usr/src/app
RUN adduser -h /usr/src/app -S -D app
ENV HOME=/usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN npm install -g yarn
COPY package.json yarn.lock ./
RUN yarn

COPY . .
RUN chown -R app .
RUN chmod +x docker-entrypoint.sh
USER app

EXPOSE 3000

CMD ["./docker-entrypoint.sh"]
