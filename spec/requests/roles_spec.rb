require "rails_helper"

RSpec.describe "RoleController", :type => :request do

    let(:nut) { create(:team)}
    let(:consultor) { create(:role, team: nut)}

    it "creates a Role" do
        headers = { "ACCEPT" => "application/json" }
        role = { :name => "Assessor", 
                 :team_id => nut.id }
        post "/teams/#{nut.id}/roles", :params => { :role => role }, :headers => headers

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:created)
    end

    it "shows all Roles information" do 
        get "/teams/#{nut.id}/roles"

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:ok)
    end 

    it "shows a Role information" do 
        get "/roles/#{consultor.id}"

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:ok)
    end 

    it "updates a Role" do
        headers = { "ACCEPT" => "application/json" }
        put "/roles/#{consultor.id}", :params => { :role => {:name => "Assessor" }}, :headers => headers
        body = JSON.parse(response.body)

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:ok)
        expect(body['name']).to eq("Assessor")
        expect(body['team_id']).to eq(nut.id)
    
    end

    it "deletes a role" do 
        headers = { "ACCEPT" => "application/json" }
        delete "/roles/#{consultor.id}", :headers => headers
        body = JSON.parse(response.body)

        expect(response.content_type).to match(/application\/json/)
        expect(response).to have_http_status(:ok)
        expect(body['deleted_at']).to_not eq(nil)
    end 
end