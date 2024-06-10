#language: es

Característica: US1 Registración básica de usuario
  Para acceder a la aplicación
  Como un usuario
  Quiero poder registrarme

  Escenario: Registracion basica de usuario
    Dado que inicio el proceso de registracion de usuario
    Cuando ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoyte 123"
    Y ingreso mi telefono "1112345678"
    Entonces recibo el mensaje "Bienvenido Ale"


  @bot
  Escenario: Registracion basica de usuario
    Cuando ingreso el comando /registracion Ale, Acoyte 123, 1112345678
    Entonces recibo el mensaje "Bienvenido Ale"


Característica: US2 Registración básica de repartidor
  Para acceder a la aplicación
  Como un repartidor
  Quiero poder registrarme

  Escenario: Registracion basica de repartidor
    Dado que inicio el proceso de registracion de repartidor en el Telegram de la Bobe
    Cuando ingreso mi nombre y apellido "Ale con bici"
    Y ingreso mi dni "10999888"
    Y ingreso mi telefono "1112345678"
    Entonces recibo un mensaje de registracion de repartidor exitosa

  @api
  Escenario: Registracion de repartidor
    Cuando ingreso el comando curl -X POST 'https://webapi-bobe-production.herokuapp.com/registrar_repartidor/nombre=Ale con bici'
    Entonces recibo el mensaje "Repartidor registrado"


Característica: US3 Consultar opciones de menu

  Antecedentes:
    Dado que el Usuario "Juan" esta registrado

  Escenario: US3-01 - Consulta simple de menú
    Dado que existe un menu
    Cuando consulto las opciones de menu
    Entonces obtengo "Individual", con precio 1000
    Entonces obtengo "Pareja", con precio 1500
    Entonces obtengo "Familiar", con precio 2500

  @bot
  Escenario: US3-01 - Consulta simple de menú
    Dado que existe un menu
    Cuando consulto las opciones de menu con el comando /menu
    Entonces obtengo "Individual", con precio 1000
    Entonces obtengo "Pareja", con precio 1500
    Entonces obtengo "Familiar", con precio 2500


Característica: US4 Pedido de menú único
  Para comprar un menu
  Como un usuario
  Quiero poder realizar un pedido

  Antecedentes:
    Dado que ya estoy registrado como usuario en el Telegram de la Bobe

  Escenario: Pedido del menu individual
    Dado que consulto las opciones de menu
    Cuando pido el menu "Individual"
    Entonces recibo el mensaje "Pedido exitoso del menu: Individual"

  @bot
  Escenario: Pedido menu individual
    Dado que consulto las opciones de menu con el comando /menu
    Cuando pido el menu individual con el comando /pedir individual
    Entonces recibo el mensaje "Pedido exitoso del menu: Individual"


Característica: US5  Cambiar el estado del pedido de Recibido a Preparando
  Para empezar a preparar un pedido
  Como un dueño del negocio
  Quiero poder progresar el estado del pedido

  Antecedentes:
    Dado que soy empleado de la bobe con acceso al sistema

  Escenario: Cuando se empieza a preparar el pedido, el estado pasa de Recibido a Preparando
    Dado que recibo un nuevo pedido y el estado del pedido es "Recibido"
    Cuando progreso el estado del pedido
    Entonces el estado del pedido es "Preparando"

  @api
  Escenario: Cuando se empieza a preparar el pedido, el estado pasa de Recibido a Preparando
    Cuando ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/cambiar_estado'
    Entonces el estado del pedido es "Preparando"
    Entonces recibo el mensaje "Preparando pedido"


Característica: US6 Cambiar el estado del pedido de Preparando a Enviando (esto incluye la asignación básica de repartidor)

  Antecedentes:
    Dado que el Usuario "Mariano" esta registrado
    Dado que el Repartidor "Alejandro" esta registrado
    Dado que existe un pedido para "Mariano"

  Escenario: US3-01 - Cuando el pedido esta listo, se asigna el repartidor y el estado pasa a Enviando
    Cuando el pedido esta listo
    Entonces el estado pasa de "Preparando" a "Enviando"
    Y el mismo se asigna al repartidor "Alejandro"

  @api
  Escenario: Cuando el pedido esta listo, se asigna el repartidor y el estado pasa a Enviando
    Cuando ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/cambiar_estado'
    Cuando ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/asignar_repartidor/nombre=Alejandro'
    Entonces recibo el mensaje "Repartidor asignado"
    Entonces el estado del pedido es "Enviando"
    Entonces recibo el mensaje "Enviando pedido"


