# Trackman

Trackman is a Heroku add-on that enables you to handle your maintenance and error pages with the rest of your app and hosts the production version of those files in the cloud.

* It works with rails-like conventions that can be overriden if necessary.
* It is rack-based.
* It will push your pages and all their internal assets upon application initialization. 

## Information

### Platform support

Trackman works out of the box for

* Rails 2
* Rails 3


## Getting started
### Step 1 - Install the heroku add-on
```console
heroku addons:add trackman
```
### Step 2 - Add the client gem to your Gemfile
```console
gem 'trackman'
```

##### Step 2.1 - Rails 2 only
```console
./script generate trackman
```
This will add trackman.rake to lib/tasks/ 

### Step 3 - Setup
```console
rake trackman:setup
```
Sets up your initial configuration and add custom error page add-on if you don't have it yet.

### Optional
```console
rake trackman:sync
```
Performs a manual sync of your error/maintenance pages and their related assets. 
This normally gets executed everytime you deploy to heroku.

### Notes
By convention, we assume your maintenance page is located at

```console
public/503.html
```

If you want two different pages for maintenance and when your app is down, we expect:

For maintenance
```console
public/503.html
```
Broken app
```console
public/503-error.html
```

After the add-on installation

* On the first publish or manual sync, your html file(s) and every internal assets referenced by your pages(s) will be pushed to our server so that we can store them properly on S3.
* On the next publications, only modified assets will be published. 
* Any renamed or missing asset will be handled properly on our side.

### Bug reports

Any bug report can be submitted here.
https://github.com/jfabre/trackman/issues


### Creators / Maintainers

* Jeremy Fabre (https://github.com/jfabre)
* Emanuel Petre (https://github.com/epetre)

###Copyright

Copyright © 2012 Emanuel Petre, Jeremy Fabre

## License

  Trackman is released under the MIT license:

  [www.opensource.org/licenses/MIT](www.opensource.org/licenses/MIT)

