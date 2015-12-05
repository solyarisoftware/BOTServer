# Telegram Bot Platform

[Telegram](http://Telegram.org) chat platform is in an early stage but amazing [chatbot](https://en.wikipedia.org/wiki/Chatterbot) architecture. Please read offical documentation for an introduction:

* [Telegram Bot Platform Revolution!](https://telegram.org/blog/bot-revolution) 
* [Bots: An introduction for developers](https://core.telegram.org/bots)
* [Telegram Bot API](https://core.telegram.org/bots/api)


## Telegram Bot Architecture(s)

Telegram Bots are special accounts that do not require an additional phone number to set up. These accounts serve as an interface for code running somewhere on your server. See: https://core.telegram.org/bots

The Bot API is an HTTP-based interface created for developers keen on building bots for Telegram. See: https://core.telegram.org/bots/api

### Basics example

In the sketch here below:
- User Giorgio chat with HelloWorldbot Telegram chatbot.
- HelloWorldbot is just a Hello World /echo server application
- User communicate with Telegram.org networking through the Telegram client app installed on a smartphone/tablet/pc
- Telegram Bot API server forward messages updates to a third party backend app HellowWorldbot via HTTPS

```
+---------------------+       +--------------+       +-------------------------------+
| Giorgio chat with   |       |              |       | HelloWorldbot                 |
| HelloWorldbot       |       |              |       | application server            |
| using Telegram app  |       |              |       |                               |
| +---+               |       |      |       | https |                               |
| |   +------------------->----------|----------->-------------------+               |
| |   | Hello!        |       |      |       |       |               |               |
| |   |               |       |      |       |       | +-------------v-------------+ |
| |   |               |       |   Bot API    |       | |  input message: "Hello!"  | |
| |   |               |       |    Server    |       | | output message: "World!"  | |
| |   |               |       |      |       |       | +-------------+-------------+ |
| |   | World!        |       |      |       | https |               |               |
| |   <-------------------<----------|-----------<-------------------+               |
| +---+               |       |      |       |       |                               |
|                     |       |              |       |                               |
+---------------------+       +--------------+       +-------------------------------+
User device                   Telegram Network       Bot Owner Server
```


### Webhooks vs Long Polling

There are two mutually exclusive ways of receiving updates for your bot — the getUpdates method on one hand and Webhooks on the other. See: https://core.telegram.org/bots/api#getting-updates

- **Long Polling**

  Application Bot talk with Telegram server opening an HTTPS persistent connection to send requests and receive updates (HTTP long polling mode). This is the simplest scenario, good for develop environments. You can set up a bot very quickly. 

  Note:
  Alexander Tipugin's [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) Ruby gem, an excellent Telegram Bot APIs wrapper that implement long polling mode.
  Here below the example code hello world using long polling technique under the woods:


```Ruby
require 'telegram/bot'

token = 'INSERT_HERE_YOUR_REAL_BOT_TOKEN'

# 
# echo-server useless bot
# just to test long-polling = 1 bot, 1 process mode
#
Telegram::Bot::Client.run(token) do |client|
  client.listen do |message|

    # print message sent by user 
    puts "received message by: #{message.from.first_name}, text: #{message.text}"
    
    # echo-server, just for test purpose
    case message.text
    when /.+/ 
      text = "#{message.from.first_name}:#{message.text}"
      chat_id = message.chat.id

      # send echo tu user 
      client.api.send_message(chat_id: chat_id, text: text)
      puts "#{update_id}:#{message_id}:#{text}"
    end  
  end
end
```


- **Webhooks**

  Application Bot send requests on a HTTPS client connection, as in the previous case, but receive updates as webhooks (certificated HTTPS POSTs). In this scenario the application Bot is behind a web server that have to manage incoming webhooks calls. This solution is good for a production environment because webhooks als for performance reasons. The webhooks approach is perfect to manage MULTIPLE Bots in a single third party server.  

```
      +----+
      | device                 +---------+
      |    |     +-------+     |      device                   +-----+
      |    |     |    device   |         |                  device   |
      +--+-+     |       |     |         |   +-------------+   |     |
         |       +---+---+     +----+----+   |             |   |     |
         |           |              |     device           |   +--+--+
         |           |              |        +------+------+      |
         |           |              |               |             |
+--------+-----------+--------------+---------------+-------------+------------------+
| T E L E G R A M . O R G   N E T W O R K                                            |
+--+----------------------------------------+-----+-------------------------------+--+
   | Telegram Bot Webhooks API              |     | Telegram Bot Long Polling API |
   +-+-+-+---------------------------+-+-+--+     +--+------------+--+------+-+---+
     v v v                           ^ ^ ^           v            v         ^ ^
     | | | HTTPS webhooks            https           | many HTTPS |         | |
  +--| | |--+                        | | |           | persistent |         | |
  |  | | |  +---------------+        | | |           | conn.      |         | |
  |  | | +--> Bot 1         |--------+ | |           |            |         | |
  |  | |    +---------------+          | |           v            v         ^ ^
  |  | |    |                          | |           |            |         | |
  |  | |    +---------------------+    | |           |            |         | |
  |  | +----> Bot 2               |----+ |     +-----v------+     |         | |
  |  |      +---------------------+      |     | Bot 1      |---------------+ |
  |  |      |                            |     +------------+     |           |
  |  |      +--------+                   |                        |           |
  |  +------> Bot N  |-------------------+                        |           |
  |         +--------+                                   +--------v-----+     |
  |         |                                            | Bot N        |-----+
  +---------+ Webhooks BOTServer                         +--------------+
```

## What way do I choose?

Interesting article [Bot Revolution. Know your API or die hard.](http://web.neurotiko.com/bots/2015/08/03/bots-know-your-api/) by Miguel Garcia Lafuente! I quote here his conclusion:

> 
> _That depends to you and what you want, if you are going to have many requests, you should use the webhook, it can handle better many messages, and it’s faster. The webhook are real PUSH data._
>
> _If you are not going to have 50 requests/second, you can use getUpdates if you prefer._
>
> _Also, if you don’t have a web server with domain and verified SSL, you will have to use the getUpdates._
> _My suggestion are: If you have domain and SSL, use webhook, if don’t, use getUpdates. When you are testing, use getUpdates :)_
> 


## Why a lot of bots ?

> What kind of application needs a very large number of bots to be managed at once!? 
> Let consider as example, a *sort of e-commerce marketplace*, where your backend bot "marletplace" server must manage multiple bots, and where each bot implement a shop chatterbot that manage online orders! 
>
> Still Confused ? 
> I'm working around some bots innovative usage examples for humans-to-humans service mediation by bots, see: [Innovative Chatbot Services with Telegram](https://github.com/solyaris/BOTServer/blob/master/wiki/services.md). 
>
> By example consider a "Pizza maker in-store shop" scenario, where a buyer makes an online order chatting with a *virtual shop* bot, that helps buyer filling order and sending order to seller! So, for this *shops marketplace* it make sense to manage a multitude of bots (1 bot = 1 shop) with an efficient server architecture. For this specific business reason I created _BOTServer_: a sort of *webhooks handler microframework to serve "a lot of bots"*.

## Hard-coded vs dynamic plug-ins apps routing ? 

What's the problem to handle a large number bots updates ? Ok, you have to handle an HTTPS POST webhook for each bot (lets consider bot and app as a synonymous of a specific bit application logic). Let me show two possible approaches in following paragraphs.

## Hard-coding webhooks ? 
The "hard-coded" way is to build-up a rack routing that in Sinatra pseudocode could be something like this:

```Ruby
app_1 = create_instance('APP_TOKEN_1')
app_2 = create_instance('APP_TOKEN_2')
app_N = create_instance('APP_TOKEN_N')

post '/APP_TOKEN_1' do | token |
    app_1.update(data_from_request_body(token))
end

post '/APP_TOKEN_2' do | token |
    app_2.update(data_from_request_body(token))
end

post '/APP_TOKEN_N' do | token |
    app_N.update(data_from_request_body(token))
end
```

That's a possible way, but every time you have to add a new app, a Telegram bot (a new shop), you have to modify the router source code :( pretty awful in a production system, isn't it ?


## Bots as *BOTServer* apps plug-ins! 

BOTServer run-time engine is very simple dynamic router: it's a [rack](https://github.com/rack/rack) server (now implemented with [Sinatra](http://www.sinatrarb.com/), but I'll soon substitute it with flat *fast* rack app), that dispatch dinamically incoming token webhooks, calling update method of an instance of a class generated with a template sckeleton, that define the bot. 

> Yes, I used a bit "Ruby on Rails" metaprogramming for the routing-game. 

Here below the router (`rackup/router.rb`) code extract:

```Ruby
# load bots in memory. return a lookup table
set lookup: Loader.lookup(Config.tokens_config_file)

# HTTPS POST webhook endpoint(s)
post '/:token' do | token |

  # retrieve name, method object pair from lookup table
  bot = settings.lookup[token.to_sym]
  
  if bot
    # get webhook update
    update = json_load request.body

    # route update to corresponding app
    bot[:method].call update 
  end
end
```

### App templating ?

My idea is to generate, for each bot, an app template, to be filled with your own logic.

> The generated app implement an echo-server trivial logic, it's just an example to be used as **skeleton for your REAL BOT application (to be coded inside the `update` method!)**. 

To generate the skeleton app for token `YOUR_BOT_TOKEN` corresponding to Telegram bot `Yourbot`:

```bash
$ rake app:new[YOUR_BOT_TOKEN]
```
create the app skeleton file: `app/yourbot.rb`:

```Ruby
#
# file: yourbot.rb 
#
require 'telegram/bot'

class Yourbot 
  attr_reader :token, :client

  def initialize
    @token = 'YOUR_BOT_TOKEN'
    @client = Telegram::Bot::Client.new(@token)
  end

  #
  # message(s) updates from telegram server.
  # put ALL your Telegram Bot logic here.
  #
  def update(data)
    update_id = data.update_id
    message = data.message
    message_id = message.message_id 
    
    # #######################
    # PUT HERE YOUR BOT LOGIC
    # #######################

    # echo-server, just for test purpose
    case message.text
    when /.+/ 
      text = "#{message.from.first_name}:#{message.text}"
      chat_id = message.chat.id

      # send echo tu user 
      client.api.send_message(chat_id: chat_id, text: text)
      puts "#{update_id}:#{message_id}:#{text}"
    end  
  end
end
```
