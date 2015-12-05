# BOTServer 

[Telegram](http://Telegram.org) Bot API Webhooks Framework, for Rubyists.
_BOTServer_ configures, tests and deploys bots, with a fast rack server.

![](https://github.com/solyaris/BOTServer/blob/master/wiki/BOTServer.png)

## [Telegram Bots Platform Archiectures ?](https://github.com/solyaris/BOTServer/blob/master/wiki/architectures.md)

Details about Telegram Bot API long polling vs webhooks: [Telegram Bot Platform](https://github.com/solyaris/BOTServer/blob/master/wiki/architectures.md)

## Webhooks ?

There are at least three Telegram Bot Ruby clients (as far as I know), here listed [Telegram BOT Ruby clients](https://twitter.com/solyarisoftware/status/661557797583233024):
* https://github.com/atipugin/telegram-bot-ruby
* https://github.com/eljojo/telegram_bot
* https://github.com/shouya/telegram-bot

> **NOTE: 
> All of them implement Telegram Bot API long polling way, with `getUpdates` endpoint. 
> No one of these gems implement the webhooks mode.**


* **Webhooks vs long polling**

  _BOTServer_ first goal is to set-up a Ruby way to manage Telegram Bot API webhooks `Updates`, a performance improvement in comparison with HTTPS long polling mode. 

  This project is related to [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) gem, Alexander Tipugin's excellent Telegram Bot client APIs wrapper; to thank him for his work, I tried to solve issue #19: [setting up webhooks with telegram-bot-ruby ?](https://github.com/atipugin/telegram-bot-ruby/issues/19). _BOTServer_ closed the issue :)

*  **Multiple bots webhooks updates routing**

  > Receiving HTTPS webhooks callbacks is probably more efficient than getting updates on a long polling connection, but the real need of webhooks is when you have **dozen, hundreds of bots to manage at once with your server**. In this scenario, it could pretty impossible to manage in a single host, using long polling connections, because the need to maintain open too many Ruby processes/ HTTPS (persistent) connections. 

  ** _BOTServer_ is a toolkit to test and deploy Bot tokens to receive webhooks with a very simple dynamic routing server: a rack server that dispatch dinamically incoming token webhooks, calling update method of an instance of a class generated with a template sckeleton, that define the bot. Details: [Telegram Bot Architecture(s)](https://github.com/solyaris/BOTServer/blob/master/wiki/architectures.md)**

```
  TELEGRAM Bot API Server                         
 --------------------------------------------------------------------
   v v v                                                       ^ ^ ^
   | | |                                                       | | |
   | | |    SSL/HTTPS                                          | | | 
   | | |    front-end       BOTServer                          | | |
   | | |    +-------+       Rack router                        | | |
   | | |    |       |       +------+                           | | |
   | | |    |       |       |      |     +-------+ HTTPS send  | | |
   | | |    |       |       |      |---->| App 1 |-------------+ | |
   | | |    |       | HTTP  |      |     +-------+               | |
   | | |    |       | POST  |      |                             | |
   | | +--->|       |------>|      |     +-------+ HTTPS send    | |
   | +----->|       |------>|      |---->| App 2 |---------------+ |
   +------->|       |------>|      |     +-------+                 |
   webhooks |       |       |      |                               |
 HTTPS POST |       |       |      |     +-------+  HTTPS send     |
            |       |       |      |---->| App   |-----------------+
            |       |       | Thin |     +-------+
            | NGINX |       +------+
            +-------+       
```

### [Assembly instructions in 7 steps](https://github.com/solyaris/BOTServer/blob/master/wiki/usage.md)

_BOTServer_ is a devops utility to: 

* set-up and test tokens/webhooks
* generate a template app for each bot
* run a webhooks router/server. 

Here assembly instruction steps: 

1. Installation (web/proxy server, Ruby project code)
2. Get Telegram Bot token(s)
3. Update configuration files
4. Create (self-signed) Certificate
5. Configure "Webhooks mode" for each token
6. Generate template for each bot
7. Deploy and run _BOTServer_

Keep calm and see: [Assembly instructions in 7 steps](https://github.com/solyaris/BOTServer/blob/master/wiki/usage.md)

After installation of the project, just run `rake` from your project home: 

```
$ rake
rake app:new[token]        # Create bot app template for given token
rake certificate:new       # Create SSL certificate
rake certificate:show      # Show public certificate
rake proxy:config:new      # Generate nginx proxy SSL configuration from server.yml data
rake proxy:restart         # Restart proxy server
rake proxy:start           # Start proxy server
rake proxy:stop            # Stop proxy server
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

## Wiki/documentation

* [Long polling vs webhooks Architectures](https://github.com/solyaris/BOTServer/blob/master/wiki/architectures.md)
* [Assembly instructions in 7 steps](https://github.com/solyaris/BOTServer/blob/master/wiki/usage.md)
* [Why and How to install and set-up NGINX](https://github.com/solyaris/BOTServer/blob/master/wiki/nginx.md)
* [Innovative Chatbot Services with Telegram](https://github.com/solyaris/BOTServer/blob/master/wiki/services.md)

## [To do/Releases](https://github.com/solyaris/BOTServer/blob/master/wiki/changelog.md)

## [License](http://www.opensource.org/licenses/mit-license)

## [Credits/Contributing/Contact](https://github.com/solyaris/BOTServer/blob/master/wiki/contact.md)
