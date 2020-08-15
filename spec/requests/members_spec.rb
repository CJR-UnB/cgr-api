require "rails_helper"

RSpec.describe "MembersController", :type => :request do

    let!(:larissa) { Member.create!({:name => "Larissa Santana de Freitas Andrade"})}

    it "creates a Member" do
        headers = { "ACCEPT" => "application/json" }
        member = { :name => "Valentin Ferreira Paes" }
        post "/members", :params => { :member => member }, :headers => headers
        body = JSON.parse(response.body)
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:created)
        expect(body['name']).to eq(member[:name])
    end

    it "shows all Members information" do 
        get "/members"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
    end 

    it "shows a Member information" do 
        get "/members/#{larissa.id}"
        body = JSON.parse(response.body)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['name']).to eq(larissa.name)
    end 

    it "updates a Member info" do
        headers = { "ACCEPT" => "application/json" }
        put "/members/#{larissa.id}", :params => { :member => {:name => "Larissinha lindinha"} }, :headers => headers
        body = JSON.parse(response.body)
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['name']).to eq("Larissinha lindinha")
    end

    it "deletes a Member" do
        headers = { "ACCEPT" => "application/json" }
        delete "/members/#{larissa.id}", :headers => headers
        body = JSON.parse(response.body)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['deleted_at']).to_not eq(nil)
    end 
end