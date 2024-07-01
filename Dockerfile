# Use uma imagem Ruby oficial como base
FROM ruby:3.3.2

# Instale dependências
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Crie um diretório de trabalho
RUN mkdir /myapp
WORKDIR /myapp

# Copie o Gemfile e o Gemfile.lock
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Instale as gems
RUN bundle install

# Copie o restante do código da aplicação
COPY . /myapp
