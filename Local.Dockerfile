FROM hub.nexdev.net/nexus/nexdev_base

# USER root
# RUN apt-get update && apt-get install -y ca-certificates

WORKDIR /app/redmine
RUN rm -r /app/redmine/*
COPY . /app/redmine/

RUN gem install bundler -v 1.15.4
RUN bundle install --without development test

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-e", "production"]
