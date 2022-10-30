import wollok.game.*
import espada.*
import juego.*
import player.*
import obtenibles.*
import animator.*

class Enemigo inherits Animable {

	var vaHaciaLaIzquierda = true
	const izquierda
	const derecha
	var vivo = true
	const danho
	const mensaje

	method chocar() {
		if (player.estaVivo() && player.vulnerable()) {
			player.bajarSalud(danho)
			if (player.salud() > 0) {
				player.transportar(player.posicionInicial())
				game.say(player, mensaje.anyOne())
			}
		}
	}

	method iniciar() {
		vivo = true
		sprites = spriteInicial
	}

	method mover() {
		animator.animate(self)
		const direccion = if (vaHaciaLaIzquierda) 1 else -1
		position = position.left(direccion)
		if (!position.x().between(izquierda, derecha)) {
			vaHaciaLaIzquierda = !vaHaciaLaIzquierda
		}
	}

	method serAtacado(x) {
	}

	method morir() {
		self.detener()
	}

	method detener() {
		if (vivo) {
			vivo = !vivo
			game.removeVisual(self)
			juego.visuals().remove(self)
			juego.nivelAnterior().enemigos().remove(self)
		}
	}

}

class EnemigoQueDropea inherits Enemigo{
	
	var property salud
	const spriteDanho
	const tiempoRefractario
	const posicionDeDropeo = {self.position()}

	override method morir() {
		super()
		self.dropear()
	}

	override method serAtacado(x){
		if (vivo){
		salud -= x
		animator.cambiarAnimate(self, spriteDanho)
		self.verificarPulso()
	}
	}

	method verificarPulso(){
		if (salud <= 0) {
			self.morir()
		} else {
			game.schedule(tiempoRefractario, {self.iniciar()})
		}
	}

	method dropear() {
		const dropearMoneda = juego.nivelActual().dropCoin().anyOne()
		if (dropearMoneda) {
			const dropeable = new Moneda(position = posicionDeDropeo.apply())
		} else {
			const dropeable = new HealPack(position = posicionDeDropeo.apply())
		}
		game.addVisual(dropeable)
		juego.visuals().add(dropeable)
		juego.nivelActual().dropCoin().remove(dropearMoneda)
	}

	}

	


class Ghost inherits Enemigo(danho = 2, mensaje = [ "Es la parca", "Que es esa cosa?" ], spriteInicial = ghost, animator = enemyAnimator) {

	override method serAtacado(x) {
		game.say(self, "jajaja soy inmune a tus ataques")
	}

}

class Slime inherits EnemigoQueDropea(spriteDanho = slimeRojo, salud = 5, danho = 2, mensaje = [ "Más cuidado che", "Otra vez al comienzo..", "ouch...", "aaAaH!!!" ], spriteInicial = slime, animator = enemyAnimator, tiempoRefractario = 450) {

	var fueAtacado = false
	var transpasable = false

	override method chocar() {
		if (!transpasable) {
			super()
		}
	}

	override method iniciar() {
		super()
		transpasable = false
		fueAtacado = false
	}

	override method mover() {
		if (!fueAtacado) {
			super()
		}
	}

	override method serAtacado(x) {
		super(x)
		fueAtacado = true
		ataque.position(game.at(juego.tamanho(), juego.tamanho()))
		transpasable = true
		vaHaciaLaIzquierda = !vaHaciaLaIzquierda
		}

}

class Boss inherits EnemigoQueDropea( danho = 6, izquierda = 0, derecha = 0,mensaje = "Duele una banda loco", spriteDanho = bossDanho, salud = 10, animator = bossAnimator, spriteInicial = boss, tiempoRefractario = 1000, posicionDeDropeo = {game.at(20, 1)}) {


	var spikeProb = 18

	override method serAtacado(x) {
		spikeProb += 4
		super(x)
	}

	override method detener(){
		vivo = !vivo
		game.say(self, mensaje)
	}


	method creaObjeto(tipoDeObjeto) {
		const objetoEnCaida = new ObtenibleEnCaida(tipoDeObtenibleEnCaida = tipoDeObjeto, blanco = self, position = game.at((tipoDeObjeto.limiteIzquierda() .. tipoDeObjeto.limiteDerecha()).anyOne(), tipoDeObjeto.altura()), image = tipoDeObjeto.image())
		game.addVisual(objetoEnCaida)
		juego.visuals().add(objetoEnCaida)
		juego.enemigos().add(objetoEnCaida)
	}

	override method mover() {
		animator.animate(self)
		const rng = (1 .. 50).anyOne()
		if (rng <= spikeProb) {
			self.creaObjeto(tipoSpike)
		}  
		if (rng > 47) {
			self.creaObjeto(tipoLibro)
		}
		else if (rng < 3){
			self.creaObjeto(tipoReloj)
		}
		else if (rng.between(25,26)){
			self.creaObjeto(tipoHealPack)
		}

		
	}
}


object tipoSpike inherits TipoDeObtenibleEnCaida(limiteIzquierda = 5, limiteDerecha = 36, altura = 24){

	const property image = "assets/spike A4.png"

	override method chocar(unObjeto) {
		if (player.estaVivo()) {
			player.bajarSalud(2)
			if (player.salud() > 0) {
				player.transportar(player.posicionInicial())
				game.say(player, [ "Quiza debería agarrar los libros", "Cuantos pinches che", "Esta feo el bicho ese" ].anyOne())

	}
}
}}