Característica: US7 Cambiar el estado del pedido de Enviando a Entregado

  Antecedentes:
    Dado que el Usuario "Pablo" esta registrado

  Escenario: US3-01 - Cuando el Usuario recibe el pedido, el estado pasa a Entregado
    Dado que existe un pedido para "Pablo"
    Cuando el mismo recibe el pedido
    Entonces el estado pasa de "Enviando" a "Entregado"

  @api
  Escenario: Cuando el Usuario recibe el pedido, el estado pasa a Entregado
    Cuando ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/cambiar_estado'
    Entonces el estado del pedido es "Entregado"
    Entonces recibo el mensaje "Pedido entregado"


Característica: US8 Consulta de estado del pedido sin ID
  Para saber el estado de un pedido
  Como usuario
  Quiero poder consultar un pedido

  Antecedentes:
    Dado que ya estoy registrado como usuario en el Telegram de la Bobe

  Escenario: Consulta del estado del pedido recibido
    Dado que realizo un nuevo pedido
    Cuando consulto mi pedido
    Entonces el estado del pedido es "Recibido"

  @bot
  Escenario: Consulta del estado del pedido recibido
    Dado que consulto las opciones de menu con el comando /menu
    Cuando pido el menu individual con el comando /pedir individual
    Cuando consulto mi pedido con el comando /estado_pedido
    Entonces el estado del pedido es "Recibido"

  Escenario: Consulta del estado del pedido preparando
    Y mi pedido es progresado de estado
    Cuando consulto mi pedido
    Entonces el estado del pedido es "Preparando"

  @bot
  Escenario: Consulta del estado del pedido preparando
    Y ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/cambiar_estado'
    Cuando consulto mi pedido con el comando /estado_pedido
    Entonces el estado del pedido es "Preparando"

  Escenario: Consulta del estado del pedido enviando
    Y mi pedido es progresado de estado
    Cuando consulto mi pedido
    Entonces el estado del pedido es "Enviando"

  @bot
  Escenario: Consulta del estado del pedido enviando
    Y ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/cambiar_estado'
    Cuando consulto mi pedido con el comando /estado_pedido
    Entonces el estado del pedido es "Enviando"

  Escenario: Consulta del estado del pedido entregado
    Y mi pedido es progresado de estado
    Cuando consulto mi pedido
    Entonces el estado del pedido es "Entregado"

  @bot
  Escenario: Consulta del estado del pedido entregado
    Y ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/cambiar_estado'
    Cuando consulto mi pedido con el comando /estado_pedido
    Entonces el estado del pedido es "Entregado"

Característica: US14 Pedido de menú eligiendo una opción
  Para comprar el menu que quiero
  Como un usuario
  Quiero poder elegir el menu para pedir

  Antecedentes:
    Dado que ya estoy registrado como usuario en el Telegram de la Bobe

  @bot
  # Antecedentes:
  # Dado que ya registre un usuario con el comando /registracion Ale, Acoyte 123, 1112345678


  Escenario: Pedido del menu individual
    Dado que consulto las opciones de menu
    Cuando pido el menu "Individual"
    Entonces recibo el mensaje "Pedido exitoso del menu: Individual"

  @bot
  Escenario: Pedido del menu individual
    Dado que consulto las opciones de menu con el comando /menu
    Cuando pido el menu Individual con el comando /pedir Individual
    Entonces recibo el mensaje "Pedido exitoso del menu: Individual"

  Escenario: Pedido del menu pareja
    Dado que consulto las opciones de menu
    Cuando pido el menu "Pareja"
    Entonces recibo el mensaje "Pedido exitoso del menu: Pareja"

  @bot
  Escenario: Pedido del menu pareja
    Dado que consulto las opciones de menu con el comando /menu
    Cuando pido el menu Pareja con el comando /pedir Pareja
    Entonces recibo el mensaje "Pedido exitoso del menu: Pareja"

  Escenario: Pedido del menu familiar
    Dado que consulto las opciones de menu
    Cuando pido el menu "Familiar"
    Entonces recibo el mensaje "Pedido exitoso del menu: Familiar"

  @bot
  Escenario: Pedido del menu familiar
    Dado que consulto las opciones de menu con el comando /menu
    Cuando pido el menu "Familiar" con el comando /pedir Familiar
    Entonces recibo el mensaje "Pedido exitoso del menu: Familiar"

  Escenario: Pedido de algo que no esta en el menu
    Dado que consulto las opciones de menu
    Cuando pido el menu "Repollos"
    Entonces recibo el mensaje de error "Pedido fallido elija una opcion valida"

  @bot
  Escenario: Pedido de algo que no esta en el menu
    Dado que consulto las opciones de menu con el comando /menu
    Cuando pido algo que no esta en el menu con el comando /pedir Repollos
    Entonces recibo el mensaje de error "Pedido fallido elija una opcion valida"

