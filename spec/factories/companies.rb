FactoryBot.define do
  factory :company do
    name { "ArqueoCacos Ltda" }
    cnpj { "12.345.678/0001-99" }
    email { "contato@arqueocacos.com" }
    phone { "(88) 98599-1213" }
  end
end
