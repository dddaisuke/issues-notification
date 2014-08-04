Pusher.log = (message) ->
  window.console.log message  if window.console and window.console.log
  return

pusher = new Pusher("217bd49a38581d0fe86b")
channel = pusher.subscribe("issue")
channel.bind "closed", (data) ->
  console.log(data)
  $('#issues_box').prepend("<div class='issue' id='issue_" + data.number + "'><div class='user'><div class='avatar'><img src='" + data.sender_avatar_url + "'></div></div><div class='timestamp'>" + data.closed_at + "</div><div class='title'><a href='" + data.url + "' target='_blank'>" + data.title + "</a></div></div>")
  return
