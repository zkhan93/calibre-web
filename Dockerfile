FROM python:3.9.4-slim-buster

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y \
    calibre \
    g++ \
    make \
    libffi-dev \
    rustc \
    libxml2-dev \
    libxslt-dev \
    libldap2-dev \
    libsasl2-dev \
    libz-dev \
    libmagickwand-dev \
    wget \
    unzip &&\
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/janeczku/calibre-web/releases/download/0.6.11/calibre-web-0.6.11.zip &&\
    unzip -d ./ calibre-web-0.6.11.zip &&\
    rm calibre-web-0.6.11.zip &&\
    mv ./calibre-web-0.6.11/* ./ &&\
    rm -rf calibre-web-0.6.11/

RUN wget -o /usr/bin/kepubify https://github.com/pgaskin/kepubify/releases/download/v3.1.6/kepubify-linux-arm
RUN wget -o /usr/bin/covergen https://github.com/pgaskin/kepubify/releases/download/v3.1.6/covergen-linux-arm
RUN wget -o /usr/bin/seriesmeta https://github.com/pgaskin/kepubify/releases/download/v3.1.6/seriesmeta-linux-arm

RUN apt-get remove wget unzip -y
RUN pip install -r requirements.txt
# skipping first 13 lines of gdrive integration dependencies
RUN sed -e '1,13d'  optional-requirements.txt > no-gdrive-optional-requirements.txt
RUN pip install -r no-gdrive-optional-requirements.txt

EXPOSE 8083

VOLUME ["/data"]

CMD ["python", "cps.py", "-p", "/data/app.db"] 

