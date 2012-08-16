# Trackman
Trackman is a Heroku add-on that hosts your maintenance pages and their assets outside your app.  
Version them as a part of your project.

works out of the box for Ruby(1.8.7 and 1.9.3) on 
* Rails 2
* Rails 3

##Quick peek
###The first time
* Create maintenance pages as if they were served by your app.
* Run a rake task to setup the heroku configs.
* Deploy the changes and boot your app.

### Need to change your layout or assets?
Simply modify those pages, link different assets, go crazy...  
Trackman will sync upon application boot on your next deployment.


## Getting started
### Step 1 - Install the heroku add-on
```console
heroku addons:add trackman
```
### Step 2 - Add the gem to your Gemfile
```console
gem 'trackman'
```

##### Step 2.1 - Rails 2 only
```console
./script/generate trackman
```
This will add trackman.rake to lib/tasks/ 

### Step 3 - Setup
```console
rake trackman:setup
```
This sets your initial heroku configurations and ensures that when your app is down or in maintenance your pages will be requested by heroku.
If you have maintenance or error pages setup for heroku, we will back them up in a configuration before we override them.  

On your next push Trackman will look for changes to your maintenance pages and sync them!

### Optional - If for any reason you wish to troubleshoot the sync operation:

```console
heroku run rake trackman:sync
```
Calling this command manually will throw exceptions instead of silently failing like the normal sync would.

### For best results, make sure you have those installed:
* Heroku >= 2.26.2
* Bundler >= 1.1.3

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

### Bug reports

Any bug report can be submitted here.
https://github.com/SynApps/trackman/issues


### Creators / Maintainers

* Jeremy Fabre (https://github.com/jfabre)
* Emanuel Petre (https://github.com/epetre)

###Copyright

Copyright © 2012 Emanuel Petre, Jeremy Fabre

## License

  Trackman is released under the MIT license:

  [LICENSE](https://github.com/jfabre/trackman/blob/master/LICENSE)

