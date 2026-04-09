FactoryBot.define do
  factory :monitoring_sheet do
    monitoring_date { Date.today }
    activity { "Exploração de jazida" }
    stake_interval { "020+310 a 020+380" }
    lot { "03" }
    start_x { "458046.0" }
    start_y { "9198147.0" }
    end_x { "458037.0" }
    end_y { "9198130.0" }
    work_status { "Fase Intermediária" }
    occurrence_evaluation { "Sem ocorrência arqueológica" }
    coordinate_system { "UTM-SIRGA200-ZONA24S" }
    association :project
  end
end
