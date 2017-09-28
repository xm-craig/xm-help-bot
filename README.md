
xm-help
=======

A Slack bot that provides a way to search our product help and confluence wiki.

API
---
*  `hubot search help for <query terms>` - Search help site and display top results for the provided search terms.
*  `hubot search confluence for <query terms>` - Search Confluence and display top results for the provided search terms.

## Configuration

Some of the behavior of this plugin is configured in the environment:


### Running xm-help Locally

You can test your hubot by running the following, however some plugins will not
behave as expected unless the [environment variables](#configuration) they rely
upon have been set.

You can start xm-help locally by running:

    % bin/hubot

You'll see some start up output and a prompt:

    [Sat Feb 28 2015 12:38:27 GMT+0000 (GMT)] INFO Using default redis on localhost:6379
    xm-help>

Then you can interact with xm-help by typing `xm-help help`.

    xm-help> xm-help help
    xm-help search <query terms> - Display top results for the provided search terms.
    xm-help help - Displays all of the help commands that xm-help knows about.
    ...


## Deployment
```
    % heroku create --stack cedar
    % git push heroku master
```
If your Heroku account has been verified you can run the following to enable
and add the Redis to Go addon to your app.
```
    % heroku addons:add redistogo:nano
```
If you run into any problems, checkout Heroku's [docs][heroku-node-docs].

More detailed documentation can be found on the [deploying hubot onto
Heroku][deploy-heroku] wiki page.


## Slack Variables

The Slack adapter requires some environment variables.

You'll need a Web API token to call any of the Slack API methods. For custom integrations, you'll get this
[from the token generator](https://api.slack.com/docs/oauth-test-tokens), and for apps it will come as the final part
of the [OAuth dance](https://api.slack.com/docs/oauth).

```
    % heroku config:add HUBOT_SLACK_TOKEN="..."
```

## Restart the bot

You may want to get comfortable with `heroku logs` and `heroku restart` if
you're having issues.
