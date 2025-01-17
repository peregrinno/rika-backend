module Contracts
  class CycleContract < Dry::Validation::Contract
    params do
      required(:cycle_number).value(:integer)
      required(:first_day).value(:string)
      required(:date).value(:string)
      required(:day_of_cycle).value(:integer)
      optional(:symbol).maybe(:string)
      optional(:r).maybe(:bool)
      optional(:feeling).maybe(:string)
      optional(:observation).maybe(:string)
      optional(:notes).maybe(:string)
    end

    rule(:cycle_number) do
      key.failure('deve ser maior que 0') if value && value <= 0
    end

    rule(:first_day) do
      key.failure('deve ser uma data válida') unless Date.iso8601(value) rescue false
    end

    rule(:date) do
      key.failure('deve ser uma data válida') unless Date.iso8601(value) rescue false
    end

    rule(:day_of_cycle) do
      key.failure('deve ser maior que 0') if value && value <= 0
    end
  end

  class CycleUpdateContract < CycleContract
    params do
      required(:id).filled(:integer)
    end
  end
end 