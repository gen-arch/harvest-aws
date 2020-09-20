require "aws-sdk"
require "harvest/aws/version"

module Harvest

  def self.aws(**opts)
    ::Aws.config.update(opts)
  end

  module Aws
    class << self
      def instance_souces(query='.*', **opts)
        ec2 = ::Aws::EC2::Resource.new

        ec2.instances.map do |i|
          host = i.tags.find{|h| h.key == 'Name' }.value
          next unless host =~ /#{query}/
          next unless i.state.name == "running"

          addr_type = opts[:address_type] || :public
          type      = opts[:type] || :linux

          {
            type:         type,
            name:         host,
            host_name:    i.send("#{addr_type}_ip_address".to_sym),
            instance_id:  i.instance_id,
            aws:          i
          }
        end
      end

    end
  end
end
