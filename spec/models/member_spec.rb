require 'rails_helper'

RSpec.describe Member, type: :model do
    subject(:member) { create(:member)}

    describe "Validations" do
        it 'is valid with valid attributes' do 
            expect(member).to be_valid 
        end

        it 'is not valid if the name has already been taken' do 
            member
            new_member = build(:member)
            expect(new_member).to_not be_valid 
        end
    
        it 'is not valid without a name' do
            member.name = nil
            expect(member).to_not be_valid 
        end 
    end
end
