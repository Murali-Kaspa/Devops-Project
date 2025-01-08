FROM nginx:latest
copy index.html /usr/share/nginx/html/
expose 80
cmd ["nginx", "-g","daemon off;"]
user "Murali Krishna Kaspa"
