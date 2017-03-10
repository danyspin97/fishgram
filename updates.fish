#! /usr/bin/env fish

function initMessage
    set -g chat_id (echo $argv | jq -r .chat.id)
end
