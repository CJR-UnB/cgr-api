require "rails_helper"

RSpec.describe "TeamsController", :type => :request do

    let!(:nut) { Team.create!({ :name => "Núcleo de Talentos", 
                                :initials => "NUT"})}

    it "creates a Team" do
        headers = { "ACCEPT" => "application/json" }
        team = { :name => "Núcleo de Organização Empresarial", 
                 :initials => "NOE" }
        post "/teams", :params => { :team => team }, :headers => headers

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:created)
    end

    it "shows all Teams information" do 
        get "/teams"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
    end 

    it "shows a Team information" do 
        get "/teams/#{nut.id}"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
    end 

    it "updates a Team" do
        headers = { "ACCEPT" => "application/json" }
        put "/teams/#{nut.id}", :params => { :team => {:name => "Fã clube da Larissa"} }, :headers => headers

        expect(response.content_type).to eq("application/json")
        expect(controller.params[:team][:name]).to eq("Fã clube da Larissa")
        expect(response).to have_http_status(:ok)
    end

    it "deletes a team" do 
        delete "/teams/#{nut.id}"

        expect(response).to have_http_status(:no_content)
    end 
end