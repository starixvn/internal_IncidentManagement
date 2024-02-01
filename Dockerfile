FROM hub.nexdev.net/nexus/nexdev_base

RUN rm -r /app/redmine/*
COPY . /app/redmine/

EXPOSE 3000