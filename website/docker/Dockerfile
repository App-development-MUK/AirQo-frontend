# Building frontend
FROM node:12-slim as build

WORKDIR /app

ARG REACT_WEB_STATIC_HOST
ENV REACT_WEB_STATIC_HOST=$REACT_WEB_STATIC_HOST

COPY ./package.json ./package-lock.json /app/
RUN npm ci --silent

COPY ./webpack.config.js ./.babelrc /app/
COPY ./frontend /app/frontend
RUN npm run build

# Backend server
FROM python:3.8 as deployment

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip
RUN pip install gunicorn

COPY requirements.txt /app/
RUN pip install -r requirements.txt

COPY --from=build /app/frontend /app/frontend
COPY manage.py ./docker/wsgi-entrypoint.sh /app/
COPY ./backend /app/backend

# Backend server
FROM deployment as development
COPY google_application_credentials.json /etc/config/