require 'sinatra'
require "sinatra/reloader" if development?
require 'active_record'
require 'pry'

configure :development, :production do
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database =>  'db/dev.sqlite3.db'
  )
end

# Quick and dirty form for testing application
#
# If building a real application you should probably
# use views:
# http://www.sinatrarb.com/intro#Views%20/%20Templates
form = <<-eos
  <form id='myForm'>
    <input type='text' name="url" autofocus>
    <input type="submit" value="Shorten">
  </form>
  <h2>Results:</h2>
  <h3 id="display"></h3>
  <script src="jquery.js"></script>

  <script type="text/javascript">
    $(function() {
      $('#myForm').submit(function() {
        $.post('/new', $("#myForm").serialize(), function(data){
          $('#display').append(data);
        });
        return false;
      });
    });
  </script>
eos

# Models to Access the database
# through ActiveRecord.  Define
# associations here if need be
#
# http://guides.rubyonrails.org/association_basics.html
class Link < ActiveRecord::Base

end

get '/' do
  form
end

get '/jquery.js' do
  send_file 'jquery.js'
end

get '/:id' do
  id = params[:id]
  if Link.exists?(id)
    link = Link.find(id)
    redirect "http://#{link.url}"
  else
    not_found do
      halt 404, 'page not found'
    end
  end
end


post '/new' do
  # Link.new.links.build({:url => params[:url]})
  link = Link.where(
    {
      :url => params[:url]
    }
  ).first_or_create

  "localhost:4567/#{link.id}"
  # return "<a href='#{link.id}' target='_blank' >ID: #{link.id}, Website: #{link.url}</a><br />"
  # PUT CODE HERE TO CREATE NEW SHORTENED LINKS
end



####################################################
####  Implement Routes to make the specs pass ######
####################################################
