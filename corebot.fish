#! /usr/bin/fish

source api_methods.fish
source bot.fish
source data.fish

function processUpdates
    # Send the update to the right type to be processed
    switch (echo $argv | jq 'if (.message | length) > 0 then 1 else (if (.callback_query | length) > 0 then 2 else (if (.edited_message | length) > 0 then 3 else (if (.inline_query | length) > 0 then 4 else (if (.choosen_inline_result | length) then 5 else 0 end) end) end) end) end')
    case 1
        processMessage (echo $argv | jq .message)
    case 2
        processCallbackQuery (echo $argv | jq .callback_query)
    case 3
        processEditedMessage (echo $argv | jq .edited_message)
    case 4
        processInlineQuery (echo $argv | jq .inline_query)
    case 5
        processChoosenInlineResult (echo $argv | jq .choosen_inline_result)
    end
end

# Set url to call api methods
set -g api_url "https://api.telegram.org/bot$token/"

# Check if the async has been set
if string match $async ""
    # If not, set it to dectivated
    set -g async 0
end

# Set the offset to 0 to get all the last updates
set -g offset 0

# While the offset has not been set to an update
while math "$offset == 0" > /dev/null
    # set the offset to the first udpate not parsed
    set offset (getUpdates 0 1 60 | jq 'if (has(0)) then .[0].update_id else 0 end')
end

# getUpdates loop, process all updates until script gets closed by external signal
while true

    # Get all updates
    set updates (getUpdates $offset 100 60)

    # How many updates did the bot receive?
    set updates_length (echo $updates | jq 'length')

    set -g updates_cont 0
    # Process all updates got by getUpdates
    while math "$updates_cont < $updates_length" > /dev/null

        # Process the current update sending it to the functions is bot.fish
        processUpdates (echo $updates | jq .[$updates_cont])

        # Increment the counter
        set -g updates_cont (math "$updates_cont + 1")
    end

    # Set the new offset to get a new update the next getUpdates call
    set -g offset (math "$offset + $updates_length")
end

