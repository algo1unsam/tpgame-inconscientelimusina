import wollok.game.*
import espada.*
import juego.*
import player.*
import obtenibles.*
import animator.*

class Enemigo inherits Animable(miraDerecha = false,
							numeroDeSprite = 1
								){

	

	var direccionIzq = true
	const izquierda
	const derecha
	var vivo = true
	const danho 
	const mensaje






	method chocar() {
		if (player.estaVivo() && player.vulnerable()) { player.bajarSalud(danho)
			if (player.salud() > 0){
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
		if (direccionIzq) {
			position = position.left(1)
			if (position.x() <= izquierda) {
				direccionIzq = !direccionIzq
			}
		} else {
			position = position.right(1)
			if (position.x() >= derecha) {
				direccionIzq = !direccionIzq
			}
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

class Ghost inherits Enemigo( danho = 2,
							  mensaje = [ "Es la parca", "Que es esa cosa?"], 
							spriteInicial = ghost,
							animator = enemyAnimator){
	
	override method serAtacado(x){	
				game.say(self,"jajaja soy inmune a tus ataques")
		
	}
	

}


class Slime inherits Enemigo(danho = 2,
							mensaje = [ "Más cuidado che", "Otra vez al comienzo..", "ouch...", "aaAaH!!!" ], 
							spriteInicial = slime,
							animator = enemyAnimator
							) {

	
	var fueAtacado = false
	var vida = 5
	var transpasable = false



	override method chocar() {
		if (!transpasable){
			super()
		}
				}
		



	override method iniciar() {
		super()
		transpasable = false
		fueAtacado = false
	}


	override method mover() {
		if (!fueAtacado){
			super()}}

	override method serAtacado(x) {
		vida -= x
		fueAtacado = true
		ataque.position(game.at(juego.tamanho(), juego.tamanho()))
		animator.cambiarAnimate(self, slimeRojo)
		transpasable = true
		if (vida <= 0) {
			self.morir()
		}
		else{
			direccionIzq = !direccionIzq
			
			game.schedule(450, { self.iniciar() })
		}

	}

	override method morir() {
		super()
		self.dropear()

	}

	method dropear(){
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

//DISCUTIR SI BOSS DEBERIA HEREDAR O NO DE ENEMIGO, XQ SU LOGICA ES UN TANTO DISTINTA

class Boss
							 {
								
							var property salud = 10
							var property position
							var property numeroDeSprite = 1
							var property sprites = boss
							var spikeProb = 20
							const animator = bossAnimator
							var property miraDerecha = false
							
							method image() = animator.darImagen(self)

													
							method proximoSprite(){
									numeroDeSprite += 1
										}
													
							
							
							method serAtacado(x){
									animator.cambiarAnimate(self, bossDanho)
									game.schedule(1000, {animator.cambiarAnimate(self, boss)})
									salud = (salud - x).max(0)
									spikeProb += 5
									if (salud == 0){
										game.say(self, "auch che, duele una banda loco")
										self.dropear()
									}
								}
							

														
														
							method crearSpike(){
								const unSpike = new SpikeEnCaida(position = game.at((5..40).anyOne(), 24))
								game.addVisual(unSpike)
								juego.visuals().add(unSpike)
								juego.nivelActual().objetos().add(unSpike)
								juego.nivelActual().animables().add(unSpike)
								juego.enemigos().add(unSpike)
							}
							
							method crearLibro(){
								const unLibro = new LibroEnCaida(blanco = self, position = game.at((5..40).anyOne(), 33))
								game.addVisual(unLibro)
								juego.visuals().add(unLibro)
								juego.nivelActual().objetos().add(unLibro)
								juego.nivelActual().animables().add(unLibro)
								juego.enemigos().add(unLibro)
							}
							
							method mover(){

								animator.animate(self)

								const rng = (1..100).anyOne()
								if (rng <= spikeProb){
									2.times({i => self.crearSpike()})

								}
								else if (rng > 93){
									self.crearLibro()

									}

										
									
								}
								
								method dropear(){
									const dropearMoneda = juego.nivelActual().dropCoin().anyOne()
									const dropeable = new Moneda(position = game.at(20,  1))
									game.addVisual(dropeable)
									juego.visuals().add(dropeable)
									juego.nivelActual().dropCoin().remove(dropearMoneda)
								}
							}

class SpikeEnCaida {
	
	var property position
	
	method image() = "assets/spike A4.png"
	
	method iniciar() {}
	
	method mover(){
		position = position.down(1)
		if (position.y() == -3){
			self.remover()
		}
		}
		
	method remover(){
		game.removeVisual(self)
		juego.enemigos().remove(self)
		juego.visuals().remove(self)
		juego.nivelActual().objetos().remove(self)
		juego.nivelActual().animables().remove(self)
	}
	
	method chocar() {
		if (player.estaVivo()) { player.bajarSalud(1)
			if (player.salud() > 0){
				player.transportar(player.posicionInicial())
				game.say(player, ["Deberia agarrar los libros", "Cuantos pinches loco", "Esta feo el bicho ese"].anyOne())
			}
		}}
	
	method serAtacado(x) {
		}
		
	method detener(){}
	
	
	
}


