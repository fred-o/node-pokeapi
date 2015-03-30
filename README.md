PokeApi
=======

![Build Status](https://img.shields.io/travis/fred-o/node-pokeapi.svg)
![Version](https://img.shields.io/npm/v/pokeapi.svg)
![Licens](https://img.shields.io/npm/l/pokeapi.svg)

A light-weight [promise-based][when.js] [REST][rest] client for accessing
[pokeapi.co], usable from node.js or in the browser (through the magic
of [browserify]).

## Usage

    var PokeApi = require('pokeapi');
	var api = PokeApi.v1();

    api.get('pokemon', 1).then(function(bulbasaur) {
	    console.log("Here's Bulbasaur:", bulbasaur);
		api.get(bulbasaur.moves).then(function(moves) {
		    console.log("Full move list:" + moves);
        })
    }, function(err) {
        console.log('ERROR', err);
    });

### Fetching a resource by ID

Resources can be fetched by supplying the resource name and the ID of
the resource.

    // returns a promise for a single object
    api.get('pokemon', 1)
	// the ID can also be a string
    api.get('pokemon', '1')

    // returns a promise for an array of objects
    api.get('pokemon', '1,2,3,7-9')

### Fetching a resource by resource_uri

You can also get resources by supplying an object with a
`resource_uri` property, or an array of such objects:

    // returns a promise for a single object
    api.get({ resource_uri: '/api/v1/pokemon/1/' })

    // returns a promise for an array of objects
    api.get([ 
        { resource_uri: '/api/v1/pokemon/1/' }, 
        { resource_uri: '/api/v1/pokemon/2/' }
    ]);

This is particularly useful since all references to other objects will
have this format, making it possible to do things like:

    api.get('pokemon', 1).then(function(bulbasaur) {
	    console.log("Here's Bulbasaur:", bulbasaur);
		api.get(bulbasaur.moves).then(function(moves) {
		    console.log("Full move list:" + moves);
        })
    });

## Local client

You can run PokeApi in 'offline' mode, where data is read from locally
stored data files rather than fetched from [pokeapi.co] on every
request. This makes sense in cases when you're working with smaller
sets of data that you don't expect to change a whole lot, i.e. move
types. It's also very useful for working with data inside the browser
without having to bother with setting up an AJAX proxy.

The data objects should have the same format as the output from
`api.get()` (the CLI command is a good way to export the data). You
can specify muliple data files.

    // assuming that types.json and moves.json exists
    var types = require('./types');
    var moves = require('./moves');

    // creating a local client that can be queried for type and move data
	var api = PokeApi.local(types, moves).v1();

## Command-line Interface

PokeApi includes a simple CLI:

    > npm install -g pokeapi
	...

    > pokeapi get type 1
	{"created":"2013-11-02T12:08:58.787000","id":1,"ineffective":[{"name":"rock","resource_uri":"/api/v1/type/6/"},{"name":"steel","resource_uri":"/api/v1/type/9/"}],"modified":"

## Running PokeApi in the browser

PokeApi can be run in the client using [browserify]. In order to query
the [pokeapi.co] server you proably need to set up an AJAX proxy on
your own. If you are running [express] this is pretty straightforward:

    var express = require('express');
	var request = require('request');

    var app = express();
	
	app.get('/api/*', function(req, res) {
	    request('http://pokeapi.co' + req.path).pipe(res);
    });

When setting up the client you then need to tell it to connect to your
own server instead of [pokeapi.co]:

    var api = PokeApi.host('http://myhost').v1()

[pokeapi.co]:http://pokeapi.co
[browserify]:http://browserify.org/
[express]:http://expressjs.com
[rest]:https://www.npmjs.com/package/rest
[when.js]:https://www.npmjs.com/package/when