Característica: US10 Validar usuario nombre, dirección, teléfono completos
  Para poder registrar un nuevo usuario
  Como sistema
  Quiero poder validar los datos ingresados

  Escenario: Registro fallido por nombre vacío
    Dado que ingreso mi nombre ""
    Y ingreso mi direccion "Acoyte 123"
    Y ingreso mi telefono 1112345678
    Cuando inicio el proceso de registracion de usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallido por nombre vacío
    Cuando ingreso el comando /registracion , Acoyte 123, 1112345678
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro fallido tamaño de nombre mayor a 20 caracteres
    Dado que ingreso mi nombre "abcdefghijklmnopqrstuvwxyz"
    Y ingreso mi direccion "Acoyte 123"
    Y ingreso mi telefono 1112345678
    Cuando inicio el proceso de registracion de usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallido por nombre de tamanio mayor a 20 caracteres
    Cuando ingreso el comando /registracion abcdefghijklmnopqrstuvwxyz, Acoyte 123, 1112345678
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro exitoso con nombre de tamaño igual a 20 caracteres
    Dado que ingreso mi nombre "abcdefghijklmnopqrst"
    Y ingreso mi direccion "Acoyte 123"
    Y ingreso mi telefono 1112345678
    Cuando inicio el proceso de registracion de usuario
    Entonces recibo el mensaje "Bienvenido abcdefghijklmnopqrst"

  @bot
  Escenario: Registro exitoso con nombre de tamanio igual a 20 caracteres
    Cuando ingreso el comando /registracion abcdefghijklmnopqrst, Acoyte 123, 1112345678
    Entonces recibo el mensaje "Bienvenido abcdefghijklmnopqrst"

  Escenario: Registro fallido por dirección vacía
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion ""
    Y ingreso mi telefono 1112345678
    Cuando inicio el proceso de registracion de usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallida por dirección vacía
    Cuando ingreso el comando /registracion Ale, , 1112345678
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro fallido por dirección de tamaño menor a 5 caracteres
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoy"
    Y ingreso mi telefono 1112345678
    Cuando inicio el proceso de registracion de usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallida por direccion de tamanio menor a 5 caracteres
    Cuando ingreso el comando /registracion Ale, Acoy, 1112345678
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro exitoso con dirección de tamañ igual a 5 caracteres
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoyt"
    Y ingreso mi telefono 1112345678
    Cuando inicio el proceso de registracion de usuario
    Entonces recibo el mensaje "Bienvenido Ale"

  @bot
  Escenario: Registro exitoso con dirección de tamañ igual a 5 caracteres
    Cuando ingreso el comando /registracion Ale, Acoyt, 1112345678
    Entonces recibo el mensaje "Bienvenido Ale"

  Escenario: Registro fallido por teléfono vacío
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoyte 123"
    Cuando inicio el proceso de registracion de usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallido por teléfono vacío
    Cuando ingreso el comando /registracion Ale, Acoyte 123,  (importante poner un espacio luego de la ultima ',')
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro fallido por ingresar teléfono no numérico
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoy"
    Y ingreso mi telefono "esto no es un telefono jaja"
    Cuando inicio el proceso de registracion de usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallida por ingresar telefono no numerico
    Cuando ingreso el comando /registracion Ale, Acoyte 123, esto no es un telefono jaja
    Entonces recibo el mensaje "Registración fallida"

