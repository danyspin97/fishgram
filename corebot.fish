#! /usr/bin/fish

source api_methods.fish
source bot.fish
source data.fish

set -g updates_type

function processUpdates
    set type (echo $argv | jq 'if (.message | length) > 0 then 1 else 0 end' )
    if math "$type == 1"
        processMessage (echo $argv | jq .message)
    end
end

set -g api_url "https://api.telegram.org/bot$token/"
set -g async ""

set -g offset 0

while math "$offset == 0" > /dev/null
    set offset (getUpdates 0 1 60 | jq 'if (has(0)) then .[0].update_id else 0 end')
end

while true
    set updates (getUpdates $offset 100 60)
    set updates_length (echo $updates | jq '.[] | length')
    set cont 0
    while math "$cont < $updates_length" > /dev/null
        set update (echo $updates | jq .[$cont])
        processUpdates $update
        set cont (math "$cont + 1")
    end
    set -g offset (math "$offset + $updates_length")
end

