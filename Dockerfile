# syntax=docker/dockerfile:1
FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install ansible nano
WORKDIR /
COPY . .
COPY ./ansible.cfg /etc/ansible/ansible.cfg
COPY ./hosts /etc/ansible/hosts
RUN ansible --version
RUN ansible-playbook nginx.yaml
RUN mkdir -p /var/www/example.com/html /var/www/localhost/html
RUN chown -R $USER:$USER /var/www/example.com/html /var/www/localhost/html
RUN chmod -R 755 /var/www
COPY ./example-com-index.html /var/www/example.com/html/index.html
COPY ./localhost-index.html /var/www/localhost/html/index.html
COPY ./sites-enabled-example.com /etc/nginx/sites-enabled/example.com
COPY ./sites-enabled-localhost /etc/nginx/sites-enabled/localhost
# RUN ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
# RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

COPY ./sites-enabled-default /etc/nginx/sites-enabled/default
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./404.html /var/www/example.com/html/
COPY ./404.html /var/www/localhost/html/
EXPOSE 3200
STOPSIGNAL SIGTERM
#CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["nginx", "-g", "daemon off;"]
