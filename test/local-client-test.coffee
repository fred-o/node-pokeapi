LocalClient = require '../src/local-client'

describe 'LocalClient', ->
    pokemons = [
        { resource_uri: '/api/v1/pokemon/1/', name: 'Bulbasaur' }
        { resource_uri: '/api/v1/pokemon/2/', name: 'Ivysaur' }
        { resource_uri: '/api/v1/pokemon/3/', name: 'Venosaur' }
    ]
    types = [
        { resource_uri: '/api/v1/type/1/', name: 'Normal' }
        { resource_uri: '/api/v1/type/2/', name: 'Fighting' }
    ]

    it 'accepts a list of data objects and returns a fn', ->
        client = LocalClient [ pokemons, types ]
        client.should.be.a 'function'

    it 'accepts one or more data object and returns a fn', ->
        client = LocalClient pokemons, types
        client.should.be.a 'function'
        client('/api/v1/type/1/').should.eventually.eql entity: { resource_uri: '/api/v1/type/1/', name: 'Normal' }

    it 'is possible to query the local storage by resource_uri', ->
        client = LocalClient [ pokemons, types ]
        client('/api/v1/type/1/').should.eventually.eql entity: { resource_uri: '/api/v1/type/1/', name: 'Normal' }

    it 'yield status 404 when a resource could not be found', ->
        client = LocalClient [ pokemons, types ]
        client('/api/v1/type/100/').then chai.assert.fail, (err) ->
            err.should.eql status: { code: 404 }
    
