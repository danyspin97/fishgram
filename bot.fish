#! /usr/bin/fish

source api_methods.fish

function processMessage
    set chat_id (echo $argv | jq .from.id)
    echo (sendMessage $chat_id ahahah)
    echo $chat_id
end
