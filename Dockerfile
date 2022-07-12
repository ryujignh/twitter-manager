FROM ruby:3.1.0
WORKDIR /app

RUN apt-get update && apt-get install -y libpq-dev make g++ git

COPY Gemfile Gemfile.lock /app/
RUN bundle install -j4

COPY . .
