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

  robot.respond /search (.+)/i, (res) ->
    room = res.message.room || 'escape'
    query = res.match[1].trim()
    res.send "working on it ..."
    swiftype.search
      engine: "help-site"
      q: query
      ((err, res) ->
        console.log(res)
        attachments = []
        for i of res.records.page
          page = res.records.page[i]
          attachments.push {title: page.title, title_link: page.url}
        # There are easier ways to post messages, but they do not support attachments
        # Notice the _required_ arguments `channel` and `text`, and the _optional_ arguments `as_user`, and `unfurl_links`
        robot.adapter.client.web.chat.postMessage(res.message.room, "Check out this list!", {as_user: true, unfurl_links: false, attachments: attachments})
      )
