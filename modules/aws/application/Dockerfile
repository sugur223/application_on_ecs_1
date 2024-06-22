FROM ruby:3.1

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN bundle exec rails assets:precompile

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
