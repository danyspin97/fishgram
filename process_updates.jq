if (.message | length) > 0
    then 1
else
    (if (.callback_query | length) > 0
        then 2
    else
        (if (.edited_message | length) > 0
            then 3
        else
            (if (.inline_query | length) > 0
                then 4
            else
                (if (.choosen_inline_result | length)
                    then 5
                else 0
                end)
            end)
        end)
    end)
end
