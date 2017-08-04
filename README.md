# Fishgram

A wrapper for the Telegram Bot API written in fish. It uses getUpdates to get new updated received by the bot.
It is in an early development stage.

## Features
- Basic api methods
- Easy to use
- Async methods calling

## Requirements
- *fish shell*
- *cURL*
- *jq* (you can either install it from your package-manager or downloading it from [here](https://stedolan.github.io/jq/))

## Installation

In a new folder:

```shell
git submodule add git@github.com:danyspin97/fishgram.git
cp fishgram/config.json .
```

Put the token and settings in config.json.

## Example

### EchoBot

```shell
#!/usr/bin/env fish
# bot.fish

source fishgram/corebot.fish

function processMessage
    sendMessage $text
end
```

## [License](https://github.com/DanySpin97/fishgram/blob/master/LICENSE)
Fishgram is licensed under the MIT License.
