require "../lib/racker"
use Rack::Static, :urls => ["/css"], :root => "public"
#Rack::Handler::WEBrick.run Racker, :Port => 9191

run Racker