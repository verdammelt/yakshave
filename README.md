Yak Shaving crossed with Not Invented Here Syndrome.

[![Build Status](https://travis-ci.org/verdammelt/yakshave.svg?branch=master)](https://travis-ci.org/verdammelt/yakshave)


Full web app in Common Lisp only. Only given is SBCL. Everything else
written here. 

SBCL gives me threads & sockets.

I'll need to write:

* DONE testing framework
* HTTP parsing
* web server
* Lisp->HTML compiler?
* Lisp->JS compiler?
* Heroku buildpack?

Todo:

* Need a better name
* Need an actual feature to implement
** blog?
** weight tracking?
* Testing Framework
** do something with packages?

Random thoughts:
* build creates config file that has verion & git hash in it (for logging & display)
* version also returned in web server headers
* start by serving static data like robots.txt & humans.txt
