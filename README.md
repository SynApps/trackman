# Bombero

Bombero is a Heroku add-on that lets you handle your maintenance and error pages with the rest of your app and hosts the production version of those files on Amazon S3.

* It works with rails-like conventions that can be overriden if necessary.
* It is rack-based.
* It will push your pages and all their internal assets upon application initialization. 

## Information

### Platform support

Bombero should work out of the box for

* Rails 2.x/3.x
* Sinatra v?

## Getting started

### We assume you already installed the addon (if not, go right away!)
No need to add the gem to your Gemfile, it will be added to your bundle during the deployment.

By convention, we assume your maintenance page is located at

```console
/public/503.html
```

If you want different pages for maintenance and when your app is down, we expect 

```console
/public/503.html
/public/503-error.html
```

503 for maintenance and 503-error.html for a broken app.

After the add-on installation

* On the first publish, your html file(s) and every internal assets referenced by your pages(s) will be pushed to our server so that we can store them properly on S3.
* On the next publications, only modified assets will be published. 
* Any renamed or missing asset will be handled properly on our side.

Override conventions? (add something here)

### Bug reports

Any bug report can be submitted here..

https://github.com/jfabre/bombero-client/issues

We strongly encourage you to submit a failing test (if possible) to prove your issue and fasten the bug -> fix cycle.


### Maintainers

* Jeremy Fabre (https://github.com/jfabre)
* Emanuel Petre (https://github.com/epetre)


## License

  ...
