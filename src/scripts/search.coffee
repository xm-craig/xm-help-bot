# Description
#   A Slack bot that provides a way to search our product help and confluence wiki.
#
# Dependencies:
#   "underscore": ">= 1.8.0"
#   "swiftype": ">= 0.3.0"
#   "moment": ">= 2.0.0"
#
# Configuration:
#
# Commands:
#  `alfred search help for <query terms>` - Search help site and display top results for the provided search terms.
#  `alfred search confluence for <query terms>` - Search Confluence and display top results for the provided search terms.
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

  robot.respond /search help for (.+)/i, (res) ->
    room = res.message.room || 'escape'
    query = res.match[1].trim()
    res.send "Working on it ..."
    swiftype.search
      engine: "help-site"
      q: query
      per_page: 5
      ((err, results) ->
        attachments = []
        for i of results.records.page
          page = results.records.page[i]
          len = 137 - page.category.length
          doc = 
                color: "99cc00"
                title: page.title
                title_link: page.url
                text: page.category + " \u2022 " + page.body.substr(0, len) + "..."
                thumb_url: page.image
                footer: "Last Updated"
                ts: moment(page.updated_at, moment.ISO_8601).unix()
          attachments.push doc
        if (_.size(attachments) == 0)
          res.send "No hits! Consider changing your search terms"
        else
          # There are easier ways to post messages, but they do not support attachments
          # Notice the _required_ arguments `channel` and `text`, and the _optional_ arguments `as_user`, and `unfurl_links`
          robot.adapter.client.web.chat.postMessage(room, "... check it out!", {as_user: true, unfurl_links: false, attachments: attachments})
      )


  robot.respond /search confluence for (.+)/i, (res) ->
    room = res.message.room || 'escape'
    query = res.match[1].trim()
    res.send "Let's take a look ..."
    swiftype.search
      engine: "confluence"
      q: query
      per_page: 5
      ((err, results) ->
        attachments = []
        for i of results.records.page
          page = results.records.page[i]
          len = 137 - page.category.length
          doc = 
                color: "99cc00"
                title: page.title
                title_link: page.url
                text: page.category + " \u2022 " + page.body.substr(0, len) + "..."
                thumb_url: page.image
                footer: "Last Updated"
                ts: moment(page.updated_at, moment.ISO_8601).unix()
          attachments.push doc
        if (_.size(attachments) == 0)
          res.send "No hits! Consider changing your search terms"
        else
          # There are easier ways to post messages, but they do not support attachments
          # Notice the _required_ arguments `channel` and `text`, and the _optional_ arguments `as_user`, and `unfurl_links
          robot.adapter.client.web.chat.postMessage(room, "... and look what I found!", {as_user: true, unfurl_links: false, attachments: attachments})
      )
