FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y build-essential ca-certificates bash bash-completion libffi-dev tzdata postgresql-client git

RUN git config --global init.defaultBranch main

WORKDIR /app

COPY Gemfile* /app/

RUN gem install bundler

RUN bundle install

RUN bundle binstubs --all

RUN touch $HOME/.bashrc

RUN echo "alias ll='ls -alF'" >> $HOME/.bashrc
RUN echo "alias la='ls -A'" >> $HOME/.bashrc
RUN echo "alias l='ls -CF'" >> $HOME/.bashrc
RUN echo "alias q='exit'" >> $HOME/.bashrc
RUN echo "alias c='clear'" >> $HOME/.bashrc

COPY . ./

CMD [ "/bin/bash" ]