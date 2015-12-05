# Usage, step by step

After installation of the project, just run `rake` from your project home: 

```
$ rake
rake app:new[token]        # Create bot app template for given token
rake certificate:new       # Create SSL certificate
rake certificate:show      # Show public certificate
rake proxy:config:new      # Generate nginx proxy SSL configuration from server.yml data
rake server:config:show    # Show server configuration: /home/solyaris/BOTServer/config/server.yml
rake server:config:test    # Check server configuration: /home/solyaris/BOTServer/config/server.yml
rake server:log            # Tail -f rack sever logfile: /home/solyaris/BOTServer/log/thin.log
rake server:pid            # Show rack server pid
rake server:restart        # Restart rack server
rake server:start          # Start rack server
rake server:stop           # Stop rack server
rake tokens:show           # Show tokens configuration file: /home/solyaris/BOTServer/config/tokens.yml
rake tokens:test           # Verify if tokens are valid, online querying Telegram Server
rake webhook:reset[token]  # Reset webhook for a given token
rake webhook:set[token]    # Set webhook for a given token
```

BOTServer is nothing else than a devops utility to: 

* set-up and test tokens/webhooks
* generate a templte app for each bot
* run a webhooks server/dispatcher. 

I list here and I'll explain in deep in next paragraphs: 

1. Installation (web/proxy server, Ruby project code)
2. Get Telegram Bot token(s)
3. Update configuration files
4. Create (self-signed) Certificate
5. Configure "Webhooks mode" for each token
6. Generate template for each bot
7. Deploy and run BOTServer

## Step 1. Installation

### 1.1 Deploy on a VPS with a public IP address
To receive webhooks on your server, you have to expose a public IP adress! 

- [x]  Deploy on a VPS 
  The simplest way, that I successfully tested, is to deploy and run BOTServer from a  [Virtual Private Server](https://en.wikipedia.org/wiki/Virtual_private_server) host on a VPS cloud provider, with an assigned domain like: `subdomain.vpsprovider.com` and your webhooks base URL are something like:  `https://subdomain.host.com`

- [ ]  Run from your local machine
  I didn't tested (yet) amazing Alan Shreve's [Ngrok 2.0](https://ngrok.com/) SSL features. Details here: https://ngrok.com/docs/2#tls

> **WARNING:** 
> Even if, at the moment, Telegram Bot API policy is really open and permissive, reverse-proxy solutions, as BELOVED ngrok, allow "volatile" bots webhooks server running on "untrusted" personal computers. That's possibly not a solution to be encouraged. For bot that implement "public services (possibly profit), I suggest to deploy bots with a fixed IP public address. personal opinion.

### 1.2 Install your preferred proxy-server 
NGINX have been the solution for my digital certificate small nightmare. Details here: [Why NGINX as front-end proxy server ?](https://github.com/solyaris/BOTServer/blob/master/wiki/nginx.md)

### 1.3 Install project code and bundle all

```bash
$ git clone https://github.com/solyaris/BOTServer.git && cd BOTServer && bundle install
```

## Step 2. Get your Telegram Bot token(s)

You have to *interactively*! chat with [Telegram Bot Father](https://core.telegram.org/bots#botfather) bot, to create each of your bot!
Copy/paste your tokens and take them secret.


## Step 3. Set-up configuration files

Configure and check tokens.yml and server.yml

### 3.1 Edit tokens.yml
Insert your tokens in config/tokens.yml file

```bash
$ vi config/tokens.yml
```

* tokens.yml example:

```yaml
- token: 070743004:yuSJJdB5L354Zq41iGIggSdYGJ1IhVh8XSA
  description: Il negozio della memoria dimenticata
 
- token: 998001334:zAFo4dBdd3ZZtqgKiGdPqkkYGJ1ppVW8pUZ
  description: Dolcetto o Scherzetto? 
 
- token: 007863333:NNkdudnNhdhGGo775SjYTurr45hh00W99AB
  description: Rosticceria Sacco, la migliore di Genova
 
- token: 565000782:KKKKsssNsshsjHT75SjYTu56klsh00W99AB
  description: Franco Califfano Fruttivendolo
 
- token: 127652228:JjfssGj7GSlSH0075SjYTu5jj845ssWKXXZ
  description: Spaghetteria Nadia Parodi 
```

### 3.2 Check tokens.yml
Online Double-check your tokens, querying Telegram Bot central server:

```
$ rake tokens:test
```

### 3.3 Edit and validate server.yml
```
$ vi config/server.yml
```

* server.yml example:

```yaml
host: your_domain.com 
port: 8443

certificate_file_key: ssl/PRIVATE.key
certificate_file_pem: ssl/PUBLIC.pem
```

```
$ rake server:check
```

## Step 4. Create (self-signed) Certificate

I prepared a rake command to just show on command line terminal an openssl command to build-up secret an public key.

```bash
$ rake certificate:new
```
command print on stdout:

```bash
create private_key, public certificate pair.
modify and run yourself the command below:

openssl req -newkey rsa:2048 -sha256 -nodes -keyout /your_home/BOTServer/ssl/PRIVATE.key -x509 -days 365 -out /your_home/BOTServer/ssl/PUBLIC.pem -subj "/C=IT/ST=state/L=location/O=description/CN=your_domain.com"
```

Now copy/paste the above chunk, to generate your self-signed certificate, modifying the shown command with your personal data (fields: /C /ST /L /O /CN). 

> **WARNING:** 
> I lost many hours struggling because I was not receive any webhook after a setWebhook API call. The problem was that I set a fake /CN value in the certificate command creation :-( 
>
>Telegram setWebhooks API do not check data inside your self-signed digital certificate, returning "ok" even if by example you do not specify a valid /CN! So **be carefull to generate a publick .pem certificate containing /CN=your_domain corresponding to your REAL HOST domain name!** 
 

### configure NGINX to manage your digital certificate

```bash
rake proxy:new
```
Details here: [Why NGINX as front-end proxy server ?](https://github.com/solyaris/BOTServer/blob/master/wiki/nginx.md)


## Step 5. Set Webhooks      

Set webhook for each token:

```bash
$ rake webhook:set[YOUR_TOKEN_1]
$ rake webhook:set[YOUR_TOKEN_2]
$ rake webhook:set[YOUR_TOKEN_N]
```

> WARNING: if you want to reset a webhook, to go back with long polling (EXCLUSIVE) mode, for example for bot associated with token YOUR_TOKEN_N, just run command: 

```bash
$ rake webhook:reset[YOUR_TOKEN_N]
```


### Step 6. Generate template for each of your application bots

create app template for each token:
```bash
$ rake app:new[YOUR_TOKEN_1]
$ rake app:new[YOUR_TOKEN_2]
$ rake app:new[YOUR_TOKEN_N]
```


### Step 7. Deploy and Run

Start nginx web server, start rack server and Monit incoming webhooks!

```bash
$ service nginx restart
$ rake rack:restart
```

Inspect in run-time (tail -f) thin log file:
```
$ rake rack:log
```
```
rx update: 368676631, bot: rosticceriasaccobot
368676632:471:Giorgio:2 litri di latte oro
rx update: 368676632, bot: solyarisoftwarebot
368676633:473:Paola:prova di invio messaggio
rx update: 368676633, bot: focaccieparodibot
368676634:475:Giuditta:mezzo kilo di pane sardo
...
...
```
