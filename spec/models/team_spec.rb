require "rails_helper"

RSpec.describe Team, type: :model do
    subject(:team) {create(:team)}

    describe "Validations" do 
        it "is valid with valid attributes" do
            expect(team).to be_valid
        end

        it "is not valid if the name has already been taken" do 
            team
            new_team = build(:team, initials: nil)
            expect(new_team).to_not be_valid 
        end

        it "is not valid if the initials have already been taken" do 
            team 
            new_team = build(:team, name: "Núcleo de Atendimento e Vendas")
            expect(new_team).to_not be_valid 
        end

        it 'is not valid without a name' do
            team.name = nil
            expect(team).to_not be_valid 
        end 
    end
end