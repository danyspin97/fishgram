#!usr/bin/fish

# Send a message
# Usage: sendMessage argv
# @param 1 text
# @param 2 reply_markup
# @param 3 parse_mode
# @param 4 disable_web_page_preview
# @param 5 disable_notification
# @param 6 reply_to_message_id
function sendMessage
    set cont (math (count $argv) + 1)
    while math "$cont < 8" > /dev/null
        set argv[$cont] ""
        set cont (math "$cont + 1")
    end
    set url $api_url"sendMessage?chat_id="$chat_id"&text="$argv[1]"&reply_markup="$argv[2]"&parse_mode="$argv[3]"&disable_web_page_preview="$argv[4]"&disable_notification="$argv[5]"&reply_to_message_id="$argv[6]
    if math "$async == 0" > /dev/null
        curlRequest $url .message_id
    else
        echo (curlRequestAsync $url "") > /dev/null
    end
end

function getUpdates
    set cont (math (count $argv) + 1)
    while math "$cont < 4" > /dev/null
        set argv[$cont] ""
        set cont (math "$cont + 1")
    end
    set url $api_url"getUpdates?offset="$argv[1]"&limit="$argv[2]"&timeout="$argv[3]
    curlRequest $url ""
end

# Request api methods using curl,
# parse received json for error and return the result (based on api method)
function curlRequest
    set response (curl -s $argv[1])
    if string match (echo $response | jq .ok) "false" > /dev/null
        echo $response | jq .desc > log.txt
    else
        echo $response | jq .result$argv[2]
    end
end

function curlRequestAsync
    set response (curl -s $argv[1] &)
    if string match (echo $response | jq .ok) "false" > /dev/null
        echo $response | jq .desc > log.txt
    end
end
