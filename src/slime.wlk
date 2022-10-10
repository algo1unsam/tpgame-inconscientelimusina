import wollok.game.*
import espada.*
import juego.*
import player.*
import moneda.*
import healPack.*
import enemigos.*

class Slime inherits Enemigo(danho = 2,
							mensaje = [ "Más cuidado che", "Otra vez al comienzo..", "ouch...", "aaAaH!!!" ], 
							sprite_mov = [ "assets/slime (1).png", "assets/slime (2).png", "assets/slime (3).png", "assets/slime (4).png", "assets/slime (5).png", 
											"assets/slime (6).png", "assets/slime (7).png", "assets/slime (8).png", "assets/slime (9).png", "assets/slime (10).png" ]
							) {

	const sprite_danho = [ "assets/slime_red1.png", "assets/slime_red2.png", "assets/slime_red3.png", "assets/slime_red4.png", "assets/slime_red5.png", "assets/slime_red6.png", "assets/slime_red7.png", "assets/slime_red8.png", "assets/slime_red9.png", "assets/slime_red10.png", "slime_red11.png" ]
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
		sprites = sprite_danho
		transpasable = true
		if (vida <= 0) {
			self.morir()
		}
		else{
			direccion = !direccion
			
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
