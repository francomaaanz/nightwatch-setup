# nightwatch-setup
install npm modules

```
 npm install
 ```
 
 
 1 - - - - - - - - - - - - - - - - - - - - - - - - - - 
	.Instalar node dependencies corriendo npm install desde el root del proyecto. Esto instala : nightwatch, seleniuem-server-standalone y chrome-webdriver.

	Correr el comando 'npm run install-selenium', el cual instalara el servidor (el npm install solo descarga la dependencia del servidor de pruebas).

2 - - - - - - - - - - - - - - - - - - - - - - - - - -
	.Configurar nightwatch.json
	.Especificar carpeta de los tests.
	.Configuracion de selenium (host, port, server_path, cli_args)
	.test_setting
		Se especifican los entornos para testear donde decimos que queremos que haga el browser, que browser y podemos declacarar varibales globales de acceso para no hardcodear información

3 - - - - - - - - - - - - - - - - - - - - - - - - - - 
	Para poder correr los test hay que especificar en el packet.json dentro de scripts el nombre de la tarea y hacer referencia al archivo principal de nightwatch. En este caso:

    "nightwatch": "./node_modules/.bin/nightwatch" o solo nightwatch -c nightwatch (instalando nightwatch de forma global npm install nightwatch -g y con el -c haciendo referencia al archivo de configuracion nightwatch.json)

    De esta forma correriamos la configuracion standar.

     

    Para correr una pruebas especifica:

    nightwatch --test test/e2e/folder/test.j2

 	o especificada en el package.json

	"nightwatchcustomtest": "./node_modules/.bin/nightwatch --test test/e2e/test.spec.js"

    Para correr mocks especificos podemos crear tags y correrlos de la siguiente forma.
    Ej: pruebas con el tag mocks

    "nightwatch": "./node_modules/.bin/nightwatch --tag mocks"

    Para correr los mocks con un tag y en un ambiente XXX EJ: entorno beta, tag beta.

    "nightwatchbeta": "./node_modules/.bin/nightwatch -e beta --tag beta"

