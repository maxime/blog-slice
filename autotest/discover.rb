Autotest.add_discovery do
  "rspec" if File.directory?('spec')
end
