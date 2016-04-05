FROM ruby

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y wine wine32 xvfb

RUN bundle config --global frozen 1
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install
COPY . /usr/src/app

RUN cp -r /usr/src/app/ygopro-database/* /usr/src/app/ygopro-images-raw/ #TODO: implement in ruby

ENV DISPLAY=:0.0
ENV WINEARCH=win32
ENV RACK_ENV=production
RUN wineboot -i
COPY magicseteditor/fonts /root/.wine/drive_c/windows/Fonts
CMD ["./entrypoint.sh"]