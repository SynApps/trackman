require 'spec_helper'

class TestSaver 
  include Trackman::Scaffold::ContentSaver

  def self.clean
    self.nodes_to_remove = {}
    self.nodes_to_edit = {}
  end
end
describe Trackman::Scaffold::ContentSaver do
  before :all do
    @saver = TestSaver.new
  end
  after :each do
    TestSaver.clean
  end

  it "removes the a with an abc href" do 
    TestSaver.remove('a'){ |n| n['href'].include? 'abc' }

    html = "
    <html>
      <head></head>
      <body>
        <a href='/hello'></a>
        <a href='/abc'></a>
        <a href='/world'></a>
      </body>
    </html>"

    doc = Nokogiri::HTML(html)
    @saver.send(:remove_nodes, doc)
    actual = doc.to_s

    actual.should_not include('abc')
    actual.should include('/hello')
    actual.should include('world')
  end

  it "removes the a with an abc href" do 
    TestSaver.remove 'a'
    TestSaver.remove '.bobby'

    html = "
    <html>
      <head></head>
      <body>
        <a href='/hello'></a>
        <a href='/abc'></a>
        <a href='/world'></a>

        <div class='bobby'></div>
        <div>
          <p>allo</p>
        </div>
      </body>
    </html>"

    doc = Nokogiri::HTML(html)
    @saver.send(:remove_nodes, doc)
    actual = doc.to_s

    actual.should_not include('<a href')
    actual.should_not include('bobby')
  end

  it "edits all the href" do
    TestSaver.edit('a'){ |e| e['href'] = 'bobby' }

    html = "
    <html>
      <head></head>
      <body>
        <a href='/hello'></a>
        <a href='/abc'></a>
        <a href='/world'></a>

        <div class='bobby'></div>
        <div>
          <p>allo</p>
        </div>
      </body>
    </html>"

    doc = Nokogiri::HTML(html)
    @saver.send(:edit_nodes, doc)
    actual = doc.to_s

    actual.should_not include('/hello')
    actual.should_not include('/abc')
    actual.should_not include('/world')
    actual.should include('bobby')
  end

  it "edits multiple things" do
    TestSaver.edit 'a' do |e|
      e['href'] = 'bobby' if e['href'] == '/abc'
    end

    TestSaver.edit '.bobby' do |e|
      e.content = '<span>Allo</span>'
    end

    html = "
    <html>
      <head></head>
      <body>
        <a href='/hello'></a>
        <a href='/abc'></a>
        <a href='/world'></a>

        <div class='bobby'></div>
        <div>
          <p>allo</p>
        </div>
      </body>
    </html>"

    doc = Nokogiri::HTML(html)
    @saver.send(:edit_nodes, doc)
    actual = doc.to_s

    actual.should_not include('/abc')
    actual.should include('bobby')
    actual.should include('span')
  end

  it "edits multiple things" do
    TestSaver.gsub 'wallo', 'bobby'

    TestSaver.gsub /ginette/, 'johnny'

    html = "
    <html>
      <head></head>
      <body>
        <a href='wallo'></a>
        <a href='ginette'></a>
        <a href='/world'></a>

        <div class='bobby'></div>
        <div>
          <p>allo</p>
        </div>
      </body>
    </html>"

    @saver.send(:gsub_html, html)

    html.should_not include('/abc')
    html.should include('bobby')
    html.should include('johnny')
  end
end
