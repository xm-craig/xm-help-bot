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
swiftypeapi = require('swiftype')


module.exports = (robot) ->
  swiftype = new swiftypeapi({
    apiKey: 'xDdYytirrYZv-WMvkbmS'
  })

  robot.respond /search (.+)/i, (msg) ->
    room = msg.message.room || 'escape'
    query = msg.match[1].trim()
    msg.send "working on it ..."
    swiftype.search
      engine: "help-site"
      q: query
      ((err, res) ->
        console.log(res)
        for o of res.records.page
          console.log(o)

      )
