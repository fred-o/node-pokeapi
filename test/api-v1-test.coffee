ApiV1  = require '../src/api-v1'
When = require 'when'

describe 'ApiV1', ->

    describe 'constructor()', ->

        it 'should should use the supplied hostname, if given', ->
            client = spy (url) -> When(entity:url)
            api = new ApiV1 client, 'http://pokeapi.co'
            api.get('pokemon', 1).then ->
                client.should.have.been.calledWith 'http://pokeapi.co/api/v1/pokemon/1/'

    describe '._expand()', ->
        api = new ApiV1 undefined

        it 'returns a single id when there is only one', ->
            api._expand('1').should.eql [ 1 ]

        it 'expands a list of ids', ->
            api._expand('1,2,3').should.eql [ 1, 2, 3 ]

        it 'expands a range of ids', ->
            api._expand('1-3').should.eql [ 1, 2, 3 ]

        it 'expands a list of ranges', ->
            api._expand('1-3,7-8,13').should.eql [ 1, 2, 3, 7, 8, 13 ]
    
    describe '.get()', ->
        client = api = undefined
        beforeEach ->
            client = (url) -> When(entity:url)
            api = new ApiV1 client

        it 'accepts a resource type', ->
            api.get('pokemon').should.eventually.equal '/api/v1/pokemon/'
        
        it 'accepts a resource type and single id', ->
            api.get('pokemon', 1).should.eventually.equal '/api/v1/pokemon/1/'

        it 'handles a single string id just as it would a numeric', ->
            api.get('pokemon', '1').should.eventually.equal '/api/v1/pokemon/1/'
            
        it 'accepts a resource type and a range of ids', ->
            api.get('pokemon', '1-3').should.eventually.eql [
                '/api/v1/pokemon/1/'
                '/api/v1/pokemon/2/'
                '/api/v1/pokemon/3/'
            ]

        it 'accepts an object with a resource_uri property', ->
            api.get({ resource_uri: '/api/v1/pokemon/1/' }).should.eventually.equal '/api/v1/pokemon/1/'

        it 'accepts an array of identifiers', ->
            api.get([
                { resource_uri: '/api/v1/pokemon/1/' }
                { resource_uri: '/api/v1/pokemon/2/' }
                { resource_uri: '/api/v1/pokemon/3/' }
            ]).should.eventually.eql [
                '/api/v1/pokemon/1/'
                '/api/v1/pokemon/2/'
                '/api/v1/pokemon/3/'
            ]
        
        it 'returns the status object on failure', ->
            client = -> When.reject status: { code: 404 }
            api = new ApiV1 client
            api.get('pokemon', 1).should.eventually.be.rejectedWith { code: 404 }
