require 'spec_helper'
require 'web_mock'

require "#{File.dirname(__FILE__)}/../app/bot_client"

# API_TEST_URL = 'https://webapi-bobe-test.herokuapp.com'
FAKE_TOKEN = 'fake_token'.freeze

def when_i_send_text(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                                                 "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def when_i_send_keyboard_updates(token, message_text, inline_selection)
  body = {
    "ok": true, "result": [{
      "update_id": 866_033_907,
      "callback_query": { "id": '608740940475689651', "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                          "message": {
                            "message_id": 626,
                            "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                            "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                            "date": 1_595_282_006,
                            "text": message_text,
                            "reply_markup": {
                              "inline_keyboard": [
                                [{ "text": 'Jon Snow', "callback_data": '1' }],
                                [{ "text": 'Daenerys Targaryen', "callback_data": '2' }],
                                [{ "text": 'Ned Stark', "callback_data": '3' }]
                              ]
                            }
                          },
                          "chat_instance": '2671782303129352872',
                          "data": inline_selection }
    }]
  }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def then_i_get_text(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def then_i_get_keyboard_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544',
              'reply_markup' => '{"inline_keyboard":[[{"text":"Jon Snow","callback_data":"1"}],[{"text":"Daenerys Targaryen","callback_data":"2"}],[{"text":"Ned Stark","callback_data":"3"}]]}',
              'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def stub_request_webapi(type, method, body, response)
  stub_request(type, "#{ENV['API_URL']}/#{method}")
    .with(
      body: body,
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Faraday v0.15.4'
      }
    )
    .to_return(status: 200, body: response, headers: {})
end

def stub_request_webapi_pedidos(usuario, menu, respuesta)
  body = { "usuario": usuario.to_s, "menu": menu.to_s, "id_usuario": 141733544 } # rubocop: disable Style/NumericLiterals
  response = { "respuesta": respuesta.to_s }
  stub_request_webapi(:post, 'pedidos_de_usuario', body.to_json, response.to_json)
end

describe 'BotClient' do
  it 'should get a /version message and respond with current version' do
    token = 'fake_token'

    when_i_send_text(token, '/version')
    then_i_get_text(token, Version.current)

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /start message and respond with Hola' do
    token = 'fake_token'

    when_i_send_text(token, '/start')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /stop message and respond with Chau' do
    token = 'fake_token'

    when_i_send_text(token, '/stop')
    then_i_get_text(token, 'Chau, egutter')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    token = 'fake_token'

    when_i_send_text(token, '/unknown')
    then_i_get_text(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'Al consultar los menus con /menu obtengo el mensaje: Individual 1000, Pareja 1500, Familiar 2500' do
    when_i_send_text(FAKE_TOKEN, '/menu')
    then_i_get_text(FAKE_TOKEN, 'Individual 1000, Pareja 1500, Familiar 2500')

    stub_request_webapi(:get, 'menu', nil, '{"menu":"Individual 1000, Pareja 1500, Familiar 2500"}')

    app = BotClient.new(FAKE_TOKEN)

    app.run_once
  end

  it 'Al registrar un usuario me devuelve "Bienvenido <nombre>"' do
    when_i_send_text(FAKE_TOKEN, '/registracion Ale, Acoyte 123, 1112345678')
    then_i_get_text(FAKE_TOKEN, 'Bienvenido Ale')

    stub_request_webapi(:post, 'users', { '{"nombre":"Ale","direccion":"Acoyte 123","telefono":"1112345678","id_usuario":141733544}' => nil }, '{"respuesta": "Bienvenido Ale"}')

    app = BotClient.new(FAKE_TOKEN)

    app.run_once
  end

  it 'Al realizar un pedido Individual me devuelve "Pedido exitoso del menu: Individual"' do
    respuesta = 'Pedido exitoso del menu: Individual. Tu numero de pedido es: 555'
    when_i_send_text(FAKE_TOKEN, '/pedir Individual')
    then_i_get_text(FAKE_TOKEN, respuesta)
    stub_request_webapi_pedidos('Ale', 'Individual', respuesta)
    BotClient.new(FAKE_TOKEN).run_once
  end

  it 'Al realizar un pedido Pareja me devuelve "Pedido exitoso del menu: Pareja"' do
    respuesta = 'Pedido exitoso del menu: Pareja. Tu numero de pedido es: 555'
    when_i_send_text(FAKE_TOKEN, '/pedir Pareja')
    then_i_get_text(FAKE_TOKEN, respuesta)
    stub_request_webapi_pedidos('Ale', 'Pareja', respuesta)
    BotClient.new(FAKE_TOKEN).run_once
  end

  it 'Al realizar un pedido Familiar me devuelve "Pedido exitoso del menu: Familiar"' do
    respuesta = 'Pedido exitoso del menu: Familiar. Tu numero de pedido es: 555'
    when_i_send_text(FAKE_TOKEN, '/pedir Familiar')
    then_i_get_text(FAKE_TOKEN, respuesta)
    stub_request_webapi_pedidos('Ale', 'Familiar', respuesta)
    BotClient.new(FAKE_TOKEN).run_once
  end

  it 'Al consultar el estado de un pedido devuelve "Recibido"' do
    when_i_send_text(FAKE_TOKEN, '/estado_pedido 1')
    then_i_get_text(FAKE_TOKEN, 'Recibido')

    stub_request_webapi(:get, 'pedidos/141733544/1', nil, '{"respuesta": "Recibido"}')

    app = BotClient.new(FAKE_TOKEN)
    app.run_once
  end

  it 'Al calificar un pedido recibido, me devuelve un mensaje de confirmacion' do
    when_i_send_text(FAKE_TOKEN, '/calificar_pedido 1 : 8')
    then_i_get_text(FAKE_TOKEN, 'Gracias por su calificacion')

    response = '{"respuesta":"Gracias por su calificacion"}'
    stub_request_webapi(:put, 'calificar_pedido', '{"id_pedido":"1","puntaje":"8"}', response)

    BotClient.new(FAKE_TOKEN).run_once
  end

  it 'Puedo cancelar mi pedido en estado Recibido' do
    pedir_y_cancelar_pedido_familiar '555'
    stub_request_webapi_pedidos('Ale', 'Familiar', 'Pedido exitoso del menu: Familiar. Tu numero de pedido es: 555')
    stub_request_webapi(:put, 'cancelar_pedido/555', nil, '{"respuesta": "Su pedido fue cancelado exitosamente."}')
    BotClient.new(FAKE_TOKEN).run_once
  end
end

def pedir_y_cancelar_pedido_familiar(id_pedido)
  when_i_send_text(FAKE_TOKEN, '/pedir Familiar')
  then_i_get_text(FAKE_TOKEN, 'Pedido exitoso del menu: Familiar. Tu numero de pedido es: ' + id_pedido)
  when_i_send_text(FAKE_TOKEN, '/cancelar_pedido ' + id_pedido)
  then_i_get_text(FAKE_TOKEN, 'Su pedido fue cancelado exitosamente.')
end
