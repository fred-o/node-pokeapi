When = require 'when'

module.exports = class Api

    constructor: (@client, @host='') ->

    _expand: (ids) ->
        ret = []
        for id in ids.split /,/
            if m = id.match /(\d+)-(\d+)/
                ret.push i for i in [parseInt(m[1])..parseInt(m[2])]
            else
                ret.push parseInt(id)
        return ret

    _get: (url) =>
        @client(@host + url).then (res) ->
            res.entity
        , (err) ->
            When.reject err.status

    get: (args...) =>
        if typeof args[0] is 'string'
            if args.length is 1
                if typeof args[0] is 'string'
                    @_get "/api/v1/#{args[0]}/"
            else if args.length is 2
                if typeof args[1] is 'number'
                    @_get "/api/v1/#{args[0]}/#{args[1]}/"
                else if typeof args[1] is 'string'
                    ids = @_expand(args[1])
                    if ids.length is 1
                        @get(args[0], ids[0])
                    else
                        When.all(@get args[0], id for id in ids)
        else if typeof args[0] is 'object' and args[0].resource_uri?
            @_get args[0].resource_uri
        else if Array.isArray(args[0])
            When.all(@get id for id in args[0])
        else
            console.log 'couldnt handle', args
