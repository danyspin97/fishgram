#! /usr/bin/env fish

source api_methods.fish
source corebot.fish

function processMessage
    sendMessage "ciao"
end

function processCallbackQuery
end

function processEditedMessage
end

function processInlineQuery
end

function processChoosenInlineResult
end
start_bot
