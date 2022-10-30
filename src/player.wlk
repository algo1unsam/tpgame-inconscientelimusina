import wollok.game.*
import juego.*
import espada.*
import playerHit.*
import animator.*

object player inherits Animable(animator = playerAnimator, miraDerecha = true, spriteInicial = idle, position = game.at(0, 2)) {

	var vivo = true
	var property salud = 6
	var property mov = false
	var property saltando = false
	var property atacando = false
	var property ataquesEnCombo = [{self.condicionesDeAtaque()}, {false}, {false}]
	var cayendo = false
	var property tieneEspada = false
	var property att_combo = false
	var property vulnerable = true
	const property hitbox = []
	const ataquesDePlayer = [att1, att2, att3]


	method todaLaVida() {
		self.salud(6)
	}

	method posicionInicial() = game.at(0, 2)

	method caerAlPozo() {
		if (self.position().y() == -4) {
		self.transportar(self.posicionInicial())
		self.bajarSalud(1)}
	}

	method grounded() = juego.plataformas().contains(game.at(self.position().x() + 3, self.position().y() - 1)) or juego.plataformas().contains(game.at(self.position().x() + 4, self.position().y() - 1))

	method saltar() {
		if (vivo and (self.grounded() or (!cayendo and !saltando))) { // coyote jump
			saltando = true
			animator.cambiarAnimate(self, salto)
			3.times({ i => game.schedule((i - 1) * 150, { self.moverEnY(1)})})
			game.schedule(350, { self.saltando(false)})
		}
	}

	method subirSalud(x) {
		salud = (salud + x).min(6)
	}

	method bajarSalud(x) {
		salud = (salud - x).max(0)
		if (salud == 0) {
			self.morir()
		}
	}

	method moverEnY(cantidad) {
		position = position.up(cantidad)
		hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().up(cantidad))})
	}

	method caer() {
		if (!self.grounded() and !saltando) {
			animator.cambiarAnimate(self, caida)
			cayendo = true
			self.moverEnY(-1)
			self.caerAlPozo()
		} else if (self.grounded() and (sprites == caida)) {
			self.aterrizar()
		}
	}

	method aterrizar() {
		cayendo = false
		self.jugadorEnReposo()
	}

	method jugadorEnReposo() {
		mov = false
		if (self.grounded() && !atacando ) { // si no esta en el piso en ese momento su animacion deberia ser salto o caida, no idle
				if (tieneEspada) {
					animator.cambiarAnimate(self, idle_espada)
				} else {
					animator.cambiarAnimate(self, idle)
				}
			}
		}

	method caminar(direccion) {
		miraDerecha = direccion
		
		if (vivo and !mov) {
			mov = true
			if (self.grounded()) {
				self.ejecutarMovimiento(walk, 3, 400, {self.jugadorEnReposo()}, direccion)
			} else {
				self.ejecutarMovimiento(caida, 2, 550, {self.mov(false)}, direccion)
			}
		}
	}
	
	method ejecutarMovimiento(sprite, velocidad, tiempoRefractario, tipoDeReposo, direccion){
				animator.cambiarAnimate(self, sprite)
				velocidad.times({ i => game.schedule(tiempoRefractario * (i - 1) / 2, { self.mover(direccion)})})
				game.schedule(tiempoRefractario, tipoDeReposo)

	}
		
	//ATAQUES
		
	method condicionesDeAtaque() = self.grounded() and tieneEspada and !atacando and vivo 

	method ataquesEnCombo(numeroDeAtaque) = ataquesEnCombo.get(numeroDeAtaque - 1)

	method ataquesEnCombo(numeroDeAtaque, bool){
		ataquesEnCombo = [{self.condicionesDeAtaque()}, if (numeroDeAtaque == 1) bool else self.ataquesEnCombo(2), if (numeroDeAtaque == 2) bool else self.ataquesEnCombo(3)]
	}

	method ataqueDePlayer(numero) = ataquesDePlayer.get(numero - 1)

	method animadorAtaques(tiempoAnimacion, alcanceAtaque, danho) {
		if (miraDerecha) {
			game.schedule(tiempoAnimacion, { ataque.position(self.position().right(3))})
			ataque.danho(danho)
			alcanceAtaque.times({ i => game.schedule(tiempoAnimacion + 150 * (i / 4), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		} else {
			game.schedule(tiempoAnimacion, { ataque.position(self.position().right(2))})
			ataque.danho(danho)
			alcanceAtaque.times({ i => game.schedule(tiempoAnimacion + 150 * (i / 4), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		}
	}

	method animAtacar(numeroDeAtaque) {
		animator.cambiarAnimate(self, self.ataqueDePlayer(numeroDeAtaque))
		self.animadorAtaques(self.ataqueDePlayer(numeroDeAtaque).tiempoAnimacion(),
								self.ataqueDePlayer(numeroDeAtaque).alcanceAtaque(),
								self.ataqueDePlayer(numeroDeAtaque).danho()
								)
	}

	method atacando(bool) {
		if (!att_combo) {
			atacando = bool
		}
	}

	method atacar(numeroDeAtaque){
		if (self.ataquesEnCombo(numeroDeAtaque).apply()){
			mov = true
			atacando = true
			self.animAtacar(numeroDeAtaque)
			game.schedule(550, { self.atacando(false)} )
			game.schedule(325, { self.ataquesEnCombo(numeroDeAtaque, {true})})
			game.schedule(575, {self.ataquesEnCombo(numeroDeAtaque, {false})})
			game.schedule(600, { self.jugadorEnReposo()})
		
		if (numeroDeAtaque > 1){
			self.ataquesEnCombo(numeroDeAtaque - 1, {false})
			att_combo = true
			game.schedule(350, { self.att_combo(false)})
			game.schedule(350 / 2, { self.mover(miraDerecha)})
		}
		if (numeroDeAtaque == 3){
			5.times({ i => game.schedule(150 + 200 * (i / 8), { self.mover(miraDerecha)})})
			vulnerable = false
			game.schedule(550, { vulnerable = true } )
		}
	}
	}


	method transportar(pos) {
		const diffX = pos.x() - position.x()
		const diffY = pos.y() - position.y()
		hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().right(diffX).up(diffY))})
		position = pos
	}

	method mover(direccion) {
		const signo = if (direccion) 1 else -1
		position = position.right(signo)
		hitbox.forEach({ unHitbox => unHitbox.position(unHitbox.position().right(signo))})
	}

	method detener() {
		if (juego.tickEvents().contains("anima")) {
			game.removeTickEvent("anima")
			juego.tickEvents().remove("anima")
		}
	}

	method morir() {
		self.quitarVida()
		animator.cambiarAnimate(self, muere)
		game.schedule(450, { game.removeTickEvent("anima")})
		game.schedule(450, { juego.tickEvents().remove("anima")})
		game.say(self, "Game Over")
		if (juego.tickEvents().contains("tiempo")) {
			game.removeTickEvent("tiempo")
			juego.tickEvents().remove("tiempo")
		}
		game.schedule(1000, { game.say(self, "Apreta R para reiniciar")})
	}

	method quitarVida() {
		vivo = false
	}

	method iniciar() {
		vivo = true
		self.todaLaVida()
		self.transportar(self.posicionInicial())
		tieneEspada = false
		sprites = idle
		if (!juego.tickEvents().contains("anima")) {
			animator.aplicarAnimate(self, sprites)
		}
	}

	method estaVivo() {
		return vivo
	}

	method mostrarPosicion() {
		console.println(self.position())
	}

	method serAtacado(x) {
	}

}