Característica: US10 Validar usuario nombre, dirección, teléfono completos
  Escenario: Registro fallido por nombre vacío
    Dado que ingreso mi nombre ""
    Y ingreso mi direccion "Acoyte 123"
    Y ingreso mi telefono "1112345678"
    Cuando me registro como usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallido por nombre vacío
    Cuando ingreso el comando /registracion , Acoyte 123, 1112345678
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro fallido tamaño de nombre mayor a 20 caracteres
    Dado que ingreso mi nombre "abcdefghijklmnopqrstuvwxyz"
    Y ingreso mi direccion "Acoyte 123"
    Y ingreso mi telefono "1112345678"
    Cuando me registro como usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallido por nombre de tamaño mayor a 20 caracteres
    Cuando ingreso el comando /registracion abcdefghijklmnopqrstuvwxyz, Acoyte 123, 1112345678
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro exitoso con nombre de tamaño igual a 20 caracteres
    Dado que ingreso mi nombre "abcdefghijklmnopqrst"
    Y ingreso mi direccion "Acoyte 123"
    Y ingreso mi telefono "1112345678"
    Cuando me registro como usuario
    Entonces recibo el mensaje "Bienvenido abcdefghijklmnopqrst"

  @bot
  Escenario: Registro exitoso con nombre de tamaño igual a 20 caracteres
    Cuando ingreso el comando /registracion abcdefghijklmnopqrst, Acoyte 123, 1112345678
    Entonces recibo el mensaje "Bienvenido abcdefghijklmnopqrst"

  Escenario: Registro fallido por dirección vacía
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion ""
    Y ingreso mi telefono "1112345678"
    Cuando me registro como usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallida por dirección vacía
    Cuando ingreso el comando /registracion Ale, , 1112345678
    Entonces recibo el mensaje "Registración fallida"


  Escenario: Registro fallido por dirección de tamaño menor a 5 caracteres
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoy"
    Y ingreso mi telefono "1112345678"
    Cuando me registro como usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallida por direccion de tamaño menor a 5 caracteres
    Cuando ingreso el comando /registracion Ale, Acoy, 1112345678
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro exitoso con dirección de tamaño igual a 5 caracteres
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoyt"
    Y ingreso mi telefono "1112345678"
    Cuando me registro como usuario
    Entonces recibo el mensaje "Bienvenido Ale"

  @bot
  Escenario: Registro exitoso con dirección de tamaño igual a 5 caracteres
    Cuando ingreso el comando /registracion Ale, Acoyt, 1112345678
    Entonces recibo el mensaje "Bienvenido Ale"

  Escenario: Registro fallido por teléfono vacío
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoyte 123"
    Cuando me registro como usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallido por teléfono vacío
    Cuando ingreso el comando /registracion Ale, Acoyte 123, # (importante poner un espacio luego de la ultima ',')
    Entonces recibo el mensaje "Registración fallida"

  Escenario: Registro fallido por ingresar teléfono no numérico
    Dado que ingreso mi nombre "Ale"
    Y ingreso mi direccion "Acoy"
    Y ingreso mi telefono "esto no es un telefono jaja"
    Cuando me registro como usuario
    Entonces recibo el mensaje de error de registración "Registración fallida"

  @bot
  Escenario: Registro fallida por ingresar telefono no numerico
    Cuando ingreso el comando /registracion Ale, Acoyte 123, esto no es un telefono jaja
    Entonces recibo el mensaje "Registración fallida"

