FROM node:9

# variables
ARG root_dir_path=/var/www/pks
ENV ROOT_DIR_PATH $root_dir_path
ENV DEBIAN_FRONTEND noninteractive

# install system dependencies: general
RUN apt-get update
RUN apt-get install -y git nginx

# copy application code
RUN mkdir -p $root_dir_path
COPY code $root_dir_path/core

# build application
WORKDIR $root_dir_path/core
RUN make install
RUN make build
RUN yarn global add pm2
COPY process.json $root_dir_path/process.json

# clean up
RUN rm -rf ./.git ./src ./flow-typed
RUN yarn cache clean
WORKDIR $root_dir_path

# configure nginx
COPY virtualhost.nginx /etc/nginx/sites-available/pks_core
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
EXPOSE 3100/tcp
