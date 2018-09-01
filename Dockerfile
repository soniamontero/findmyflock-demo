FROM ruby:2.4.4

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && \
    apt-get install -y git build-essential libpq-dev nodejs tzdata \
      chromium-driver && \
    rm -rf /var/lib/apt/lists/*

RUN bundle config --global frozen 1

WORKDIR /usr/src/app
RUN addgroup --system app && \
    adduser --home /usr/src/app --system --disabled-login --ingroup app app && \
    adduser app video && adduser app audio
ENV HOME=/usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

ENV NODE_ENV=development
RUN npm install -g yarn
COPY package.json yarn.lock ./
RUN yarn

COPY . .
RUN chown -R app .
RUN chmod +x docker-entrypoint.sh
USER app

EXPOSE 3000

CMD ["./docker-entrypoint.sh"]
