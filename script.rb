require 'muni'
require 'json'
require 'binding_of_caller'
require 'pry'

def dump_routes
  [].tap do |routes|
    Muni::Route.find(:all).each do |route|
      rh = route.to_h.merge(inbound: [], outbound: [])
      begin
        route = Muni::Route.find(route[:tag])
        route.inbound.stops.each {|stop| rh[:inbound] << stop.to_h }
        route.outbound.stops.each {|stop| rh[:outbound] << stop.to_h }
      end
      print ?.
      routes << rh
    end
  end
end

def dump_routes_file
  File.open('routes.json', 'w+') {|f| f.write(JSON.dump(dump_routes)) }
end

ROUTES = JSON.parse(File.read('routes.json'), symbolize_names: true)

def stop_titles
  ROUTES.map do |route|
    route[:inbound].map {|stop| stop[:title]}.flatten
  end.flatten.sort
end

sthash = Hash.new(0)
stop_titles.each do |st|
  sthash[st] += 1
end
puts "Unique bus stops: #{sthash.count}"
puts "Total bus stops: #{sthash.map(&:last).inject(:+)}"
sthash.sort_by(&:last).reverse.each {|st| p st}
