import wollok.game.*
import espada.*
import juego.*
import player.*
import moneda.*
import healPack.*

class Slime {

	const slime_mov = [ "assets/slime (1).png", "assets/slime (2).png", "assets/slime (3).png", "assets/slime (4).png", "assets/slime (5).png", "assets/slime (6).png", "assets/slime (7).png", "assets/slime (8).png", "assets/slime (9).png", "assets/slime (10).png" ]
	const slime_danho = [ "assets/slime_red1.png", "assets/slime_red2.png", "assets/slime_red3.png", "assets/slime_red4.png", "assets/slime_red5.png", "assets/slime_red6.png", "assets/slime_red7.png", "assets/slime_red8.png", "assets/slime_red9.png", "assets/slime_red10.png", "slime_red11.png" ]
	var property sprites = slime_mov
	var image = (1..10).anyOne()
	var property position
	var fueAtacado = false
	var direccion = true
	const izquierda
	const derecha
	var vida = 5
	var transpasable = false
	var vivo = true

	method image() {
		return sprites.get(image)
	}



	method chocar() {
		if (!transpasable and player.estaVivo()) { player.bajarSalud(2)
			if (player.salud() > 0){
				player.transportar(player.posicionInicial())
				game.say(player, [ "Más cuidado che", "Otra vez al comienzo..", "ouch...", "aaAaH!!!" ].anyOne())
			}
		}
	}

	method Animate() {
		if (image < sprites.size() - 1) {
			image += 1
		} else {
			image = 0
		}
	}


	method iniciar() {
		vivo = true

		sprites = slime_mov
		transpasable = false
		fueAtacado = false
	}

	method mover() {
		if (!fueAtacado){
		self.Animate()
		if (direccion) {
			position = position.left(1)
			if (position.x() <= izquierda) {
				direccion = !direccion
			}
		} else {
			position = position.right(1)
			if (position.x() >= derecha) {
				direccion = !direccion
			}
		}
	}}

	method serAtacado(x) {
		vida -= x
		fueAtacado = true
		ataque.position(game.at(juego.tamanho(), juego.tamanho()))
		sprites = slime_danho
		transpasable = true
		if (vida <= 0) {
			self.morir()
		}
		else{
			direccion = !direccion
			
			game.schedule(450, { self.iniciar() })
		}

	}

	method morir() {
		self.detener()
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

	method reiniciar() {
		console.println("reiniciar slime")
		if (!juego.visuals().contains(self)) {
			game.addVisual(self)
			juego.visuals().add(self)
			console.println("reinicio slime")
		}
	}

	method detener() {
		if (vivo) {
			vivo = !vivo
			game.removeVisual(self)
			juego.visuals().remove(self)
			juego.nivelActual().enemigos().remove(self)
		}
	}

}
