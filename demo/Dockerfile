FROM ubuntu:16.04

# variables
ARG root_dir_path=/var/www/pks
ENV ROOT_DIR_PATH=$root_dir_path

# install system dependencies: general
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl apt-transport-https build-essential git nginx postgresql

# install system dependencies: node & yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs yarn

# copy code
RUN mkdir -p $root_dir_path
COPY repos/core $root_dir_path/core
COPY repos/web $root_dir_path/web

# set up `core`
WORKDIR $root_dir_path/core
RUN make install
RUN make build
# TODO

# set up `web`
WORKDIR $root_dir_path/web
RUN make install
RUN make build
RUN chown -R www-data:www-data $root_dir_path/web/build
# TODO

# configure server
COPY virtualhost.nginx /etc/nginx/sites-available/pks
RUN ln -s /etc/nginx/sites-available/pks /etc/nginx/sites-enabled/pks
RUN rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
RUN rm -rf /var/www/html
RUN service nginx restart

# configure container entrypoint
COPY entrypoint.sh $root_dir_path/entrypoint.sh
RUN chmod +x $root_dir_path/entrypoint.sh
CMD ["/bin/bash", "-c", "$ROOT_DIR_PATH/entrypoint.sh"]

# expose container port
EXPOSE 3000
