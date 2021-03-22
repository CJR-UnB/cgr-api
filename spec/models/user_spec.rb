require 'rails_helper'

RSpec.describe User, type: :model do
	let!(:user) { create(:user) } 

	describe "Validations" do 
		it "is valid with valid attributes" do 
			expect(user).to be_valid
		end

		it "is not valid if the name is blank" do
			new_user = build(:user, email: "popao@gmail.com", name: nil)
			expect(new_user).to_not be_valid
		end

		it "is not valid if the email has already been taken" do 
			new_user = build(:user, name: "Valentin Ferreira Paes")
			expect(new_user).to_not be_valid
		end

		it "is not valid if the email is blank" do 
			new_user = build(:user, name: "Valentin Ferreira Paes", email: nil)
			expect(new_user).to_not be_valid
		end 

		it "is not valid if the password and the password confirmation don't match" do 
			new_user = build(:user, name: "Valentin Ferreira Paes", email: "popao@gmail.com", password: "123")
			expect(new_user).to_not be_valid
		end

		it "is not valid if the password is blank" do
			new_user = build(:user, name: "Valentin Ferreira Paes", email: "popao@gmail.com", password: nil)
			expect(new_user).to_not be_valid
		end
	end
end
