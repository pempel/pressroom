FROM ruby:2.2.5

MAINTAINER Eugene Pempel "eugene.pempel@gmail.com"

# Set the current timezone.
ENV TZ Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set the current locale.
RUN apt-get update -qq && apt-get install -y locales > dev/null
RUN sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales > /dev/null
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US

# Set the project directory.
RUN mkdir -p /root/pressroom
WORKDIR /root/pressroom
