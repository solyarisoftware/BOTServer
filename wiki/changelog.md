# Changelog


## To do

- [ ] long running bot/apps: work queue for each bot and configure a dequeuer (a separated multithreaded process?).
- [ ] statistics: router could maintain in-memory traffic statistics (per bot) to be queryied in run-time with a GET /stats. 
  > Real-time Statistics are also useful for tuning the work queues architecture. 

- [ ] Possibly separate the router from any Telegram bot webhook logic dependency. 
  > Router logic is a general concept, indipendent from Telegram webhooks logic.

- [ ] Telegram server message rate limit issue, on sendMessage API (https://core.telegram.org/bots/faq#my-bot-is-hitting-limits-how-do-i-avoid-this)
- [ ] Make a _BOTServer_ gem 
- [ ] Possibly embed Telegram API client in a module/class, avoiding any direct dependence.

------

- [ ] `rake webhook:set/reset` write status (set/reset) to file `tokens.yml`, for successive query.
- [ ] Server loader must test available bot list, looking up just bots with setWebhook true. Solution: `rake app:test:all` precondition to `rake server:start`: test availability of app files, for all valid tokens in `tokens.yml`
- [ ] `rake app:new:all` to create app template, for all valid tokens in `tokens.yml`, that haven't yet an app file
- [ ] `rake webhook:set:all` to set webhooks for all valid tokens, reading data in `tokens.yml`
- [ ] Update `server.yml` after certificate generation.
- [ ] Configure [Puma](http://puma.io/) to be used as alternative rack server (for threads/JRuby), instead of Thin (eventmachine-based)
- [ ] Fix abominations in utilities.rb (incapsulate methods in a module)
- [ ] Better dependencies in rakefile.


## Release notes

### v.0.1.0 - 6 December 2015
- [x] previous Sinatra rackup webhook router substituted with a **pure Rack implementation** router (for better performances)
- [x] all heredocs moved in clear/editable template files (inside `/templates` directory)
- [x] start/stop/restart NGINX proxy server with rake commands.
- [x] better documentation 

### v.0.0.1 - 28 November 2015
- [x] First release

