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
swiftypeapi = require('swiftype')
moment      = require('moment')

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
      per_page: 5
      ((err, results) ->
        attachments = []
        for i of results.records.page
          page = results.records.page[i]
          doc = 
                color: "99cc00"
                title: page.title
                title_link: page.url
                text: page.category + " \u2022 " + page.body.substr(0, 127) + "..."
                thumb_url: page.image
                footer: "Last Updated"
                ts: moment(page.updated_at).utc()
          attachments.push doc
        # There are easier ways to post messages, but they do not support attachments
        # Notice the _required_ arguments `channel` and `text`, and the _optional_ arguments `as_user`, and `unfurl_links`
        robot.adapter.client.web.chat.postMessage(room, "Check out this list!", {as_user: true, unfurl_links: false, attachments: attachments})
      )
