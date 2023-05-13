FROM ruby:3.1.1-alpine as builder

RUN apk --no-cache add build-base \
  postgresql-dev

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=3 --retry=3

FROM ruby:3.1.1-alpine as runner

WORKDIR /app

RUN apk add --no-cache libpq-dev

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-p", "3000"]
