require "#{File.dirname(__FILE__)}/../lib/routing"
require "#{File.dirname(__FILE__)}/../lib/version"
require "#{File.dirname(__FILE__)}/api"

class Routes
  include Routing

  USUARIO_UNICO = 'Ale'.freeze
  @api = Api.new

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{message.from.first_name}")
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.username}")
  end

  on_message '/version' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: Version.current)
  end

  on_message '/menu' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: @api.consultar_menu)
  end

  on_message_pattern %r{/pedir (?<text>.*)} do |bot, message, args|
    texto = @api.pedir(USUARIO_UNICO, args['text'],  message.from.id)
    bot.api.send_message(chat_id: message.chat.id, text: texto)
  end

  on_message_pattern %r{/registracion (?<text>.*)} do |bot, message, args|
    datos = args['text'].split ', '
    texto = @api.registrar_usuario(datos[0], datos[1], datos[2], message.from.id)
    bot.api.send_message(chat_id: message.chat.id, text: texto)
  end

  on_message_pattern %r{/estado_pedido (?<text>.*)} do |bot, message, args|
    texto = @api.pedir_estado(args['text'], message.from.id)
    bot.api.send_message(chat_id: message.chat.id, text: texto)
  end

  on_message_pattern %r{/cancelar_pedido (?<text>.*)} do |bot, message, args|
    texto = @api.cancelar_pedido(args['text'])
    bot.api.send_message(chat_id: message.chat.id, text: texto)
  end

  on_message_pattern %r{/calificar_pedido (?<text>.*)} do |bot, message, args|
    datos = args['text'].split ' : '
    texto = @api.calificar_pedido(datos[0], datos[1])
    bot.api.send_message(chat_id: message.chat.id, text: texto)
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
