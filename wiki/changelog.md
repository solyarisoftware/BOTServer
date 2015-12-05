# Changelog


## To do

- [ ] long running bot/apps: work queue for each bot and configure a dequeuer (a separated multithreaded process?).
- [ ] Possibly separate the router from any Telegram bot webhook logic dependency. 
  > Router logic is a general concept, indipendent from Telegram webhooks logic.

------

- [ ] Send Messages: manage the telegram server message rate limit issue (https://core.telegram.org/bots/faq#my-bot-is-hitting-limits-how-do-i-avoid-this)
- [ ] Make a _BOTServer_ gem 
- [ ] Possibly embed Telegram API client in a module/class, avoiding a direct dependence.
- [ ] statistics: router could maintain in-memory traffic statistics (per bot) to be queryied in run-time with a GET /stats. real-time Statistics are also useful for tuning the work queues architecture. 

------

- [ ] `rake webhook:set:all` to set webhooks for all valid tokens, reading data in `tokens.yml`
- [ ] `rake app:new:all` to create app template, for all valid tokens in `tokens.yml`, that haven't yet an app file
- [ ] Update `server.yml` after certificate generation
- [ ] Server loader must test available bot list, looking up just bots with setWebhook true.
- [ ] Server loader must test if app file exist for corresponding bot in list.
- [ ] Configure [Puma](http://puma.io/) to be used as alternative rack server (for threads/JRuby), instead of Thin (eventmachine-based)
- [ ] Better dependencies in rakefile.

## Release notes

### v.0.1.0 - 6 December 2015
- [x] previous Sinatra rackup webhook router substituted with a **pure Rack implementation** router (for better performances)
- [x] all heredocs moved in clear/editable template files (inside `/templates` directory)
- [x] start/stop/restart NGINX proxy server with rake commands.
- [x] better documentation 

### v.0.0.1 - 28 November 2015
- [x] First release

