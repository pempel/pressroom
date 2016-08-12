FROM ruby:2.2.4

MAINTAINER Eugene Pempel "pempel@cleverbits.co"

ENV TZ Europe/Moscow
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV BUNDLE_PATH /bundle
ENV APP_PATH /pressroom

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update > dev/null 2>&1
RUN apt-get install -y lsb-release locales > dev/null 2>&1
RUN sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales > /dev/null 2>&1

RUN mkdir -p $APP_PATH

WORKDIR $APP_PATH

CMD echo "Bundling gems..." && (bundle check || bundle install --jobs 4)
