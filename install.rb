#!/usr/bin/env ruby

# Inspired by http://errtheblog.com/posts/89-huba-huba

# This is idempotent, meaning you can run it over and over again without fear of
# breaking anything. Use it as an installer or to upgrade after merging from an
# upstream fork.

home = File.expand_path('~/')

Dir['.*'].each do |file|
  next if file == ".git" || file == ".." || file == "."
  target = File.join(home, "#{file}")
  `ln -nsf #{File.expand_path file} #{target}`
end
`mkdir -p #{home}/bin`
Dir['bin/*'].each do |file|
  target = File.join(home, "#{file}")
  `ln -nsf #{File.expand_path file} #{target}`
end
