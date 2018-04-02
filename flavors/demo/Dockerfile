FROM ubuntu:16.04

# variables
ARG root_dir_path=/var/www/pks
ENV ROOT_DIR_PATH $root_dir_path
ENV DEBIAN_FRONTEND noninteractive

# install system dependencies: locales
RUN apt-get clean
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
COPY locale /etc/default/locale
RUN locale-gen "en_US.UTF-8" && dpkg-reconfigure locales

# install system dependencies: general
RUN apt-get install -y build-essential apt-transport-https python-software-properties software-properties-common curl git nginx

# install system dependencies: postgres
RUN apt-get install -y postgresql-9.5 postgresql-contrib-9.5 postgresql-client-9.5

# install system dependencies: node & yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs yarn

# set up postgres
USER postgres
RUN service postgresql start && \
    psql --command "CREATE USER pks_user WITH PASSWORD 'pks_password' ;" && \
    psql --command "CREATE DATABASE pks_db ENCODING utf8 ;" && \
    psql --command "GRANT ALL PRIVILEGES ON DATABASE pks_db TO pks_user ;"
USER root

# copy code
RUN mkdir -p $root_dir_path
COPY repos/core $root_dir_path/core
COPY repos/web $root_dir_path/web

# set up `core`
WORKDIR $root_dir_path/core
RUN make install
COPY core.env $root_dir_path/core/.env
RUN make build
RUN service postgresql start && make migratedb-up
RUN rm -rf ./.git ./src ./flow-typed
RUN yarn global add pm2
COPY process.json $root_dir_path/process.json

# set up `web`
WORKDIR $root_dir_path/web
RUN make install
COPY web.env $root_dir_path/web/.env
RUN make build
RUN rm -rf ./.git ./src ./flow-typed ./node_modules
RUN chown -R www-data:www-data $root_dir_path/web/build

# clean up after setup
WORKDIR $root_dir_path
RUN yarn cache clean

# configure nginx
COPY web.vhost.nginx /etc/nginx/sites-available/pks_web
COPY core.vhost.nginx /etc/nginx/sites-available/pks_core
RUN ln -s /etc/nginx/sites-available/pks_web /etc/nginx/sites-enabled/pks_web
RUN ln -s /etc/nginx/sites-available/pks_core /etc/nginx/sites-enabled/pks_core
RUN rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
RUN rm -rf /var/www/html
RUN mkdir $root_dir_path/logs
RUN service nginx restart

# configure container entrypoint
COPY entrypoint.sh $root_dir_path/entrypoint.sh
RUN chmod +x $root_dir_path/entrypoint.sh
CMD ["/bin/bash", "-c", "$ROOT_DIR_PATH/entrypoint.sh"]

# expose container ports
EXPOSE 3000/tcp
EXPOSE 3100/tcp
