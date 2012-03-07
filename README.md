# Referral, the game

## Installation

This application utilizes Ruby, Sinatra, and Redis.

### Mac

Roughly goes like this

  1. install rvm
  1. install a ruby, preferrably 1.9.3
  1. install homebrew
  1. install redis via homebrew
  1. ```bundle install```
  1. ```gem install shotgun``` --- for debug mode code reloading for sinatra
  1. ```shotgun -p 3000 app.rb```
  1. visit http://localhost:3000

### Linux

Roughly the same as Mac above, except

  1. instead of homebrew, just use ```apt-get``` or ```aptitude```
  1. ```apt-get install redis-server```

## TODO

  * create a score calculator -- walk the tree and calcualte score, likely