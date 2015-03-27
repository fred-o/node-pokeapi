global.chai   = require 'chai'
global.expect = chai.expect

global.sinon  = require 'sinon'
global.spy    = sinon.spy
global.stub   = sinon.stub
global.match  = sinon.match
global.mock   = sinon.mock

chai.use require('chai-as-promised')
chai.use require('sinon-chai')
chai.should()
