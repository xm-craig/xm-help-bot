# Description
#   
#
# Dependencies:
#   "underscore": ">= 1.0.0"
#
# Configuration:
#
# Commands:
#   hubot  <message> - Initiate the major incident process.
#
# Notes:
#
# Author:
#   xm-craig <cgulliver@xmatters.com>

_           = require('underscore')
querystring = require('querystring')
var SwiftypeApi = require('swiftype')

var swiftype = new SwiftypeApi({
  apiKey: 'xDdYytirrYZv-WMvkbmS'
})

module.exports = (robot) ->

  robot.respond /search (.+)/i, (msg) ->
    room = msg.message.room || 'escape'
    query = msg.match[1].trim()
    swiftype.search({
      engine: 'my-engine',
      q: "'"+query+"'",
    }, function(err, res) {
      console.log(res)
      msg.send "working on it"
    })

