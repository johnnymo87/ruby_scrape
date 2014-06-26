# :map ,ri :w<CR>:!irb -r./%<CR>
require "net/http"
require "uri"
require "nokogiri"

def get_wiki
  uri = URI.parse("http://en.wikipedia.org/wiki/ISO_3166-2")
  response = Net::HTTP.get_response(uri)
  Nokogiri::HTML(response.body)
end

def get_table(nokogiri_doc)
  nokogiri_doc.css('table').first.css('tr').map{|row| row.css('td').map(&:text)}
end

def get_hash(wiki_table)
  wiki_table.each {|row| row.delete_at(1) }
  wiki_table.reject! {|row| row.length != 2 }
  hash = {}
  wiki_table.each do |row|
    hash[row.first] = find_subdivision(row.last)
  end
  hash
end

def find_subdivision(subs)
  subs = subs.split("\n")
  contenders = {}
  subs.each do |sub|
    count, phrase = parse_sub_line(sub)
    contenders[phrase] = count.to_i
  end
  contenders.key(contenders.values.max)
end

def parse_sub_line(line)
  count = line[/\d+/]
  phrase = line.gsub(/\d+/, '').strip
  [count, phrase]
end

def main
  hash = get_hash(get_table(get_wiki))
  file = File.open('subdivisions.txt', 'w')
  hash.each do |k, v|
    file.puts "'#{k}' => '#{v}'\n"
  end
  file.close
end

self.send(:main)
