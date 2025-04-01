require 'dotenv'
require './itamae/spec/helper/spec_helper'
Dotenv.load

hostname = node[:hostname][:name]

describe file('/etc/hostname') do
  its(:content) { should match /#{hostname}/ }
end
