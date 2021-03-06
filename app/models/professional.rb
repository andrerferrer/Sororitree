class Professional < ApplicationRecord
  belongs_to :user
  validates :job_category, presence: true
  validates :user, uniqueness: true

  CATEGORIES = ["Médica - outros", "Enfermeira", "Psicóloga", "Psiquiatra", "Assistente Social", "Ginecologista", "Doula", "Advogada", "Policial", "Nutricionista", "Coach" ]
end
