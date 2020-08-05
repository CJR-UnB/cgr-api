require "rails_helper"

RSpec.describe "MembersController", :type => :request do

    let!(:larissa) { Member.create!({:name => "Larissa Santana de Freitas Andrade", 
                                     :entry_date => "01/02/2019"})}

    it "creates a Member" do
        headers = { "ACCEPT" => "application/json" }
        member = { :name => "Valentin Ferreira Paes", 
                   :entry_date => "01/02/2019" }
        post "/members", :params => { :member => member }, :headers => headers

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:created)
    end

    it "shows all Members information" do 
        get "/members"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
    end 

    it "shows a Member information" do 
        get "/members/#{larissa.id}"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
    end 

    it "updates a Member" do
        headers = { "ACCEPT" => "application/json" }
        put "/members/#{larissa.id}", :params => { :member => {:leaving_date => "07/20/2020"} }, :headers => headers

        expect(response.content_type).to eq("application/json")
        expect(controller.params[:member][:leaving_date]).to eq("07/20/2020")
        expect(response).to have_http_status(:ok)
    end

    it "deletes a Member" do 
        delete "/members/#{larissa.id}"

        expect(response).to have_http_status(:no_content)
    end 
end