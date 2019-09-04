FROM ubuntu:rolling

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt update
RUN apt upgrade --yes
RUN apt install --yes clang diffutils dos2unix g++ git make openssl parallel wine32

ADD test /test
