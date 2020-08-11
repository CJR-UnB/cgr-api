require "rails_helper"

RSpec.describe "MembersController", :type => :request do

    let!(:larissa) { Member.create!({:name => "Larissa Santana de Freitas Andrade", 
                                     :entry_date => "2019-02-01"})}

    it "creates a Member" do
        headers = { "ACCEPT" => "application/json" }
        member = { :name => "Valentin Ferreira Paes", 
                   :entry_date => "2019-02-01" }
        post "/members", :params => { :member => member }, :headers => headers
        body = JSON.parse(response.body)
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:created)
        expect(body['name']).to eq(member[:name])
        expect(body['entry_date']).to eq(member[:entry_date])
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
        expect(body['entry_date']).to eq(larissa.entry_date.to_s(:db))
    end 

    it "updates a Member" do
        headers = { "ACCEPT" => "application/json" }
        put "/members/#{larissa.id}", :params => { :member => {:leaving_date => "2020-07-20"} }, :headers => headers
        body = JSON.parse(response.body)
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['leaving_date']).to eq("2020-07-20")
    end

    it "deletes a Member" do 
        delete "/members/#{larissa.id}"

        expect(response).to have_http_status(:no_content)
    end 
end