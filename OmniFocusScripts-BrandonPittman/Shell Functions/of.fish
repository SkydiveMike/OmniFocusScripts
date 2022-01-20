function of -d "Parse transport text"
  if not test (count $argv) -gt 0
    open -a OmniFocus
  else
    osascript -e "tell application \"OmniFocus\" to parse tasks into default document with transport text \"$argv\"" > /dev/null
    echo "Task added to OmniFocus inbox."
    return 0
  end
end
