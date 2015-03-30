PokeApi = require '../index'
ApiV1   = require '../src/api-v1'

describe 'PokeApi', ->

    describe '.v1()', ->

        it 'should return an instance of ApiV1', ->
            api = PokeApi.v1()
            api.should.have.property 'host', 'http://pokeapi.co'

    describe '.host().v1()', ->
        
        it 'should return an instance of ApiV1 with the specified host', ->
            api = PokeApi.host('http://myhost').v1()
            api.should.have.property 'host', 'http://myhost'

        it 'should assume the http:// protocol if none is given', ->
            api = PokeApi.host('myhost').v1()
            api.should.have.property 'host', 'http://myhost'
            
    describe '.local().v1()', ->

        it 'should return an instance of ApiV1 with a local connection', ->
            api = PokeApi.local().v1()
            api.client.should.be.a 'function'
            api.client.should.not.have.property 'skip'
            api.client.should.not.have.property 'wrap'            
