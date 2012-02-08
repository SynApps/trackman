# Bombero

Bombero is a heroku addon that host your maintenance and error pages on amazon s3.
Devise is a flexible authentication solution for Rails based on Warden. It:

* It works with rails-like conventions that can be overriden
* It is rack based;
* It will push your pages and all their internal assets on application initialization. 

## Information

### Platform support

Bombero should work out of the box for

* Rails 2.x/3.x
* Sinatra xyz?

### Bug reports

Any bug report can be submitted here..

https://github.com/jfabre/bombero-client/issues

We strongly encourage you to submit a failing test (if possible) to prove your issue and fasten the bug -> fix cycle.


## Getting started

### We assume you already installed the addon (if not, go right away!)


By convention, we assume your maintenance page is located at

```console
/public/503.html
```

Once your application published, the gem will push your html and all the internal assets linked in that page to s3.

If you want a page for maintenance and another for when your app is broken, we expect 

```console
/public/503.html
/public/503.error.html
```

override conventions? (add something here)


## Troubleshooting

### Heroku

Using devise on Heroku with Ruby on Rails 3.1 requires setting:

```ruby
config.assets.initialize_on_precompile = false
```


### Maintainers

* Jeremy Fabre (https://github.com/jfabre)
* Emanuel Petre (https://github.com/carlosantoniodasilva)


## License

  ...