Característica: US23 Cálculo de comisiones básico (sin tener en cuenta calificaciones)
  Para conocer mis honorarios
  Como repartidor
  Quiero poder consultar la comisión de un pedido

  Antecedentes:
    Dado me registro como usuario
    Dado me registro como repartidor

  # @bot
  # Antecedentes:
    curl -X POST 'https://webapi-bobe-test.herokuapp.com/reset'
    Dado que ya registre un usuario con el comando /registracion Ale, Acoyte 123, 1112345678
    Dado ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/repartidor' -H 'Content-Type: application/json' -d '{"nombre":"Ale con bici","dni":"22333444","telefono":"1144445555"}'

  Escenario: US23-1 Repartidor recibe comision del 5% al entregar pedido Individual
    Dado pido el menu "Individual"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Y es asignado al primer repartidor sin pedidos
    Cuando progreso el estado del pedido
    Entonces el repartidor recibe una comision de $50 por el pedido

  @bot
  Escenario: US23-1 Repartidor recibe comision del 5% al entregar pedido Individual
    Dado que se pidió un menu Individual con el comando /pedir Individual
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Y veo que tiene asignado un repartidor
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Y ingreso el comando curl -X GET 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>' -H "Content-Type: application/json"
    Entonces verifico que la comisión es de $50

  Escenario: US23-2 Repartidor recibe comision del 5% al entregar pedido Pareja
    Dado pido el menu "Familiar"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Y es asignado al primer repartidor sin pedidos
    Cuando progreso el estado del pedido
    Entonces el repartidor recibe una comision de $125 por el pedido

  @api
  Escenario: US23-2 Repartidor recibe comision del 5% al entregar pedido Familiar
    Dado que se pidió un menu Individual con el comando /pedir Pareja
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Y veo que tiene asignado un repartidor
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Y ingreso el comando curl -X GET 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>' -H "Content-Type: application/json"
    Entonces verifico que la comisión es de $75

  Escenario: US23-3 Repartidor recibe comision del 5% al entregar pedido Familiar
    Dado pido el menu "Familiar"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Y es asignado al primer repartidor sin pedidos
    Cuando progreso el estado del pedido
    Entonces el repartidor recibe una comision de $125 por el pedido

  @api
    Escenario: US23-3 Repartidor recibe comision del 5% al entregar pedido Familiar
    Dado que se pidió un menu Individual con el comando /pedir Familiar
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Y veo que tiene asignado un repartidor
    Dado ingreso el comando curl -X PUT 'https://webapi-bobe-test.herokuapp.com/progresar_estado' -H 'Content-Type: application/json' -d '{"id":"<id_del_pedido>"}'
    Y ingreso el comando curl -X GET 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>' -H "Content-Type: application/json"
    Entonces verifico que la comisión es de $125

 Característica: US24 Cálculo de comisiones con calificación.
  Como repartidor
  Quiero que las calificaciones apliquen a mis pedidos
  Para cobrar la comisión proporcional

  Antecedentes:
    Dado me registro como usuario
    Dado me registro como repartidor

  # @bot
  # Antecedentes:
    # curl -X POST 'https://webapi-bobe-test.herokuapp.com/reset'
    # Dado que ya registre un usuario con el comando /registracion Ale, Acoyte 123, 1112345678
    # Dado ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/repartidor' -H 'Content-Type: application/json' -d '{"nombre":"Ale con bici","dni":"22333444","telefono":"1144445555"}'

  Escenario: US24-1 Pedido recibe una calificación de 1 y la comisión es de 3%
    Dado que existe un pedido menu "Individual"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 1
    Entonces el repartidor recibe una comision de $30 por el pedido

  @bot
  Escenario: US24-1 Pedido recibe una calificación de 1 y la comisión es de 3%
    Dado que realizo un pedido con /pedir Individual
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido 1 : 1
    Entonces ingreso el comando curl -X GET -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto no es 5% sino 3% o sea $30

  Escenario: US24-2 Pedido recibe una calificación de 2 y la comisión es de 5%
    Dado que existe un pedido menu "Pareja"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 2
    Entonces el repartidor recibe una comision de $75 por el pedido

  @bot
  Escenario: US24-2 Pedido recibe una calificación de 2 y la comisión es de 5%
    Dado que realizo un pedido con /pedir Pareja
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido 1 : 2
    Entonces ingreso el comando curl -X GET -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto es $75

  Escenario: US24-3 Pedido recibe una calificación de 3 y la comisión es de 5%
    Dado que existe un pedido menu "Familiar"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 3
    Entonces el repartidor recibe una comision de $125 por el pedido

  @bot
  Escenario: US24-3 Pedido recibe una calificación de 3 y la comisión es de 5%
    Dado que realizo un pedido con /pedir Familiar
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'id_del_pedido>'
    Cuando califico el pedido con /calificar_pedido 1 : 3
    Entonces ingreso el comando curl -X GET -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto es $150

  Escenario: US24-4 Pedido recibe una calificación de 4 y la comisión es de 5%
    Dado que existe un pedido menu "Pareja"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 4
    Entonces el repartidor recibe una comision de $75 por el pedido

  @bot
    Escenario: US24-4 Pedido recibe una calificación de 4 y la comisión es de 5%
    Dado que realizo un pedido con /pedir Pareja
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido 1 : 4
    Entonces ingreso el comando curl -X GET -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto es $75

  Escenario: US24-5 Pedido recibe una calificación de 5 y la comisión es de 7%
    Dado que existe un pedido menu "Pareja"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 5
    Entonces el repartidor recibe una comision de $105 por el pedido

  @bot
    Escenario: US24-5 Pedido recibe una calificación de 5 y la comisión es de 7%
    Dado que realizo un pedido con /pedir Pareja
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido 1 : 5
    Entonces ingreso el comando curl -X GET -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto es $105


