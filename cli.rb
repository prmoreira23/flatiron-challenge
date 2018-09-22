require 'httparty'

# This function handles requests to API, and can return a empty hash if the user
# does not exists, a hash filled with the user information if the user was found,
# and nil if there is an exception (i.e. network issues).
def get_user_info(username)
  api_url = "https://api.github.com/users/#{username}"
  begin
    # HTTPParty used to make a GET request to the API endpoint
    response = HTTParty.get(api_url)
    case response.response.code
      when "200"
        response.parsed_response
      when "404"
        {}
    end
  rescue => err
    puts err
    nil
  end
end

# This function expects a Hash with all information from a given user, an then
# it prints some basic information about that user
def print_user(user)
  puts "Name: #{user['name']}"
  puts "E-mail: #{user['email']}"
  puts "Company: #{user['company']}"
  puts "Number of public repos: #{user['public_repos']}"
end

# This is the app loop. App will keep running until user types 0
while true
  print "Type a GitHub username (0 - exit): "
  username = gets.chomp

  break if username == "0"

  user = get_user_info(username)

  if user
    if user.empty?
      puts "User not found!"
    else
      print_user(user)
    end
  else
    puts "ERROR!"
  end
end
