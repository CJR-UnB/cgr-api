describe AuthenticationManager::AuthenticateUser do
    subject(:context) { described_class.call(email, password) }
    let!(:user) {create(user)}
  
    describe '.call' do
        context 'when the context is successful' do
            let(:email) { user.email }
            let(:password) { user.password }
            
            it 'succeeds' do
                expect(context.success?).to be_success
            end
        end
    
        context 'when the context is not successful' do
            let(:email) { 'user@yahoo.com' }
            let(:password) { user.password }
    
            it 'fails' do
                expect(context.success?).to be_failure
            end
        end
    end
end