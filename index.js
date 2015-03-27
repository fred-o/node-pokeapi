/*global module require*/

var ApiV1 = require('./lib/api-v1');

module.exports = {
	v1: function() {
		var rest = require('rest'),
			mime = require('rest/interceptor/mime'),
			errorCode = require('rest/interceptor/errorCode');
		var client = rest.wrap(mime).wrap(errorCode);
		return new ApiV1(client, 'http://pokeapi.co');
	}
};
