# Baukis - Customer management system (Samle of Ruby on Rails4)
Strudy Ruby on Rails by below book.

[実践Ruby on Rails 4 現場のプロから学ぶ本格Webプログラミング](http://amazon.jp/dp/B00LBPDNSY)

[実践Ruby on Rails 4 機能拡張編](http://amazon.jp/dp/B00MWK10CS).

# How to boot Rails

```bash
$ cp .env.dev.sample .env.dev
# Start Rails
$ docker-compose up

# Other terminal
$ docker-compose exec rails bundle ex rake db:create
$ docker-compose exec rails bundle ex rake db:migrate

# Add setting to reoslve  baukis.example.com in /etc/hosts
$ diff
cat /etc/hosts
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
+ 127.0.0.1 baukis.example.com

  127.0.0.1	localhost
  255.255.255.255	broadcasthost
  ::1             localhost
```

Access baukis.example.com:3333
