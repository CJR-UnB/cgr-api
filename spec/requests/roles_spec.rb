require "rails_helper"

RSpec.describe "RoleController", :type => :request do

    let!(:consultor) { Role.create!({ :name => "Consultor" })}

    it "creates a Role" do
        headers = { "ACCEPT" => "application/json" }
        role = { :name => "Assessor" }
        post "/roles", :params => { :role => role }, :headers => headers

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:created)
    end

    it "shows all Roles information" do 
        get "/roles"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
    end 

    it "shows a Role information" do 
        get "/roles/#{consultor.id}"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
    end 

    it "updates a Team" do
        headers = { "ACCEPT" => "application/json" }
        put "/roles/#{consultor.id}", :params => { :role => {:name => "Assessor" }}, :headers => headers

        expect(response.content_type).to eq("application/json")
        expect(controller.params[:role][:name]).to eq("Assessor")
        expect(response).to have_http_status(:ok)
        
    end

    it "deletes a team" do 
        delete "/roles/#{consultor.id}"

        expect(response).to have_http_status(:no_content)
    end 
end