class Role < ApplicationRecord
    has_many :member_roles, dependent: :destroy
    has_many :members, through: :member_roles
    belongs_to :team

    # Adicionar flag que identifica se o cargo é de um 'leader'
    # Dica: Criar migration para adicionar atributo 'leader' do tipo 'boolean' 

    include SoftDeletable
    
    validates :name, presence: true
    validates :team, presence: true
    
end
