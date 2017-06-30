require 'rails_helper'

describe String do
    describe '#<<' do
        example 'Add char' do
            s = "ABC"
            s << "D"
            expect(s.size).to eq(4)
        end
    end
end
