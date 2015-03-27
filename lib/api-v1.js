(function() {
  var Api, When,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  When = require('when');

  module.exports = Api = (function() {
    function Api(client, host) {
      this.client = client;
      this.host = host != null ? host : 'http://pokeapi.co';
      this.get = bind(this.get, this);
      this._get = bind(this._get, this);
      this.cache = {};
    }

    Api.prototype._expand = function(ids) {
      var i, id, j, k, len, m, ref, ref1, ref2, ret;
      ret = [];
      ref = ids.split(/,/);
      for (j = 0, len = ref.length; j < len; j++) {
        id = ref[j];
        if (m = id.match(/(\d+)-(\d+)/)) {
          for (i = k = ref1 = parseInt(m[1]), ref2 = parseInt(m[2]); ref1 <= ref2 ? k <= ref2 : k >= ref2; i = ref1 <= ref2 ? ++k : --k) {
            ret.push(i);
          }
        } else {
          ret.push(parseInt(id));
        }
      }
      return ret;
    };

    Api.prototype._get = function(url) {
      if (this.cache[url]) {
        return this.cache[url];
      } else {
        return this.cache[url] = this.client(this.host + url).then(function(res) {
          return res.entity;
        });
      }
    };

    Api.prototype.get = function() {
      var args, id;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (args.length === 2 && typeof args[0] === 'string' && typeof args[1] === 'number') {
        return this._get("/api/v1/" + args[0] + "/" + args[1] + "/");
      } else if (args.length === 2 && typeof args[0] === 'string' && typeof args[1] === 'string') {
        return When.all((function() {
          var j, len, ref, results;
          ref = this._expand(args[1]);
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            id = ref[j];
            results.push(this.get(args[0], id));
          }
          return results;
        }).call(this));
      } else if (typeof args[0] === 'object' && (args[0].resource_uri != null)) {
        return this._get(args[0].resource_uri);
      } else if (Array.isArray(args[0])) {
        return When.all((function() {
          var j, len, ref, results;
          ref = args[0];
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            id = ref[j];
            results.push(this.get(id));
          }
          return results;
        }).call(this));
      } else {
        return console.log('couldnt handle', args);
      }
    };

    return Api;

  })();

}).call(this);