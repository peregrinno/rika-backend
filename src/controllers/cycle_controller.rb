require_relative 'base_controller'
require_relative '../contracts/cycle_contract'

class CycleController < BaseController
  def create
    user = authenticate!
    puts "\n=== Controller Debug ==="
    puts "User: #{user.inspect}"
    puts "Payload: #{@request_payload.inspect}"
    
    data = validate_with(Contracts::CycleContract)
    return data if data.is_a?(String)
    
    cycle = Cycle.new(
      id_user: user.id,
      cycle_number: data[:cycle_number],
      first_day: data[:first_day],
      date: data[:date],
      day_of_cycle: data[:day_of_cycle],
      symbol: data[:symbol],
      r: data[:r],
      feeling: data[:feeling],
      observation: data[:observation],
      notes: data[:notes]
    )

    if cycle.save
      ResponseData.success(cycle, 201)
    else
      ResponseData.error(cycle.errors, 400)
    end
  rescue Sequel::Error => e
    ResponseData.error("Erro ao salvar no banco: #{e.message}", 500)
  end

  def now_list
    user = authenticate!
    current_cycle = Cycle.where(id_user: user.id)
                        .order(Sequel.desc(:cycle_number))
                        .first
    
    return ResponseData.error('Nenhum ciclo encontrado', 404) unless current_cycle

    cycles = Cycle.where(
      id_user: user.id,
      cycle_number: current_cycle.cycle_number
    ).order(Sequel.asc(:date))

    ResponseData.success(cycles)
  end

  def list
    user = authenticate!
    cycles = Cycle.where(id_user: user.id)
                 .order(Sequel.desc(:cycle_number), Sequel.asc(:date))
    
    ResponseData.success(cycles)
  end

  def update
    user = authenticate!
    data = validate_with(Contracts::CycleUpdateContract)
    
    cycle = Cycle[data[:id]]
    return ResponseData.error('Ciclo não encontrado', 404) unless cycle
    return ResponseData.error('Acesso negado', 403) unless cycle.id_user == user.id

    if cycle.update(data.except(:id))
      ResponseData.success(cycle)
    else
      ResponseData.error(cycle.errors, 400)
    end
  rescue Sequel::Error => e
    ResponseData.error("Erro ao atualizar: #{e.message}", 500)
  end

  def day_cycle_current
    user = authenticate!
    
    # Busca o último ciclo do usuário
    last_cycle = Cycle.where(id_user: user.id)
                     .order(Sequel.desc(:cycle_number))
                     .first
    
    return ResponseData.error('Nenhum ciclo encontrado', 404) unless last_cycle

    # Busca o último registro deste ciclo
    last_record = Cycle.where(id_user: user.id, cycle_number: last_cycle.cycle_number)
                      .order(Sequel.desc(:date))
                      .first

    return ResponseData.error('Registro não encontrado', 404) unless last_record
    
    # Calcula o dia atual do ciclo
    current_day = last_record.day_of_cycle + 1

    ResponseData.success({ dayCycleCurrent: current_day })
  rescue Date::Error
    ResponseData.error('Erro ao calcular data', 500)
  rescue => e
    ResponseData.error("Erro inesperado: #{e.message}", 500)
  end
end 