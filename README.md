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

## Getting started

### We assume you already installed the addon (if not, go right away!)
The gem will then be added to your bundle on deployment.

By convention, we assume your maintenance page is located at

```console
/public/503.html
```

If you want a page for maintenance and another for when your app is broken, we expect 

```console
/public/503.html
/public/503.error.html
```

On the fist publish after the addon install, your html file(s) and every internal assets linked will be pushed to s3.
On the next publications, only modified assets will be published.


override conventions? (add something here)

### Bug reports

Any bug report can be submitted here..

https://github.com/jfabre/bombero-client/issues

We strongly encourage you to submit a failing test (if possible) to prove your issue and fasten the bug -> fix cycle.


### Maintainers

* Jeremy Fabre (https://github.com/jfabre)
* Emanuel Petre (https://github.com/epetre)


## License

  ...
