FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    python3 \
    python3-pip
RUN pip3 install --upgrade pip==9.0.3 \
    && pip3 install setuptools

EXPOSE 8081

ADD . /app
WORKDIR /app

RUN pip3 install -r requirements.txt

CMD python3 app.py
