class NailSalon < ActiveRecord::Base
  attr_accessible :address, :region, :phone_num, :state, :title, :url, :uuid, :zip, :category
  PAGE = 45 #philadelphia24 #NJ145 #NY203
  class << self

    def grasp
      require 'open-uri'
      code_list = NailSalon.pluck :uuid
      PAGE.times.each do |page|

        doc = retryable(tries: 3) do 
          Nokogiri::HTML(open('http://www.yellowpages.com/ct/nail-salons?g=CT&page=' + (page + 1).to_s + '&q=Nail+Salons'))
        end

        doc.css('#results .result').each do |order|
          unique_code = order.attr('id')[/\d+/]
          unless code_list.include? unique_code
            #nail_salon = NailSalon.new
            #nail_salon.uuid = unique_code
            addr = order.css('.listing_content .listing-address')
            #nail_salon.address = addr.text.delete("/\n") 
            #nail_salon.state = addr.css('.city-state .region').text
            #nail_salon.region = addr.css('.city-state .locality').text
            #nail_salon.zip = addr.css('.city-state .postal-code').text
            #nail_salon.phone_num = order.css('.listing_content .info .phone').text.delete("/\n")
            #nail_salon.title = order.css('.listing_content .info .business-name').text.delete("/\n")
            #nail_salon.category = order.attr('data-category')
            #nail_salon.url = order.css('.listing_content .info .business-name a').attr('href').value
            #nail_salon.save
            NailSalon.create(
              uuid: unique_code,
              address: addr.text.delete("/\n"),
              state:   addr.css('.city-state .region').text,
              region: addr.css('.city-state .locality').text,
              zip: addr.css('.city-state .postal-code').text,
              phone_num: order.css('.listing_content .info .phone').text.delete("/\n"),
              title: order.css('.listing_content .info .business-name').text.delete("/\n"),
              category: order.attr('data-category'),
              url: order.css('.listing_content .info .business-name a').attr('href').value
            )
          end
        end
      end

    end

    # Options:
    # * :tries - Number of retries to perform. Defaults to 1.
    # * :on - The Exception on which a retry will be performed. Defaults to Exception, which retries on any Exception.
    #
    # Example
    # =======
    #   retryable(:tries => 1, :on => OpenURI::HTTPError) do
    #     # your code here
    #   end
    #    
    def retryable(options = {}, &block)
      opts = { :tries => 2, :on => Exception }.merge(options)

      retry_exception, retries = opts[:on], opts[:tries]

      begin
        return yield
      rescue retry_exception
        retry if (retries -= 1) > 0
      end

      yield
    end

    def export
      File.open('ny_nail.txt', 'w'){|f| NailSalon.all.each{|n| f.puts "#{n.title}|#{n.address}|#{n.phone_num}|#{n.region}|#{n.state}|#{n.zip}|#{n.url}|#{n.category}"}}
    end

  end
end
