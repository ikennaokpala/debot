# Debot

Custom recipes that extend capisttrno for provisioning and deploying rails application to a VPS..

## Installation

Add this line to your application's Gemfile:

    gem 'debot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install debot

You need to require debot in you deploy.rb file

## Usage

To provision an ubuntu based VPS.

$ cap deploy:install # this will setup you ubuntu server with nginx, uncorn, imagemagick, postgresql for action..

$ cap go:live # to take the application live

$ cap go:down # this will put you app on standby mode while your figure out what might be going wrong

$ cap deploy:takedown # this does the opposite of install buy removing all configuration and file for a apticular site.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
