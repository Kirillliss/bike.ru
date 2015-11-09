require 'net/http'
require 'uri'

class CalculateShipping

  def initialize
    @options = {
      id: 1419,
      p: 'hrG8dNDfOMfmlGJJ50oXAxreO9mnPcvJ',
      to_city: 'Москва',
      weight: 1, # вес (кг)
      strah: 1000 # сумма для страховки
    }
  end

  def calculate(query = {})
    # Дописаваем параметры для запроса:
    query.each do |key, value|
      @options[key.to_sym] = value
    end
    # Отправляем запрос:
    @response = post_request_to 'http://www.edost.ru/edost_calc_kln.php'

    if @response
      @response.body
    else
      false
    end
  end

  def xml
    @response.body
  end

  private

    def post_request_to url
      uri_parse = URI.parse(url)
      Net::HTTP.post_form(uri_parse, @options)
    end

end