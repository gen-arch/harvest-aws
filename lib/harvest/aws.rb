require "aws-sdk"
require "harvest/aws/version"

module Harvest
  module Aws
    include ::Aws
    class << self
      def instance_souces
        ec2 = Aws::EC2::Resource.new

        ec2.instances.map do |i|
          {
            host: i.tags.find{|h| h.key == 'Name' }.value
          }
        end
      end
    end
  end
end
