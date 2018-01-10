require 'sinatra'
require 'muni'
require 'haml'

RS = {
  r48: Muni::Route.find(48),
  r10: Muni::Route.find(10),
}

STOPS = [
  RS[:r10].inbound.stop_at('Wisconsin St & Madera St'),
  RS[:r48].inbound.stop_at('25th St & Wisconsin St'),
]

get '/' do
  begin
    routes = {}
    STOPS.map do |stop|
      routes[stop.route_tag] = stop.predictions.take(2)
    end

    haml :index, locals: { routes: routes }

  rescue StandardError => e
    puts "#{e.class}: #{e.message}"
    retry
  end
end
