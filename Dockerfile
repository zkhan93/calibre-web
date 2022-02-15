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

RUN wget https://github.com/janeczku/calibre-web/releases/download/0.6.14/calibre-web-0.6.14.zip &&\
    unzip -d ./ calibre-web-0.6.14.zip &&\
    rm calibre-web-0.6.14.zip &&\
    mv ./calibre-web-0.6.14/* ./ &&\
    rm -rf calibre-web-0.6.14/

RUN wget -o /usr/bin/kepubify https://github.com/pgaskin/kepubify/releases/download/v3.1.6/kepubify-linux-64bit
RUN wget -o /usr/bin/covergen https://github.com/pgaskin/kepubify/releases/download/v3.1.6/covergen-linux-64bit
RUN wget -o /usr/bin/seriesmeta https://github.com/pgaskin/kepubify/releases/download/v3.1.6/seriesmeta-linux-64bit

RUN apt-get remove wget unzip -y
RUN pip install -r requirements.txt
# skipping first 13 lines of gdrive integration dependencies
RUN sed -e '1,13d'  optional-requirements.txt > no-gdrive-optional-requirements.txt
RUN pip install -r no-gdrive-optional-requirements.txt

EXPOSE 8083

VOLUME ["/data"]

CMD ["python", "cps.py", "-p", "/data/app.db"] 

