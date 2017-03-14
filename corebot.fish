#! /usr/bin/env fish

set -g DIR (dirname (status --current-filename))

source $DIR/api_methods.fish
source $DIR/bot.fish
source $DIR/updates.fish

function processUpdates
    # Send the update to the right type to be processed
    switch (echo $argv | jq -f $DIR/process_updates.jq)
        case 1
            initMessage (echo $argv | jq -cr .message)
            processMessage
            unsetMessage
        case 2
            initCallbackQuery (echo $argv | jq .callback_query)
            processCallbackQuery
        case 3
            processEditedMessage (echo $argv | jq .edited_message) >/dev/null
        case 4
            processInlineQuery (echo $argv | jq .inline_query) >/dev/null
        case 5
            processChoosenInlineResult (echo $argv | jq .choosen_inline_result) >/dev/null
    end
end

function start_bot

    set token (jq -r '.token' config.json)

    if string match $token "token" >/dev/null
        echo "Token is empty, give a token to continue."
        exit 2
    end

    set -g async (jq '.async' config.json)

    # Set url to call api methods
    set -g api_url "https://api.telegram.org/bot$token/"

    # Set the offset to 0 to get all the last updates
    set -g offset 0

    # While the offset has not been set to an update
    while math "$offset == 0" >/dev/null
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
        while math "$updates_cont < $updates_length" >/dev/null

            # Process the current update sending it to the functions is bot.fish
            processUpdates (echo $updates | jq .[$updates_cont])

            # Increment the counter
            set -g updates_cont (math "$updates_cont + 1")
        end

        # Set the new offset to get a new update the next getUpdates call
        set -g offset (math "$offset + $updates_length")
    end
end
