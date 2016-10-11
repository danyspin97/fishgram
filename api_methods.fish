#!usr/bin/fish

# Send a message
# Usage: sendMessage parameters
# @param 1 chat_id
# @param 2 text
# @param 3 reply_markup
# @param 4 parse_mode
# @param 5 disable_web_page_preview
# @param 6 disable_notification
# @param 7 reply_to_message_id
function sendMessage
    set parameters $argv
    set cont (math "count $parameters + 1" > /dev/null)
    while math "$cont < 8" > /dev/null
        set parameters[$cont] ""
        set cont (math "$cont + 1")
    end
    set url $api_url"sendMessage?chat_id="$parameters[1]"&text="$parameters[2]"&reply_markup="$parameters[3]"&parse_mode="$parameters[4]"&disable_web_page_preview="$parameters[5]"&disable_notification="$parameters[6]"&reply_to_message_id="$parameters[7]
    curlRequest $url .message_id
end

function getUpdates
    set parameters $argv
    set cont (count $parameters)
    while math "$cont < 4" > /dev/null
        set parameters[$cont] ""
        set cont (math "$cont + 1")
    end
    set url $api_url"getUpdates?offset="$parameters[1]"&limit="$parameters[2]"&timeout="$parameters[3]
    curlRequest $url ""
end

# Request api methods using curl,
# parse received json for error and return the result (based on api method)
function curlRequest
    set response (curl -s $argv[1] $async)
    if string match (echo $response | jq .ok) "false" > /dev/null
        echo $response | jq .desc > log.txt
    else if string match $async ""
        echo $response | jq .result$argv[2]
    end
    echo $argv
end
