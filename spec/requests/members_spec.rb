require "rails_helper"

RSpec.describe "MembersController", :type => :request do

    let!(:bope) { Team.create!({:name => "Núcleo de Atendimento e Vendas", :initials => "NAV"}) }
    let!(:lider) { Role.create!({:name => "Líder de Atendimento e Vendas", :team => bope})}
    let!(:larissa) { Member.create!({:name => "Larissa Santana de Freitas Andrade", :roles=>[lider]})}

    it "creates a Member" do
        headers = { "ACCEPT" => "application/json" }
        member = { :name => "Valentin Ferreira Paes" }
        post "/members/1", :params => { :member => member }, :headers => headers
        body = JSON.parse(response.body)
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:created)
        expect(body['name']).to eq(member[:name])
    end

    it "shows all Members information" do 
        get "/members/1"

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
    end 

    it "shows a Member information" do 
        get "/members/1/#{larissa.id}"
        body = JSON.parse(response.body)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['name']).to eq(larissa.name)
    end 

    it "updates a Member info" do
        headers = { "ACCEPT" => "application/json" }
        put "/members/1/#{larissa.id}", :params => { :member => {:name => "Larissinha lindinha"} }, :headers => headers
        body = JSON.parse(response.body)
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['name']).to eq("Larissinha lindinha")
    end

    it "makes a Member join a role" do 
        headers = { "ACCEPT" => "application/json" }
        new_role = Role.create!({:name => "Consultora de Atendimento e Vendas", :team => bope})
        put "/members/1/#{larissa.id}", :params => { :member => {:id => larissa.id}, :role_id => new_role.id}, :headers => headers
        body = JSON.parse(response.body)
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['roles'][-1]['name']).to eq(new_role.name)
    end

    it "makes a Member leave a role" do 
        headers = { "ACCEPT" => "application/json" }
        put "/members/1/#{larissa.id}", :params => { :member => {:id => larissa.id}, :role_id => lider.id, :leave_role => true}, :headers => headers
        body = JSON.parse(response.body)
        
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['roles'][-1]).to eq(nil)
    end

    it "deletes a Member" do
        headers = { "ACCEPT" => "application/json" }
        delete "/members/1/#{larissa.id}", :headers => headers
        body = JSON.parse(response.body)

        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
        expect(body['deleted_at']).to_not eq(nil)
    end 
end