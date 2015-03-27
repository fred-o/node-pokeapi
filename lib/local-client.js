(function() {
  var When;

  When = require('when');

  module.exports = function(objs) {
    var db, read;
    db = {};
    read = function(obj) {
      var i, len, o, results;
      if (Array.isArray(obj)) {
        results = [];
        for (i = 0, len = obj.length; i < len; i++) {
          o = obj[i];
          results.push(read(o));
        }
        return results;
      } else if (obj.resource_uri != null) {
        return db[obj.resource_uri] = obj;
      }
    };
    read(Array.prototype.slice.call(arguments));
    return function(uri) {
      var resource;
      if (resource = db[uri]) {
        return When({
          entity: resource
        });
      } else {
        return When.reject({
          status: {
            code: 404
          }
        });
      }
    };
  };

}).call(this);
