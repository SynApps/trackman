# Trackman
Trackman is a Heroku add-on that hosts your maintenance pages and their assets outside your app (S3).
You keep them within your project and Trackman syncs them to S3 when you deploy. 

Works out of the box for Ruby(1.8.7 and 1.9.3) on 
* Rails 2.3
* Rails 3


## Quick peek  
### The first time
* Run a rake task to setup the heroku configs.
* Generate a controller to scaffold your static pages.
* Deploy the changes and boot your app.

### Need to change your layout or assets?
Simply edit your static pages, link different assets, go crazy!
Trackman will sync upon application boot on your next deployment.

### Conventions
We assume your maintenance page is located at:

```console
public/503.html
```

And the page to display if your app breaks during initialization:

```console
public/503-error.html
```

## Getting started
### Step 1 - Install the addon, add the gem and run bundle install


```console
heroku addons:add trackman
```


```ruby
gem 'trackman'
```


```console
bundle install
```

##### Step 1.5 (Rails 2 only) - Generate Trackman tasks 

```console
./script/generate trackman_tasks
```


This will add trackman.rake to lib/tasks/ 

### Step 2 - Setup


```console
rake trackman:setup
```


This sets your initial heroku configurations and ensures that when your app is down or in maintenance your pages will be requested by heroku.
If you already have maintenance or error pages configs for heroku, Trackman will copy with .bkp extensions before he overwrites them.  

### Step 3 (optional) - Scaffold your static pages

##### Rails 2.3

```console
./script/generate trackman_controller [name]  
```

##### Rails 3


```console
rails generate trackman:controller [name]
```

This will generate a special controller that, when on development, will create your maintenance pages for you when you execute its actions.
Because Rails 3 can handle 500 and 404 pages dynamically, the controller also adds the required route to handle them.
On Rails 2, it generates the 4 different static pages instead.

The controller has class methods to filter the response output.  
You can find examples on how to use them within the controller itself.

### Step 4 -  Deploy
Now that you have your maintenance pages, you can commit and push to Heroku.  
Trackman will look for changes to your pages and linked assets and sync them on application boot.

### To troubleshoot the sync operation

```console
heroku run rake trackman:sync
```


Executing this task will throw exceptions instead of silently failing like the normal sync would.

### For best results, make sure you have those installed:
* Heroku >= 2.26.2
* Bundler >= 1.1.3

### Bug reports

Any bug report can be submitted here.
https://github.com/SynApps/trackman/issues


### Creators / Maintainers

* Jeremy Fabre (https://github.com/jfabre)
* Emanuel Petre (https://github.com/epetre)

### Copyright

Copyright © 2012 SynApps

## License

  Trackman is released under the MIT license:

  [LICENSE](https://github.com/jfabre/trackman/blob/master/LICENSE)

