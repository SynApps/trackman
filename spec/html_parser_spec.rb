require 'spec_helper'
describe Trackman::Urls::HtmlParser do  
  before :all do
    @parser = Object.new
    @parser.extend  Trackman::Urls::HtmlParser
  end

  it "contains unique paths" do
    html = "
      <html>
        <head></head>
        <body>
          <img  src='/assets/trackman70x70.png' alt='Trackman logo' />
          <img  src='/assets/trackman70x70.png' alt='Trackman logo' />
        </body>
      </html>"

    @parser.parse(html).should == ['/assets/trackman70x70.png']
  end  
end
