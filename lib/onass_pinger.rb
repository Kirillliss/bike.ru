require 'cgi'
require 'uri'
require 'net/http'
require 'nokogiri'
require 'httparty'
require 'rest_client'
require 'awesome_print'

url = "http://skibike.dev/products/import?mode=file&filename=import.xml"

# url = URI.parse()


# http = Net::HTTP.new(url.host, url.port)
# request = Net::HTTP::Post.new(url.path)
# request.body = requestXml.to_xml
# request["Content-Type"] = "application/xml"
# response = http.request(request)
# response.code # => 200 Ok
# response.body # => The body (HTML, XML, blob, whatever)

# resource = RestClient::Resource.new url
# # resource.get

# response = resource.post(
#   {
#     mode: 'file',
#     filename: 'import.xml',
#     body: 'blabl'
#   },
#   content_type: 'application/xml'
# )

# puts response.inspect

# xml = '<bla></bla>'

# response = RestClient.post url, requestXml.to_s
# ap response


class OneAsser
  include HTTParty
  base_uri 'skibike.dev'

  def post_one_ass(xml, name = 'import')
    options = {
      query: {
        mode: 'file', 
        filename: "#{name}.xml"
      },

      :headers => {
        "Content-Type" => "application/xml"
      },

      :body => xml
    }
    self.class.post("/products/import", options)
  end
end

one_asser = OneAsser.new

requestXml = Nokogiri::XML(File.open("tmp/import-3.xml"))
response = one_asser.post_one_ass(requestXml.to_xml, 'import')
ap response

requestXml = Nokogiri::XML(File.open("tmp/offers-4.xml"))
response = one_asser.post_one_ass(requestXml.to_xml, 'offers')
ap response