FROM archlinux/base

# updated to enable multilib repo for wine
ADD archlinux-x64/pacman.conf /etc/pacman.conf

RUN pacman -Syu --noconfirm --needed clang diffutils gcc git make openssl parallel wine

ADD test /test