Característica: US22 Validar no calificar un pedido con una puntuación invalida
  Como repartidor
  Quiero que las calificaciones se hagan dentro de los valores correctos
  Para cobrar la comisión proporcional

  Antecedentes:
    Dado me registro como usuario
    Dado me registro como repartidor

 @bot
  Antecedentes:
    curl -X POST 'https://webapi-bobe-test.herokuapp.com/reset'
    Dado que ya registre un usuario con el comando /registracion Ale, Acoyte 123, 1112345678
    Dado ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/repartidor' -H 'Content-Type: application/json' -d '{"nombre":"Ale con bici","dni":"22333444","telefono":"1144445555"}'

  Escenario: US22-1 Pedido recibe una calificación de 0 y devuelve error
    Dado que existe un pedido menu "Individual"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 0
    Entonces recibo el mensaje con el error "Calificación inválida, ingrese un número entero entre 1 y 5"

  @bot
  Escenario: US22-1 Pedido recibe una calificación de 0 y devuelve error
    Dado que realizo un pedido con /pedir Individual
    Dado que ingreso el comando curl -X PUT -d '{"id":647}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido <id_del_pedido> : 0
    Entonces se devuelve un error "Calificación inválida, ingrese un número entero entre 1 y 5"

  Escenario: US22-2 Pedido recibe una calificación de 4,2 y devuelve error
    Dado que existe un pedido menu "Individual"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 4,2
    Entonces recibo el mensaje con el error "Calificación inválida, ingrese un número entero entre 1 y 5"

  @bot
  Escenario: US22-2 Pedido recibe una calificación de 4,2 y devuelve error
    Dado que realizo un pedido con /pedir Individual
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido <id_del_pedido> : 4,2
    Entonces se devuelve un error "Calificación inválida, ingrese un número entero entre 1 y 5"

  Escenario: US22-3 Pedido recibe una calificación de 6 y devuelve error
    Dado que existe un pedido menu "Individual"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 6
    Entonces recibo el mensaje con el error "Calificación inválida, ingrese un número entero entre 1 y 5"

  @bot
  Escenario: US22-3 Pedido recibe una calificación de 6 y devuelve error
    Dado que realizo un pedido con /pedir Individual
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido <id_del_pedido> : 6
    Entonces se devuelve un error "Calificación inválida, ingrese un número entero entre 1 y 5"

  Escenario: US22-4 Pedido recibe una calificación de una letra y devuelve error
    Dado que existe un pedido menu "Individual"
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje "A"
    Entonces recibo el mensaje con el error "Calificación inválida, ingrese un número entero entre 1 y 5"

  @bot
  Escenario: US22-4 Pedido recibe una calificación de una letra y devuelve error
    Dado que realizo un pedido con /pedir Individual
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido <id_del_pedido> : A
    Entonces se devuelve un error "Calificación inválida, ingrese un número entero entre 1 y 5"

