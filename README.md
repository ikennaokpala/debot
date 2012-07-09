# Debot

Custom recipes that extend capistrano for provisioning and deploying rails application to a VPS..

This gem originates from Railscasts (Ryan Bates) excellent series of screencasts on deployment.. I
 suggest you should check it out..

1. [Capistrano Recipes](http://railscasts.com/episodes/337-capistrano-recipes)
2. [Deploying to a VPS](http://railscasts.com/episodes/335-deploying-to-a-vps)
3. [Deployment etc..](http://railscasts.com/?tag_id=21)

## Installation

Add this line to your application's Gemfile:

    gem 'debot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install debot

You need to require debot in you deploy.rb file

## Usage
For a detailed list of all the the task availble:

$ cap -vT

To provision an ubuntu based VPS:

$ cap deploy:install

$ cap go:live

$ cap go:down

$ cap deploy:takedown

##Version

0.0.1.alpha

(I am just pouring out ideas on this gem, as i use it on multiple projects. it is under constant development. You are welcome to contribute, try it out and give feeback)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
