When = require 'when'

module.exports = (objs) ->
    db = {}
    read = (obj) ->
        if Array.isArray obj
            read o for o in obj
        else if obj.resource_uri?
            db[obj.resource_uri] = obj
    read Array.prototype.slice.call arguments

    (uri) ->
        if resource = db[uri]
            When entity: resource
        else
            When.reject status: code: 404
