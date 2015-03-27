When = require 'when'

module.exports = class Api

    constructor: (@client) ->
        @cache = {}

    _expand: (ids) ->
        ret = []
        for id in ids.split /,/
            if m = id.match /(\d+)-(\d+)/
                ret.push i for i in [parseInt(m[1])..parseInt(m[2])]
            else
                ret.push parseInt(id)
        return ret

    _get: (url) =>
        if @cache[url]
            return @cache[url]
        else
            @cache[url] = @client(url).then (res) ->
                res.entity

    get: (args...) =>
        if args.length is 2 and typeof args[0] is 'string' and typeof args[1] is 'number'
            @_get "/api/v1/#{args[0]}/#{args[1]}/"
        else if args.length is 2 and typeof args[0] is 'string' and typeof args[1] is 'string'
            When.all(@get args[0], id for id in @_expand(args[1]))
        else if typeof args[0] is 'object' and args[0].resource_uri?
            @_get args[0].resource_uri
        else if Array.isArray(args[0])
            When.all(@get id for id in args[0])
        else
            console.log 'couldnt handle', args
