require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8080

trap('INT') { server.shutdown }
path = '/dungeon'
server.mount_proc path do |req, res|
  res.content_type = "text/text"
  res.body = req.path
end

server.start