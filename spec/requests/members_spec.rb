require "rails_helper"

RSpec.describe "MembersController", :type => :request do

    before(:all) { @members_path = "/members"}

    # GET /members
    describe "#index" do
        before(:context) do 
            get @members_path 
        end 
        
        describe "response" do 
            it "returns a JSON" do 
                expect(response.content_type).to match(/application\/json/)
            end 

            it "returns HTTP status 200 (OK)" do 
                expect(response).to have_http_status(:ok)
            end
        end 
    end 

    # POST /members 
    describe "#create" do 
        before(:context) do
            @headers = { "ACCEPT" => "application/json" }
            @new_member = { :name => "Valentin Ferreira Paes" }
            post @members_path, :params => { :member => @new_member }, :headers => @headers
            @body = JSON.parse(response.body)
        end

        after(:context) do
            Member.find_by(name: @new_member[:name]).destroy 
        end 

        describe "response" do
            it "returns a JSON" do
                expect(response.content_type).to match(/application\/json/)
            end 

            it "returns HTTP status 201 (Created)" do
                expect(response).to have_http_status(:created)
            end
            
            it "returns a Member matching the params given" do
                expect(@body['name']).to eq(@new_member[:name])
            end

            it "creates a new Member" do
                expect{ 
                    post @members_path, :params => { :member => { :name => "Dapedo"}}, :headers => @headers
                }.to change(Member, :count).by(1)
            end
        end
    end

    context "existing single Member actions" do 
        before(:context) do 
            @role = create(:role)
            @team = @role.team
            @member = create(:member, roles: [@role])
        end

        after(:context) do
            MemberRole.delete_all
            Role.delete_all
            Team.delete_all
            Member.delete_all
        end 

        # GET /members/:id
        describe "#show" do 
            before(:context) do 
                get (@members_path + "/#{@member.id}")
                @body = JSON.parse(response.body)
            end 

            describe "response" do
                it "returns a JSON" do 
                    expect(response.content_type).to match(/application\/json/)
                end

                it "returns a HTTP status 200 (OK)" do 
                    expect(response).to have_http_status(:ok)
                end 

                it "returns a JSON matching the member's attributes" do
                    expect(@body['name']).to eq(@member.name)
                end
            end 
        end
    end 

    # it "updates a Member info" do
    #     headers = { "ACCEPT" => "application/json" }
    #     put "/members/#{larissa.id}", :params => { :member => {:name => "Larissinha lindinha"} }, :headers => headers
    #     body = JSON.parse(response.body)
        
    #     expect(response.content_type).to match(/application\/json/)
    #     expect(response).to have_http_status(:ok)
    #     expect(body['name']).to eq("Larissinha lindinha")
    # end

    # it "makes a Member join a role" do 
    #     headers = { "ACCEPT" => "application/json" }
    #     new_role = Role.create!({:name => "Consultora de Atendimento e Vendas", :team => bope})
    #     put "/members/#{larissa.id}", :params => { :member => {:id => larissa.id}, :role_id => new_role.id}, :headers => headers
    #     body = JSON.parse(response.body)
        
    #     expect(response.content_type).to match(/application\/json/)
    #     expect(response).to have_http_status(:ok)
    #     expect(body['roles'][-1]['name']).to eq(new_role.name)
    # end

    # it "makes a Member leave a role" do 
    #     headers = { "ACCEPT" => "application/json" }
    #     put "/members/#{larissa.id}", :params => { :member => {:id => larissa.id}, :role_id => lider.id, :leave_role => true}, :headers => headers
    #     body = JSON.parse(response.body)
        
    #     expect(response.content_type).to match(/application\/json/)
    #     expect(response).to have_http_status(:ok)
    #     expect(body['roles'][-1]).to eq(nil)
    # end

    # it "deletes a Member" do
    #     headers = { "ACCEPT" => "application/json" }
    #     delete "/members/#{larissa.id}", :headers => headers
        
    #     expect(response).to have_http_status(:no_content)
    # end 
end