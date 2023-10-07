# Base Image
FROM python:3.9
LABEL maintainer="ASEC Inc. (naleks@asec.io)"

# set default environment variables
ENV WORKON_HOME /root
ENV PYTHONUNBUFFERED 1
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV PGSSLCERT /tmp/postgresql.crt

# Tells pipenv to create virtualenvs in /root rather than $HOME/.local/share.
# We do this because GitHub modifies the HOME variable between `docker build` and
# `docker run`
ENV WORKON_HOME /root

# create and set working directory
RUN mkdir /code
WORKDIR /code

COPY . /code/

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata \
        ncat \
        python3-setuptools \
        python3-pip \
        python3-dev \
        python3-venv \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install environment dependencies
RUN pip3 install --upgrade pip 
RUN pip3 install pipenv

# Install project dependencies
RUN pipenv install --skip-lock --system --dev

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN useradd -m appuser
RUN chown -R appuser:appuser /vol/
RUN chmod -R 755 /vol/web

# Set the entry point to start the Django server using pipenv
ENTRYPOINT ["./docker-entrypoint.sh"]