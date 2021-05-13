FROM ruby:3.0
ENV LANG C.UTF-8
ENV APP_ROOT /app
WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get install -y postgresql-client sqlite3 && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN bundle install -j4

COPY . $APP_ROOT

CMD ['bundle', 'exec', 'foreman', 'start']