#language: es

Característica: US25 Cálculo de comisiones con día de lluvia
  Como repartidor
  Quiero que sea tenido en cuenta si está lloviendo
  Para cobrar una comisión mayor

  Antecedentes:
    Dado que ya estoy registrado como usuario en el Telegram de la Bobe
    Dado que el repartidor "Ale con bici" está registrado

  # @bot
  # Antecedentes:
    # curl -X POST 'https://webapi-bobe-test.herokuapp.com/reset'
    #  Dado que ya registre un usuario con el comando /registracion Ale, Acoyte 123, 1112345678
    #  Dado ingreso el comando curl -X POST 'https://webapi-bobe-test.herokuapp.com/repartidor' -H 'Content-Type: application/json' -d '{"nombre":"Ale con bici","dni":"22333444","telefono":"1144445555"}'

  Escenario: US25-1 Pedido entregado en día de lluvia recibe 1% adicional
    Dado que existe un pedido menu "Individual"
    Dado que llueve
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Entonces el repartidor recibe una comision de $60 por el pedido

  @bot
  Escenario: US25-1 Pedido entregado en día de lluvia recibe 1% adicional
    Dado que realizo un pedido con /pedir Individual
    Dado que ingreso el comando curl -X PUT -d '{"esta_lloviendo":true}' 'https://webapi-bobe-test.herokuapp.com/mock_lluvia_activar'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Entonces ingreso el comando curl -X GET 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto no es 5% sino 6% o sea $60

  Escenario: US25-2 Pedido entregado en día no lluvioso no recibe porcentaje adicional
    Dado que existe un pedido menu "Individual"
    Dado que no llueve
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Entonces el repartidor recibe una comision de $50 por el pedido

  @bot
  Escenario: US25-2 Pedido entregado en día no lluvioso no recibe porcentaje adicional
    Dado que realizo un pedido con /pedir Individual
    Dado que ingreso el comando curl -X PUT -d '{"esta_lloviendo":false}' 'https://webapi-bobe-test.herokuapp.com/mock_lluvia_activar'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Entonces ingreso el comando curl -X GET 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto es 5% o sea $50

  Escenario: US25-3 Pedido entregado en día lluvioso con calificación 5 recibe porcentaje adicional
    Dado que existe un pedido menu "Individual"
    Dado que llueve
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando califico el pedido con puntaje 5
    Entonces el repartidor recibe una comision de $80 por el pedido

  @bot
  Escenario: US25-3 Pedido entregado en día lluvioso con calificación 5 recibe porcentaje adicional
    Dado que realizo un pedido con /pedir Individual
    Dado que ingreso el comando curl -X PUT -d '{"esta_lloviendo":true}' 'https://webapi-bobe-test.herokuapp.com/mock_lluvia_activar'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando califico el pedido con /calificar_pedido <id_del_pedido> : 5
    Entonces ingreso el comando curl -X GET 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto no es 7% sino 8% o sea $80

  Escenario: US25-4 Pedido entregado en día lluvioso sin calificación recibe porcentaje adicional
    Dado que existe un pedido menu "Familiar"
    Dado que llueve
    Dado progreso el estado del pedido
    Dado progreso el estado del pedido
    Cuando progreso el estado del pedido
    Entonces el repartidor recibe una comision de $150 por el pedido

  @bot
  Escenario: US25-4 Pedido entregado en día lluvioso sin calificación recibe porcentaje adicional
    Dado que realizo un pedido con /pedir Familiar
    Dado que ingreso el comando curl -X PUT -d '{"esta_lloviendo":true}' 'https://webapi-bobe-test.herokuapp.com/mock_lluvia_activar'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Dado que ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Cuando ingreso el comando curl -X PUT -d '{"id":<id_del_pedido>}' 'https://webapi-bobe-test.herokuapp.com/progresar_estado'
    Entonces ingreso el comando curl -X GET 'https://webapi-bobe-test.herokuapp.com/comision_pedido/<id_del_pedido>'
    Entonces verifico que el monto no es 5% sino 6% o sea $150

