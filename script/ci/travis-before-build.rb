# Start virtual X frame buffer
system "sh -e /etc/init.d/xvfb start"

# Create a database.yml for the current database env
<<<<<<< HEAD
puts "Setting up database.yml for #{ENV["DB"]}"
system "cp config/database.yml.#{ENV["DB"]} config/database.yml"
=======
echo "Setting up database.yml for $DB"
cp config/database.yml.$DB config/database.yml
>>>>>>> df95966... Added support for multiple CI runs in mysql and sqlite.

# Generate and copy secret token initializer
secret = `bundle exec rake secret`.strip
path = File.join(File.dirname(__FILE__), '../../config/initializers/')
template = File.read(File.join(path, 'secret_token.rb.template'))

template.gsub!('S-E-C-R-E-T', secret)
File.open(File.join(path, 'secret_token.rb'), 'w') do |file|
  file.puts template
end