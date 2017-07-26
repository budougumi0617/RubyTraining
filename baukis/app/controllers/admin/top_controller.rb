class Admin::TopController < Admin::Base
    def index
        raise IpAddressRejected
        render action: 'index'
    end
end
