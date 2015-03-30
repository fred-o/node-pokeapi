(function() {
  var Api, When,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  When = require('when');

  module.exports = Api = (function() {
    function Api(client, host) {
      this.client = client;
      this.host = host != null ? host : '';
      this.get = bind(this.get, this);
      this._get = bind(this._get, this);
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
      return this.client(this.host + url).then(function(res) {
        return res.entity;
      }, function(err) {
        return When.reject(err.status);
      });
    };

    Api.prototype.get = function() {
      var args, id, ids;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (typeof args[0] === 'string') {
        if (args.length === 1) {
          if (typeof args[0] === 'string') {
            return this._get("/api/v1/" + args[0] + "/");
          }
        } else if (args.length === 2) {
          if (typeof args[1] === 'number') {
            return this._get("/api/v1/" + args[0] + "/" + args[1] + "/");
          } else if (typeof args[1] === 'string') {
            ids = this._expand(args[1]);
            if (ids.length === 1) {
              return this.get(args[0], ids[0]);
            } else {
              return When.all((function() {
                var j, len, results;
                results = [];
                for (j = 0, len = ids.length; j < len; j++) {
                  id = ids[j];
                  results.push(this.get(args[0], id));
                }
                return results;
              }).call(this));
            }
          }
        }
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
