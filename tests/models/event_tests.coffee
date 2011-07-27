
testCase = require('nodeunit').testCase

module.exports = testCase({

  test1: (test) ->
    Event = require('./lib/models/event').Event
    root = new Event({path: '', name: 'root'})
    console.log root.path, root.name

    popchat = new Event({path: 'popchat', name: 'popchat'})
    root.insert(popchat)

    popchatlogin = new Event({path:'popchat/login', name:'login'})
    root.insert(popchatlogin)

  eventTreeTest: (test) ->
    eventTree = Event.buildFromList ['popchat/login/new','popchat','wallpost','wallpost/tf/published','popchat/login','wallpost/tf']
    console.log JSON.stringify eventTree

})