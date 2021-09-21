require "rails_helper"

RSpec.describe "MembersController", :type => :request do

    before(:all) { 
        @members_path = "/members"
        @role = create(:role)
        @team = @role.team
    }

    after(:all){
        @role.hard_destroy
        @team.hard_destroy
    }

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
        before(:all){
            @previous_count = Member.count 
            @headers = { "ACCEPT" => "application/json" }
            @new_member = { :name => "Valentin Ferreira Paes" }
        }

        context "without a role" do 
            before(:context) do
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
                
                it "returns a member with their matching the name given" do
                    expect(@body['name']).to eq(@new_member[:name])
                end

                it "creates a new member" do
                    expect(Member.count).to eq(@previous_count + 1)
                end
            end
        end

        context "with a role" do 
            context "the role is valid" do
                before(:context) do
                    post @members_path, :params => { :member => @new_member, :join_roles => [@role.id] }, :headers => @headers
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
                    
                    it "returns a member with their name matching the name given" do
                        expect(@body['name']).to eq(@new_member[:name])
                    end

                    it "returns a member with a role matching the role given" do 
                        expect(@body['roles'].last['id']).to eq(@role.id)
                    end
    
                    it "creates a new Member" do
                        expect(Member.count).to eq(@previous_count + 1)
                    end
                end
            end 

            context "the role is not valid" do 
            end
        end
    end

    context "existing member actions" do 
        before(:context) do 
            @member = create(:member, roles: [@role])
            @member_path = @members_path + "/#{@member.id}"
        end

        after(:context) do
            @member.hard_destroy
        end 

        # GET /members/:id
        describe "#show" do 
            before(:context) do 
                get (@member_path)
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

        # PATCH/PUT /members/:id
        describe "#update" do
            describe "errors" do 
                context "trying to update without permission" do 
                    # "permission" = Current user is NEITHER an admin OR current member's user 
                    before(:context) do
                        @new_member = {name: "Natália"}
                        put @member_path, :params => {member: @new_member}
                        @body = JSON.parse(response.body)
                    end 

                    describe "response" do
                        it "returns a JSON" do
                            expect(response.content_type).to match(/application\/json/)
                        end 

                        it "returns a HTTP status 401 (Unauthorized)" do 
                            expect(response).to have_http_status(:unauthorized)
                        end 

                        it "returns a member with their name not matching the name given" do 
                            expect(@body['name']).to_not eq(@new_member[:name])
                        end
                    end
                end 

                context "trying to update without valid params" do 
                    before(:context) do
                        token = login_admin
                        @new_member = {name: nil}
                        put @member_path, :params => {member: @new_member}, :headers => {"Authorization" => token}
                        @body = JSON.parse(response.body)
                    end 

                    describe "response" do
                        it "returns a JSON" do
                            expect(response.content_type).to match(/application\/json/)
                        end 

                        it "returns a HTTP status 422 (Unprocessable Entity)" do 
                            expect(response).to have_http_status(:unprocessable_entity)
                        end 

                        it "returns a member with their name not matching the name given" do 
                            expect(@body['name']).to_not eq(@new_member[:name])
                        end
                    end
                end

                context "trying to update a member that it not accessible (soft delete / does not exist)" do 
                    describe "response" do
                        it "returns a JSON (?)" #verificar o que retorna nesse caso
                        it "returns a HTTP status 404 (Not Found)"
                    end 
                end
            end 

            context "add a single role" do
                before(:context) do
                    token = login_admin
                    @new_role = create(:role, team: create(:team, name: "Equipe CGR"), name: "Dev")
                    put @member_path, :params => {:join_roles => [@new_role.id]}, :headers => {"Authorization" => token}
                    @body = JSON.parse(response.body)
                end

                after(:context) do 
                    team = @new_role.team  
                    @new_role.hard_destroy
                    team.hard_destroy
                end 

                describe "response" do 
                    it "returns a JSON" do 
                        expect(response.content_type).to match(/application\/json/)
                    end
    
                    it "returns a HTTP status 200 (OK)" do 
                        expect(response).to have_http_status(:ok)
                    end 

                    it "returns a member with their name matching the given member's name" do
                        expect(@body['name']).to eq(@member[:name])
                    end

                    it "returns a member with a role matching the role given" do 
                        expect(@body['roles'].last['id']).to eq(@new_role.id)
                    end
                end  
            end 
            
            context "remove a single role" do 
                before(:context) do
                    token = login_admin
                    put @member_path, :params => { :leave_roles => [@role.id]}, :headers => {"Authorization" => token}
                    @body = JSON.parse(response.body)
                end 

                describe "response" do
                    it "returns a JSON" do
                        expect(response.content_type).to match(/application\/json/)
                    end

                    it "returns a HTTP status 200 (OK)" do
                        expect(response).to have_http_status(:ok)
                    end 

                    it "returns a member with their name matching the given member's name'" do
                        expect(@body['name']).to eq(@member[:name])
                    end 

                    it "returns a member without a role matching the role given" do
                        expect(@body['roles'].pluck("id")).to_not include(@role.id)
                    end 
                end
            end

            context "change attributes" do 
                describe "response" do 
                    it "returns a JSON"
                    it "returns a HTTP status 200 (OK)"
                    it "returns a member with their name matching the name given"
                end
            end 
        end

        describe "#delete" do
            describe "errors" do
                context "trying to delete without permission" do
                end

                context "trying to soft delete a member that it not accessible (soft delete / does not exist)" do 
                    describe "response" do
                        it "returns a JSON (?)" #verificar o que retorna nesse caso
                        it "returns a HTTP status 404 (Not Found)"
                    end 
                end

                context "trying to hard delete without beeing logged in as an admin" do
                    it "returns a JSON (?)" #verificar o que retorna nesse caso 
                    it "returns a HTTP status 401 (Unauthorized)"
                end
            end 
            context "soft delete" do 
                describe "response" do
                    it "returns a JSON (?)" #verificar o que retorna nesse caso 
                    it "returns a HTTP status 200 (OK)"
                    it "fills the member's field 'deleted_at'" #verificar se o campo deleted_at não está nulo
                end 
            end
            context "hard delete" do 
                describe "response" do
                    it "returns a JSON (?)" #verificar o que retorna nesse caso 
                    it "returns a HTTP status 200 (OK)"
                    it "removes the member from the database" #verificar se o membro foi removido do banco
                end 
            end
        end 
    end 
end

def login_admin
    post '/authenticate', :params => {email: "admin@admin.com", password: "popao123"}
    body = JSON.parse(response.body)
    body["auth_token"]
end