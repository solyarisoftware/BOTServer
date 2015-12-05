# Telegram Bots Man-Machine Services 

> WARNING: 
>
> Very draft doc. Telegram terminology explained: P2P chats, groups, channels and ideas about some "innovative" Telegram chatterbot-based SERVICES, integrating humans an chatterbots. 
 
Here some sketchs that shows [revolutionary](https://telegram.org/blog/bot-revolution) possibilities of man-machine collaborative services using [Telegram](www.telegram.org) instant messaging features using bots and groups!

## Only Humans chats

### (1) P2P messaging

Giorgio and Giuditta send messages each other (one to one chat/ person to person chat). This is the usual P2P Instant Messaging feature: 

```
       Giorgio         Giuditta     
       +---+           +---+        
       |   |           |   |        
       |   |           |   |        
       |   |           |   |        
       |   |           |   |        
       +-+-+           +-+-+        
         |               |          
         |               |
---------v---------------v--------------------
                              TELEGRAM NETWORK
```

### (2) Group Chat

A limited number of people chat togheter in a group. Example: a team of people working togheter: "My Startup teamwork"
 
 ```
                                                   Group chat 
 +----------------------------------------------------------+
 |                                                          |
 |      Giorgio            Paolo                 Giuditta   |
 |      +---+              +---+                 +---+      |
 |      |   |              |   |                 |   |      |
 |      |   |              |   |                 |   |      |
 |      |   |              |   |                 |   |      |
 |      |   |              |   |                 |   |      |
 |      +-+-+              +-+-+                 +-+-+      |
 |        |                  |                     |        |
 +--------|------------------|---------------------|--------+
          |                  |                     |
----------v------------------v---------------------v-----------------
                                                     TELEGRAM NETWORK
```

### (3) Channel (human owner + human administrator)

A Telegram Channel is one-to-many message broadcast. Just the channel owner (and channel administrators) can emit messages (usually related to a specific "channel topic"). People can subscribe to channel to receive news/updates messages. There is not a limit on number of subscribers. Subscribers can not reply to channel emitter.

A typical usage of a channel could be a public alarm alerting system, or in e-commerce/marketing realms, it could be a company advertising campaign. Let In the example:

- Owner: Giorgio 
- Administrator: Aldo 
- Subscribers: Elena, Matteo, etc.

```
                                                  marketing campaign Channel
  +------------------+-----------------------------------------------------+
  |                  |                                                     |
  |  Giorgio  Aldo   |  Elena    Matteo    Giulia    Olga     Giuditta     |
  |  +---+    +---+  |  +---+    +---+     +---+     +---+    +---+        |
  |  |owner   |   |  |  |   |    |   |     |   |     |   |    |   |        |
  |  |   |    |admin |  |   |    |   |     |   |     |   |    |   |        |
  |  |   |    |   |  |  |   |    |   |     |   |     |   |    |   |        |
  |  |   |    |   |  |  |subscr  |subscr   |subscr   |subscr  |subscriber  |
  |  +-+-+    +-+-+  |  +-+-+    +-+-+     +-+-+     +-+-+    +-+-+        |
  |    |        |    |    |        |         |         |        |          |
  +----|--------|----+----|--------|---------|---------|--------|----------+
       |        |         |        |         |         |        |
-------v--------v---------v--------v---------v---------v--------v-----------------
                                                                  TELEGRAM NETWORK
```

## Humans + Bots Collaborative Services

### (4) Group Chat with one Bot

"Pizza maker in-store shop": Shop Owner and Delivery Man share conversations with a "Orders Delivery Bot" consign orders messages to both shop owner and workers

```
   buyers: humans, seller+workers: humans, shopm workteam: humans + Bot = Group chat! 
                +----------------------------------------------------------+
                |      Orders                                              |
                |      Delivery           Shop                  Delivery   |
    Buyer       |      Bot                Owner                 Man        |
    +---+       |      +---+              +---+                 +---+      |
    |   |       |      |   |              |   |                 |   |      |
    |   |       |      |B  |              |   |                 |   |      |
    |   -------------->|O  -------------->|   |                 |   |      |
    |   |       |      |T  ------------------------------------>|   |      |
    |   |       |      |   |              |   |                 |   |      |
    +-+-+       |      +-+-+              +-+-+                 +-+-+      |
      |         |        |                  |                     |        |
      |         +--------|------------------|---------------------|--------+
      |                  |                  |                     |
 -----v------------------v------------------v---------------------v------------     
                                                     TELEGRAM NETWORK
```

### (5) Complex Group Chat: multiple Humans, multiple Bots

"Pizza maker in-store shop, with food delivery outsourced":
Shop Owner and workers share conversations with a "Orders Delivery Bot" that consign orders to them and forward order to a separate "Goods Delivery Manager Bot" of a Delivery Service that manage goods (pizzas) delivery intermediating/dispatching to nearest/free Delivery Man!

```

                      Group chat (Shop)           Group chat (Goods Delivery Service)
+--------------------------------------+    +----------------------------------------+
|                                      |    |      DELIVERY                          |
|      ORDERS             Shop         |    |      Manager    Del.    Del.    Del.   |
|      Bot                Owner        |    |      Bot        Man 1   Man 2   Man 3  |
|      +---+              +---+        |    |      +---+      +---+   +---+   +---+  |
|      |   |              |   |        |    |      |   |      |   |   |   |   |   |  |
|      |B  |              |   |        |    |      |B  |      |   |   |   |   |   |  |
|      |O  -------------->|   |        |    |      |O  -------------->|   |   |   |  |
|      |T  --------------------------------------->|T  |      |   |   |   |   |   |  |
|      |   |              |   |        |    |      |   |      |   |   |   |   |   |  |
|      +-+-+              +-+-+        |    |      +-+-+      +-+-+   +-+-+   +-+-+  |
|        |                  |          |    |        |          |       |       |    |
+--------|------------------|----------+    +--------|----------|-------|-------|----+
         |                  |                        |          |       |       |
---------v------------------v------------------------v----------v-------v-------v-------
                                                                        TELEGRAM NETWORK
```    

### (5) Group Chat with one Bot (IOT/smartHome)

Your HomeBot (resident on a Pc or on a Raspberry!) control home devices/appliances.
Family members remotely can send commands actions to bot, just with Telegram messages!
 
```  
                                   family + bot(s) Group chat  
 +----------------------------------------------------------+
 |                                               Devices    |      
 |      Husband            Wife                  Controller |                
 |      Virginio           Anna                  Bot        |      +----------+
 |      +---+              +---+                 +---+      |      | Device 1 |
 |      |   |              |   |                 |   ------------> +----------+
 |      |   |              |   |                 |B  |      |      +----------+
 |      |   |              |   ----------------->|O  ------------> | Device 2 | 
 |      |   ------------------------------------>|T  |      |      +----------+
 |      |   |              |   |                 |   ------------> +----------+
 |      +-+-+              +-+-+                 +-+-+      |      | Device 3 |
 |        |                  |                     |        |      +----------+
 +----------------------------------------------------------+ 
          |                  |                     |
----------v------------------v---------------------v--------------------
                                                        TELEGRAM NETWORK
```

### (6) Channel with bot(s) as administrator(s)

NewsBot as administrator of the channel, so the bot can broadcast contents to subscribers. In the example: 

- Owner: Giorgio
- Administrator: NewsBot 
- Subscribers: Elena, Matteo, etc.

```
                                       company advertising campaign Channel
  +------------------+-----------------------------------------------------+
  |           News   |                                                     |
  |  Giorgio  Bot    |  Elena    Matteo    Giulia    Olga     Giuditta     |
  |  +---+    +---+  |  +---+    +---+     +---+     +---+    +---+        |
  |  |owner   |BOT|  |  |   |    |   |     |   |     |   |    |   |        |
  |  |   |    |admin |  |   |    |   |     |   |     |   |    |   |        |
  |  |   |    |   |  |  |   |    |   |     |   |     |   |    |   |        |
  |  |   |    |   |  |  |subscr  |subscr   |subscr   |subscr  |subscriber  |
  |  +-+-+    +-+-+  |  +-+-+    +-+-+     +-+-+     +-+-+    +-+-+        |
  |    |        |    |    |        |         |         |        |          |
  +----|--------|----+----|--------|---------|---------|--------|----------+
       |        |         |        |         |         |        |
 ------v--------v---------v--------v---------v---------v--------v-----------------
                                                                  TELEGRAM NETWORK
```

## Contact
- [twitter blog](http://www.twitter.com/solayarisoftware)
- [e-mail](mailto:giorgio.robino@gmail.com)
