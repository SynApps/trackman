# Trackman
[Trackman](http://www.trackman-addon.com) is a Heroku add-on that hosts your maintenance pages and their assets outside your app (S3).
You keep them within your project and Trackman syncs them to S3 when you deploy. 

Works out of the box for Ruby(1.8.7 and 1.9.3) on 
* Rails 2.3
* Rails 3.2 and 4.0 beta
* Sinatra

For a detailed tutorial of each framework integration visit the [Wiki](https://github.com/SynApps/trackman/wiki).

## Quick peek  
### The first time
* Run a rake task to setup the heroku configs.
* Generate a controller to scaffold your static pages.
* Deploy the changes and boot your app.

### Need to change your layout or assets?
Simply edit your static pages, link different assets, go crazy!
Trackman will sync upon application boot on your next deployment.

## How to use

### Conventions
We assume your maintenance page is located at:

```console
public/503.html
```

And the page to display if your app breaks during initialization:

```console
public/503-error.html
```

### To troubleshoot the sync operation


```console
heroku run rake trackman:sync
```

Executing this task will throw exceptions instead of silently failing like the normal sync would.
You can also turn debugging on by adding TRACKMAN_DEBUG_ON=true in your env.
It will output every request done by restclient and also a diff about what is getting pushed.


### For best results, make sure you have those installed:
* Heroku >= 2.26.2
* Bundler >= 1.1.3

### Bug reports

Any bug report can be submitted [here](https://github.com/SynApps/trackman/issues).


### Creators / Maintainers

* [Jeremy Fabre](https://github.com/jfabre)
* [Emanuel Petre](https://github.com/epetre)

### Copyright

Copyright © 2012 SynApps

## License

  The trackman gem (client) is released under the MIT license:

  [LICENSE](https://github.com/jfabre/trackman/blob/master/LICENSE)

