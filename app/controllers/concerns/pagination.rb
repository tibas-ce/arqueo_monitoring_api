module Pagination
  extend ActiveSupport::Concern

  # Limite máximo permitido por página (protege o banco)
  MAX_LIMIT = 10
  # Limite padrão quando nenhum valor é informado ou é inválido
  DEFAULT_LIMIT = 10

  def paginate(scope)
    # Garante que a página seja sempre >= 1
    page = params[:page].to_i
    page = 1 if page <= 0

    # Define o limite respeitando regras de segurança
    limit = params[:limit].to_i
    limit = DEFAULT_LIMIT if limit <= 0
    limit = MAX_LIMIT if limit > MAX_LIMIT

    # Ordenação obrigatória para garantir consistência entre páginas
    scope = scope.order(:id)

    # Cálculo do offset baseado na página atual
    offset = (page - 1) * limit
    # Aplica paginação na query
    records = scope.limit(limit).offset(offset)

    # Total de registros (usado para metadata)
    total_count = scope.count

    # Estrutura de metadados para o frontend
    metadata = {
      current_page: page,
      limit: limit,
      total_pages: (total_count.to_f / limit).ceil,
      total_count: total_count
    }

    # Retorna registros + metadados
    [ records, metadata ]
  end
end
