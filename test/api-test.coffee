Api  = require '../lib/api'
When = require 'when'

describe 'Api', ->
    
    describe '._expand()', ->
        api = new Api undefined

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
            client = spy (url) -> When(entity:url)
            api = new Api client
        
        it 'accepts a resource type and single id', ->
            api.get('pokemon', 1).should.eventually.equal '/api/v1/pokemon/1/'
            
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

        
