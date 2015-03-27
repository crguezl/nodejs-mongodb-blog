routes   = require "../routes/index"
mongoose = require "mongoose"
Post     = require "../models/Post"
#require "should"
chai     = require 'chai'
expect   = chai.expect

describe "routes", ->
  req = 
    params: {}
    body: {}
  res = 
    redirect: (route) ->
      # do nothing
    render: (view, vars) -> 
      # do nothing
  before (done) ->
    mongoose.connect 'mongodb://localhost/coffeepress', ->
      Post.remove done

  describe "index", ->
    it "should display index with posts", (done)->
      res.render = (view, vars) ->
          expect(view).equal "index"
          expect(vars.title).equal "My Coffeepress Blog"
          expect(vars.posts).eql []
          done()
      routes.index(req, res)

  describe "new post", ->
    it "should display the add post page", (done) ->
      res.render = (view, vars) ->
          expect(view).equal "add_post"
          expect(vars.title).equal "Write New Post"
          done()
      routes.newPost(req, res)
    it "should add a new post when posted to", (done) ->
      req.body.post = 
        title: "My Post!"
        body: "My wonderful post."

      routes.addPost req, redirect: (route) ->
        expect(route).eql "/"
        routes.index req, render: (view, vars) ->
          expect(view).equal "index"
          expect(vars.posts[0].title).eql 'My Post!'
          expect(vars.posts[0].body).eql "My wonderful post."
          done()

