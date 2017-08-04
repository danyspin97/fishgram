#! /usr/bin/env fish

function initMessage
    set -g chat_id (echo $argv | jq -r .chat.id)
    set -g text (echo $argv | jq -r .text)
end

function unsetMessage
    unset text
end
