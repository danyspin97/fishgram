# Fishgram

A wrapper for the Telegram Bot API written in fish. It uses getUpdates to get new updated received by the bot.
It is in an realy development stage.

## Features
- Basic api methods
- Easy to use
- Async methods calling

## Requirements
- *fish shell*
- *cURL*
- *jq* (you can either install it from your package-manager or downloading it from [here](https://stedolan.github.io/jq/))

## Installation

```shell
git clone git@gitlab.com:danyspin97/fishgram.git
cd fishgram; mv data_example.fish data.fish
```

Put the token and settings in data.fish.
The bot scripting goes in bot.fish.

## Example

### EchoBot
In bot.fish:

```shell
function processMessage
    set chat_id (echo $argv | jq .from.id)
    set text (echo $argv | jq .text)
    sendMessage $chat_id $text
end
```

## [License](https://gitlab.com/danyspin97/fishgram/blob/master/LICENSE)
Fishgram is licensed under the MIT License.
