require "rails_helper"

RSpec.describe "TeamsController", :type => :request do

    let!(:nut) { Team.create!({ :name => "Núcleo de Talentos", 
                                :initials => "NUT"})}

    it "creates a Team" do
        headers = { "ACCEPT" => "application/json" }
        team = { :name => "Núcleo de Organização Empresarial", 
                 :initials => "NOE" }
        post "/teams", :params => { :team => team }, :headers => headers

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:created)
    end

    it "creates a Team with a role" do 
        headers = { "ACCEPT" => "application/json" }
        team = { :name => "Núcleo de Organização Empresarial", 
                 :initials => "NOE" }
        role = { :name => "Assessor de Organização Empresarial"}
        post "/teams", :params => { :team => team, :roles => [ role ] }, :headers => headers

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:created)
    end


    it "shows all Teams information" do 
        get "/teams"

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:ok)
    end 

    it "shows a Team information" do 
        get "/teams/#{nut.id}"

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:ok)
    end 

    it "updates a Team" do
        headers = { "ACCEPT" => "application/json" }
        put "/teams/#{nut.id}", :params => { :team => {:name => "Fã clube da Larissa"} }, :headers => headers
        body = JSON.parse(response.body)

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:ok)
        expect(body['name']).to eq("Fã clube da Larissa")
        
    end

    it "deletes a team" do 
        headers = { "ACCEPT" => "application/json" }
        delete "/teams/#{nut.id}", :headers => headers
        body = JSON.parse(response.body)

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:ok)
        expect(body['deleted_at']).to_not eq(nil)
    end 
end