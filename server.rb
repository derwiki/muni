require 'sinatra'
require 'muni'
require 'haml'

RS = {
	r48: Muni::Route.find(48),
	r19: Muni::Route.find(19),
	r10: Muni::Route.find(10),
	r91: Muni::Route.find(91)
}

get '/' do
  stops = [
    RS[:r10].inbound.stop_at('Wisconsin St & Madera St'),
    RS[:r19].inbound.stop_at('De Haro St & 23rd St'),
    RS[:r48].inbound.stop_at('25th St & Wisconsin St'),
    RS[:r48].outbound.stop_at('25th St & Wisconsin St'),
  ]
  routes = {}
  stops.map do |stop|
    direction = stop.direction !~ /___O_/ ? 'Inbound' : 'Outbound'
    key = "#{stop.route_tag} #{direction} at #{stop.title}"
    routes[key] = stop.predictions
  end

  haml :index, locals: { routes: routes }
end
