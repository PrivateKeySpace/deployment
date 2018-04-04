FROM node:9

# variables
ARG REACT_APP_API_BASE_URL
ARG root_dir_path=/var/www/pks
ENV ROOT_DIR_PATH $root_dir_path
ENV DEBIAN_FRONTEND noninteractive

# install system dependencies: general
RUN apt-get update
RUN apt-get install -y git nginx

# copy application code
RUN mkdir -p $root_dir_path
COPY code $root_dir_path/web

# build application
WORKDIR $root_dir_path/web
RUN make install
RUN make build
RUN yarn global add replace-in-file
RUN cp -r ./build ./build_clean

# clean up
RUN rm -rf ./.git ./src ./flow-typed ./node_modules
RUN yarn cache clean
WORKDIR $root_dir_path

# configure nginx
COPY virtualhost.nginx /etc/nginx/sites-available/pks_web
RUN ln -s /etc/nginx/sites-available/pks_web /etc/nginx/sites-enabled/pks_web
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
