FactoryBot.define do
  factory :project do
    name { "Projeto de Monitoramento CE-060" }
    description { "Monitoramento arqueológico da rodovia CE-060" }
    ordinance_number { "001/2026" }
    municipality { "Crato" }
    association :company
  end
end
