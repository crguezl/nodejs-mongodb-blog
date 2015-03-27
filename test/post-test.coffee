mongoose = require 'mongoose'
Post     = require '../models/Post'
chai     = require 'chai'
expect   = chai.expect

describe 'Post', ->
  before (done) ->
    mongoose.connect 'mongodb://localhost/coffeepress', ->
      Post.remove done
  it 'should create a new post', (done) ->
    post = new Post(title:'First!', body:'First post bastiches!')
    post.save ->
      Post.findOne _id: post._id, (err, retrievedPost) ->
        expect(retrievedPost.title).eql "First!"
        expect(retrievedPost.body).eql "First post bastiches!"
        done()
