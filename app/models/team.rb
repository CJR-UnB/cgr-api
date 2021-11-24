class Team < ApplicationRecord
    has_many :members, through: :roles
    has_many :roles, dependent: :destroy
    
    belongs_to :parent, class_name: 'Team', optional: true
    has_many :children, class_name: 'Team', foreign_key: 'parent_id'
    belongs_to :project , optional: true
    include SoftDeletable
    
    validates :name, uniqueness: true, presence: true
    
    def members
        members = []
        self.roles.all.each do |role|
          members = members + role.members.all
        end
        members
    end
    # Validar se apenas um cargo (ou nenhum) tem a flag de 'leader'
    # Dica: Usar método 'validate' como:
    #
    # validate :has_a_single_leader
    #
    # private
    #
    # def has_a single_leader
    #   errors.add(:roles, 'Não pode ter mais de um líder') unless # Seu código aqui
    # end

end
