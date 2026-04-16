module ValidationHelpers
  # Testa se o model é inválido quando um atributo e nulo
  def expect_invalid_without(factory_name, attribute)
    model = build(factory_name, attribute => nil)
    expect(model).not_to be_valid
    expect(model.errors[attribute]).to be_present
  end

  # Testa se o model é válido com os atributos da factory
  def expect_valid_factory(factory_name)
    expect(build(factory_name)).to be_valid
  end
end
