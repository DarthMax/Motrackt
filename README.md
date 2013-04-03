== Motrackt

Motrackt is a simple web application to track all your vehicles via gps.
You can combine position information to tracks, collect meta data and track your vehicle.

## Installation

To install Motrackt first clone the repository.

```
$ git clone git://github.com/DarthMax/Motrackt.git
```

If you haven't done so already install *bundler*

```
$ gem install bundler
```

Now change to your working directory and install all missing gems:

```
$ cd motrackt
$ bundler install
```

You will have to configure '/config/database.yml` to your database settings. For example for mysql

```yaml
production:
  adapter: mysql2
  encoding: utf8
  database: motrackt_production
  username: user
  password: passwd
```

Now you can setup the database:

```
$ rake db:setup
$ rake db:migrate
```

Precompile the assets with

```
$ bundle exec rake assets:precompile
```

Now run `$rake secret` and copy the result to `/app/config/initializers/secret_token.rb`

```ruby
 Motrackt::Application.config.secret_token = '[String goes here]'
```

You can start you application with

```
$ rails server -b 0.0.0.0 -p 3000 -e production
```

and visit `http://localhost:3000`

### Disable user registration

If you want to disable the user registration go to `/config/application.yml` and set `registration_open: false`.
You will have to restart the application to apply this settings.