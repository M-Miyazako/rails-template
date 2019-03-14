FROM ruby:RUBY_VERSION
ENV LANG C.UTF-8

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
                    nodejs mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /PROJECT_NAME
COPY Gemfile* ./
RUN bundle install
COPY . .
