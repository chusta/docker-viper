FROM ubuntu:16.04

USER root
RUN apt-get update && apt-get install -y \
    autoconf \
    curl \
    gcc \
    git \
    libffi-dev \
    libfuzzy-dev \
    libimage-exiftool-perl \
    libssl-dev \
    libtool \
    pff-tools \
    python-dev \
    python-levenshtein \
    python-m2crypto \
    python-pip \
    ssdeep \
    supervisor \
    swig \
    yara \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get clean && apt-get autoclean

RUN pip install --upgrade pip \
  androguard \
  PySocks

RUN groupadd -r viper && \
  useradd -r -g viper -d /home/viper -s /sbin/nologin viper && \
  mkdir /home/viper && \
  chown -R viper:viper /home/viper

USER viper
WORKDIR /home/viper
RUN git clone --depth 1 https://github.com/viper-framework/viper.git

USER root
WORKDIR /home/viper/viper
RUN chmod a+xr viper-update \
  viper-web \
  viper-api \
  viper-cli

RUN pip install -r requirements.txt

RUN mkdir /etc/viper /viper && chown viper:viper /viper
COPY viper.conf /etc/viper/viper.conf

RUN ln -s /home/viper/viper/viper-update /usr/local/bin/viper-update && \
  ln -s /home/viper/viper/viper-web /usr/local/bin/viper-web && \
  ln -s /home/viper/viper/viper-api /usr/local/bin/viper-api && \
  ln -s /home/viper/viper/viper-cli /usr/local/bin/viper-cli

RUN mkdir -p /var/lock/viper-web \
             /var/lock/viper-api \
             /var/log/supervisor
COPY supervisord.conf /etc/supervisor/viper.conf

EXPOSE 8080 9090
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/viper.conf" ]
