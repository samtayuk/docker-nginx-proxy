nginx: nginx
dockergen: docker-gen -watch -only-exposed -notify "nginx -s reload" /app/virtualhost.tmpl /etc/nginx/conf.d/default.conf
