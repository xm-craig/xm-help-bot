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
#  hubot search help for <query terms> - Search help site and display top results for the provided search terms.
#  hubot search confluence for <query terms> - Search Confluence and display top results for the provided search terms.
#
# Notes:
#
# Author:
#   xm-craig <cgulliver@xmatters.com>

_           = require('underscore')
swiftypeapi = require('swiftype')
moment      = require('moment')
querystring = require('querystring')


module.exports = (robot) ->
  slackbotVerificationToken = process.env.HUBOT_SLACKBOT_TOKEN

  swiftype = new swiftypeapi({
    apiKey: process.env.HUBOT_SWIFTYPE_TOKEN
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
                title: page.title + " \u2022 " + page.category
                title_link: page.url
                text: page.body.trim().substr(0, len) + "..."
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
        # Note that confluence uses a different document type than the help site
        for i of results.records.pages
          page = results.records.pages[i]
          len = 137 - page.category.length
          doc = 
                color: "99cc00"
                title: page.title + " \u2022 " + page.category
                title_link: page.url
                text:  page.body.trim().substr(0, 137).replace(/\n/, " ") + "..."
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

  robot.router.post "/#{robot.name}/search/:site", (req, res) ->
    site = req.params.site
    query = querystring.parse(req._parsedUrl.query)
    per_page = query.limit || 5
    terms = req.body.text
    response_url = req.body.response_url

    if (req.body.token != slackbotVerificationToken)
      console.log "*** Received bad token: #{req.body.token}"
      res.sendStatus 400
      return

    res.send "Let's take a look ..."
    swiftype.search
      engine: site
      q: terms
      per_page: per_page
      ((err, results) ->
        if err
          console.log err
        attachments = []
        # Note that confluence uses a different document type than the help site
        for i of results.records.pages
          page = results.records.pages[i]
          len = 137 - page.category.length
          doc =
                color: "99cc00"
                title: page.title + " \u2022 " + page.category
                title_link: page.url
                text:  page.body.trim().substr(0, 137).replace(/\n/, " ") + "..."
                thumb_url: page.image
                footer: "Last Updated"
                ts: moment(page.updated_at, moment.ISO_8601).unix()
          attachments.push doc
        if (_.size(attachments) == 0)
          res.end "No hits! Consider changing your search terms"
        else
          output =
            text: "... here's what I found!"
            attachments: attachments
          console.log("*** SCORES: " + JSON.stringify(output, null, 2))
          # This doesn't work in a async callback
          #res.end JSON.stringify(output, null, 2)
          # need to do this asynchronously
          robot.http(response_url)
            .header('Content-Type', 'application/json')
            .post(JSON.stringify(output, null, 2)) (err, res, body) ->
                if err
                    console.log("Encountered an error while posting results: #{err}")
                console.log res.statusCode
      )


  robot.router.get "/#{robot.name}/status", (req, res) ->
    res.end "200 Ok"

