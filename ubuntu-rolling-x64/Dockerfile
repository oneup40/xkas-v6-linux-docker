FROM ubuntu:rolling

RUN dpkg --add-architecture i386
RUN apt upgrade --yes
RUN apt install --yes clang g++ make
RUN apt install --yes clang diffutils g++ git make openssl parallel wine32

ADD test /test
