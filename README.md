# Please note this project is longer being maintained by me, (officially in code freeze mode). Free feel to fork and play.

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
    
    $ capify .
    
Next generate the stages and deploy files by typing:

    $ rake debot:setup
    
NB: You need to require debot in your own deploy.rb file, that is if you don't want debot to generate the stages and deploy files for you as show above.


## Usage
For a detailed list of all the the task availble:

    $ cap -vT

To provision an ubuntu based VPS:

    $ cap debot:install

To setup your application/website:

    $ cap deploy:setup
    
NB: this will setup your postgres database, nginx and unicorn config for the application.

If you need to work on a bug  in production first:

    $ cap go:down
    
And then after the bug is fixed:

    $ cap go:live
    
If you need to undo the application setup (i.e nginx, unicorn and postgres) configs

    $ cap debot:takedown
 
NB: This will undo the setup for your postgres database, nginx and unicorn config files for the application in question.

##Version

0.0.1

(I am just pouring out ideas on this gem, as i use it on multiple projects. it is under constant development. You are welcome to contribute, try it out and give feeback)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Contributors

* [Ikenna N. Okpala](http://ikennaokpala.com)

