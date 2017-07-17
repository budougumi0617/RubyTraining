class Staff::TopController < ApplicationController
    def index
        raise IpAddressRejected
        render action: 'index'
    end
end
