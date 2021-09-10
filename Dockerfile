FROM registry.nexdev.net:5050/nexcel/nexus/nexdev

RUN rm -r /app/redmine/*
COPY . /app/redmine/

EXPOSE 3000