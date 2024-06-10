require 'telegram/bot'
require File.dirname(__FILE__) + '/../app/routes'
require 'semantic_logger'

class Api
  attr_reader :id_usuario
  def initialize
    @url = ENV['API_URL']
    @id_usuario = 123
  end

  def consultar_menu
    response = Faraday.get("#{@url}/menu")
    devolver_campo_json(response, 'menu')
  end

  def registrar_usuario(nombre, direccion, telefono, id_usuario)
    body = { 'nombre' => nombre,
             'direccion' => direccion,
             'telefono' => telefono,
             'id_usuario' => id_usuario }.to_json

    response = Faraday.post("#{@url}/users", body)
    devolver_campo_json(response, 'respuesta')
  end

  def pedir(usuario, menu, id_usuario)
    body = { 'usuario' => usuario,
             'menu' => menu,
             'id_usuario' => id_usuario }.to_json

    response = Faraday.post("#{@url}/pedidos_de_usuario", body)
    devolver_campo_json(response, 'respuesta')
  end

  def pedir_estado(id, id_usuario)
    response = Faraday.get("#{@url}/pedidos" + "/#{id_usuario}/#{id}")
    devolver_campo_json(response, 'respuesta')
  end

  def cancelar_pedido(id)
    response = Faraday.put("#{@url}/cancelar_pedido" + "/#{id}")
    devolver_campo_json(response, 'respuesta')
  end

  def calificar_pedido(id_pedido, puntaje)
    body = { 'id_pedido' => id_pedido,
             'puntaje' => puntaje }.to_json
    response = Faraday.put("#{@url}/calificar_pedido", body)
    devolver_campo_json(response, 'respuesta')
  end

  def devolver_campo_json(response, campo)
    parsed_response = JSON.parse(response.body)
    parsed_response[campo]
  end
end
