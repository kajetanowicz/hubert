#Hubert: simple tool for building HTTP URIs
Hubert makes it easy to generate URLs using simple template strings. Building
http API clients usually requires some way composing different URLs. This task
is easy if the API provides only a few endpoints but it becomes more cumbersome
as the number of available endpoints increases. Clients need to specify correct
protocols, ports, escape any dynamic values inserted into URI segments and query
strings.  This gem is attempting to address this problem by providing a simple DSL
for defining methods that will return desired URLs or paths.

## Example usage:
```ruby
require 'hubert'

class MyAwesomeApiClient

  # to make this work you need to extend your class with DSL module
  extend Hubert::DSL
  
  # all URLs will use https protocol (http is the default)
  https!
  
  # specifying hostname is required (unless you only want to generate paths)
  host 'api.example.com'
  
  # any path can be optionally prefixed - this can be usefull
  # if for example your code uses specific API version or
  # hits some specific group of endpoints (/users/... etc.) 
  path_prefix '/v1'
  
  # this will allow to call user_url(id: 123) in your class
  url '/users/:id', as: user
  
  # this is a simplified version of the one above
  # you can use it by calling user_path(id: 123) 
  path '/users/:id', as: user

  def print_user_url
    puts user_url(id: 123)
  end
  # => 'https://api.example.com/v1/users/123'

  def print_user_path
    puts user_path(id: 123)
  end
  # => '/v1/users/123'
  
  # any additional key - value pairs will become a part of the query string
  # all values will be escaped using CGI.escape
  def print_user_url_with_additional_ke_value_pairs
     puts user_url(id: 123, format: 'very pretty', include_description: true)
  end
  # => 'https://api.example.com/v1/users/123?format=very+pretty&include_description=true'
    
end

```

More examples can be found in spec files.

## Contributing
1. Fork it
2. Create your feature branch (git checkout -b feature/my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin feature/my-new-feature)
5. Create new Pull Request`
