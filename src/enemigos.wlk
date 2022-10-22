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

class Ghost inherits Enemigo(danho = 2, mensaje = [ "Es la parca", "Que es esa cosa?" ], spriteInicial = ghost, animator = enemyAnimator) {

	override method serAtacado(x) {
		game.say(self, "jajaja soy inmune a tus ataques")
	}

}

class Slime inherits Enemigo(danho = 2, mensaje = [ "Más cuidado che", "Otra vez al comienzo..", "ouch...", "aaAaH!!!" ], spriteInicial = slime, animator = enemyAnimator) {

	var fueAtacado = false
	var vida = 5
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
		vida -= x
		fueAtacado = true
		ataque.position(game.at(juego.tamanho(), juego.tamanho()))
		animator.cambiarAnimate(self, slimeRojo)
		transpasable = true
		if (vida <= 0) {
			self.morir()
		} else {
			vaHaciaLaIzquierda = !vaHaciaLaIzquierda
			game.schedule(450, { self.iniciar()})
		}
	}

	override method morir() {
		super()
		self.dropear()
	}

	method dropear() {
		const dropearMoneda = juego.nivelActual().dropCoin().anyOne()
		if (dropearMoneda) {
			const dropeable = new Moneda(position = self.position())
		} else {
			const dropeable = new HealPack(position = self.position())
		}
		game.addVisual(dropeable)
		juego.visuals().add(dropeable)
		juego.nivelActual().dropCoin().remove(dropearMoneda)
	}

}

class Boss inherits Animable(animator = bossAnimator, spriteInicial = boss) {

	var property salud = 10
	var spikeProb = 18

	method serAtacado(x) {
		animator.cambiarAnimate(self, bossDanho)
		game.schedule(1000, { animator.cambiarAnimate(self, boss)})
		salud = (salud - x).max(0)
		spikeProb += 4
		if (salud == 0) {
			game.say(self, "Duele una banda loco")
			self.dropear()
		}
	}

	method crea(unObjeto) {
		game.addVisual(unObjeto)
		juego.visuals().add(unObjeto)
		juego.enemigos().add(unObjeto)
	}

	method crearSpike() {
		const unSpike = new SpikeEnCaida(position = game.at((5 .. 36).anyOne(), 24))
		self.crea(unSpike)
	}

	method crearLibro() {
		const unLibro = new LibroEnCaida(blanco = self, position = game.at((7 .. 34).anyOne(), 33))
		self.crea(unLibro)
	}
	
	method crearReloj(){
		const unReloj = new RelojEnCaida(position = game.at((7 .. 34).anyOne(), 33))
		self.crea(unReloj)
	}
	
	method crearVida(){
		const unaVida = new HealPackEnCaida(position = game.at((7 .. 34).anyOne(), 33))
		self.crea(unaVida)
	}

	method mover() {
		animator.animate(self)
		const rng = (1 .. 50).anyOne()
		if (rng <= spikeProb) {
			self.crearSpike()
		}  
		if (rng > 47) {
			self.crearLibro()
		}
		else if (rng < 3){
			self.crearReloj()
		}
		else if (rng.between(25,26)){
			self.crearVida()
		}
		
	}

	method dropear() {
		const dropearMoneda = juego.nivelActual().dropCoin().anyOne()
		const dropeable = new Moneda(position = game.at(20, 1))
		game.addVisual(dropeable)
		juego.visuals().add(dropeable)
		juego.nivelActual().dropCoin().remove(dropearMoneda)
	}

}

class SpikeEnCaida inherits ObtenibleEnCaida(image = "assets/spike A4.png") {

	override method chocar() {
		if (player.estaVivo()) {
			player.bajarSalud(2)
			if (player.salud() > 0) {
				player.transportar(player.posicionInicial())
				game.say(player, [ "Quiza debería agarrar los libros", "Cuantos pinches che", "Esta feo el bicho ese" ].anyOne())
			}
		}
	}

}

