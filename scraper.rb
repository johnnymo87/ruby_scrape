require 'mechanize'
mech = Mechanize.new
url = 'http://www.carris.pt/pt/carreiras/
response = mech.get(url)
doc = Nokogiri::HTML(response.content)

# route color
links=doc.css('.link-lista-carreiras')
links.each { |l| puts l['class'] }

# route name
links = doc.css('.link-lista-carreiras > span.numero-carreira > img')
links.each { |l| puts l['alt'] }



