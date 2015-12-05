## Why NGINX as front-end proxy server ?

_BOTServer_ is a pro-Soviet project (I'm joking) and we love Igor Sysoev's [NGINX](http://nginx.org/) web server creature!:-). Jokes a part, using a front end server is not mandatory. By example my preferred rack server, [Thin](http://code.macournoyer.com/thin/) is able to manage HTTPS and certificates, but there is a security concern here: when receiving webhooks, you expose your own server to possible attacks, and it's better to do not expose to crazy internet your preferred Ruby rack server (Thin, Puma, whatever).

NGINX is a great fast and robust front-end firewall and load balancer. Last but not least, NGINX know how to manage SSL certificates and all digital certificates' cross-validations. 

## NGINX Installation
NGINX installation depends on your OS. Please refer to [NGINX](http://nginx.org/) website for download and installation info. I use Linux Ubuntu and there installation is simple as:

```
$ sudo apt-get update
$ sudo apt-get install nginx
```

See eventually: [How To Install Nginx on Ubuntu 14.04 LTS](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-14-04-lts) 

## NGINX Configuration

I provided a command utility to show nginx proxy configuration for SSL, you can generate a template configuration.

```bash
rake proxy:new
```

The command just read your server.yml configuration file putting in stadout a possible configuration chunk: 

```
ssl config section to insert in your nginx config file (/etc/nginx/sites-available/default):


upstream backend {
  server 127.0.0.1:3000;
}

# HTTPS server
#
server {
  listen 8443 ssl;
  server_name your_domain.com;

  ssl on;
  ssl_certificate /your_home/BOTServer/ssl/PUBLIC.pem;
  ssl_certificate_key /your_home/BOTServer/ssl/PRIVATE.key;

  ssl_session_timeout 5m;

  ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
  ssl_prefer_server_ciphers on;

  location @backend {
    proxy_pass http://backend;
  }

  location / {
    try_files $uri @backend;
  }
}
```

Now you can copy/paste/modify the above config and update your NGINX configuration file. At least restart the server:

```bash
$ service nginx restart
```


## NGINX in front of Thin or any Ruby Rack server

See architectural overview here behind: NGINX act as a SSL manager, proxy and load balancer in front of one or many rack servers (workers).

```
+-----------------------------------------------------------------------------------+
| TELEGRAM NETWORK                                                                  |
+-----------------------------------------------------------------------------------+
   v v v v                                                                   ^ ^ ^
   | | | |    NGINX                                                          | | |
   | | | |    SSL/HTTPS                                                      | | | 
   | | | |    front-end/balancer                                             | | |
   | | | |    +------+            Hooks Rack Server (Thin worker 1)          | | |
   | | | |    |      |            +------+                                   | | |
   | | | | w  |      |            |      |     +---------------+ HTTPS send  | | |
   | | | | e  |      |            |      ------> App 1         |-------------+ | |
   | | | | b  |      |            |      |     +---------------+               | |
   | | | | h  |      |            |      |                                     | |
   | | | | o  |      |            |      |     +---------------+ HTTPS send    | |
   | | | | o  |      ------------>| W1   -------> App 2        |---------------+ |
   | | | | k  |      |            |      |     +---------------+                 |
   | | | | s  |      |            |      |                                       |
   | | | +--->|      |            |      |     +---------------+  HTTPS send     |    
   | | +----->|      |            |      ------> App N         |-----------------+
   | +------->|      |            |      |     +---------------+
   |     ---->|      |            +------+
   |     ---->|      |        
   |     ---->|      ------------> W2
   |     ---->|      ------------> W3
   |     ---->|      ------------> W4
   |     ---->|      |        
   |     ---->|      |             Hooks Rack Server (Thin worker 5)  
   +--------->|      |            +------+
              |      |            |      |                     
              |      |            |      ------>               
              |      ------------>|W5    ------>                
              |      |            |      ------>               
              |      |            +------+
              +------+     
```

### One NGINX + Many Thin workers ?

To configure Thin workers behind NGINX, see old interesting Marc-André Cournoyer's (Thin creator) post:[Get intimate with your load balancer tonight!](https://macournoyer.wordpress.com/2008/01/26/get-intimate-with-your-load-balancer-tonight/) 

_
