/*global module require*/

var ApiV1 = require('./lib/api-v1');

var v1 = function(hostname) {
	var rest = require('rest'),
		mime = require('rest/interceptor/mime'),
		errorCode = require('rest/interceptor/errorCode');
	var client = rest.wrap(mime).wrap(errorCode);
	return new ApiV1(client, hostname);
};

module.exports = {
	local: function() {
		var local = require('./lib/local-client')(Array.prototype.slice.call(arguments));
		return {
			v1: function() { return new ApiV1(local); }
		};
	},
	host: function(hostname) {
		var parts = hostname.split('://');
		if (parts.length == 1) {
			hostname = 'http://' + hostname;
		}
		return {
			v1: function() { return v1(hostname); }
		};
	},
	v1: function() {
		return v1('http://pokeapi.co');
	}
};
