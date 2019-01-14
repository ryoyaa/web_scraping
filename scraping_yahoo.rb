require 'nokogiri'
require 'open-uri'

URL = "http://news.yahoo.co.jp/topics"

category = "カテゴリー："

def getTopics(url)
  categories = []

  charset = nil
  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  topicxpath = "//div[contains(concat(\" \",normalize-space(@class),\" \"), \" list \")]/ul/li[not (contains(@class, 'ft'))]/a"

  category_name = {
		"name" => "",
		"topics" => []
	}
  doc.xpath(topicxpath).each do |node|
    parentli = node.ancestors("li").first
    if parentli.attribute("class") && parentli.attribute("class").value == "ttl" then
			if(category_name["name"].empty?) then
				category_name["name"] = node.text
			else
				categories << category_name
				category_name = {
					"name" => node.text,
					"topics" => []
				}
			end
		else
			category_name["topics"] << node.text
		end
	end
	categories << category_name

	return categories
end

topics = getTopics(URL)

topics.each do |topic|
    puts topic
end
