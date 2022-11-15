import wollok.game.*
import juego.*
import player.*
import HUD.*
import espada.*
import plataformas.*
import teletransportadores.*
import puerta.*
import niveles.*
import playerHit.*
import obtenibles.*
import enemigos.*

class Animable {

	var property position
	const property animator
	var property miraDerecha = false
	var property numeroDeSprite = 1
	var spriteInicial
	var property sprites = spriteInicial

	method image() = animator.darImagen(self)

	method proximoSprite() {
		numeroDeSprite += 1
	}

}

class Sprite {

	const property cantidadDeSprites
	const property nombre
	const property time = 10 ** 5

	method image(animable) = "assets/" + nombre + "_" + if (animable.miraDerecha()) {"right"} else {"left"} + animable.numeroDeSprite().toString() + ".png"

}

class SpriteDeAtaque inherits Sprite(time = 75, cantidadDeSprites = 7){

	const property tiempoAnimacion

	const property alcanceAtaque

	const property danho

	var property ataqueEnCombo = false

	var miraDerecha = false

	method condicion(jugador) 

	method animarAtaques(jugador) {
		if (miraDerecha) {
			game.schedule(tiempoAnimacion, { ataque.position(jugador.position().right(3))})
			ataque.danho(danho)
			alcanceAtaque.times({ i => game.schedule(tiempoAnimacion + 150 * (i / 4), { ataque.mover(false)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		} else {
			game.schedule(tiempoAnimacion, { ataque.position(jugador.position().right(2))})
			ataque.danho(danho)
			alcanceAtaque.times({ i => game.schedule(tiempoAnimacion + 150 * (i / 4), { ataque.mover(true)})})
			game.schedule(375, { ataque.position(game.at(juego.tamanho(), juego.tamanho()))})
		}
	}

	method animAtacar(jugador)
	 {
		jugador.animator().cambiarAnimate(jugador, self)
		self.animarAtaques(jugador)
	}

	method realizarAtaque(jugador){
			miraDerecha = jugador.miraDerecha()
			jugador.mov(true)
			jugador.atacando(true)
			self.animAtacar(jugador)
			game.schedule(550, { jugador.atacando(false)} )
			game.schedule(325, { self.ataqueEnCombo(true)}) 
			game.schedule(575, { self.ataqueEnCombo(false)})
			game.schedule(600, { jugador.jugadorEnReposo()})
		
	}
	}

object att1 inherits SpriteDeAtaque(nombre = "att1", tiempoAnimacion = 150 , alcanceAtaque = 3 , danho = 1){

	override method condicion(jugador) = jugador.condicionesDeAtt1()

}

object att2 inherits SpriteDeAtaque(nombre = "att2", tiempoAnimacion = 150 , alcanceAtaque = 4 , danho = 2){

	method ataqueAnterior() = att1

	override method condicion(jugador) = self.ataqueAnterior().ataqueEnCombo()

	override method realizarAtaque(jugador){
		super(jugador)
		self.ataqueAnterior().ataqueEnCombo(false)
		player.att_combo(true)
		game.schedule(350, { jugador.att_combo(false)})
		game.schedule(350 / 2, { jugador.mover(miraDerecha)})

	}

}

object att3 inherits SpriteDeAtaque(nombre = "att3", tiempoAnimacion = 75 , alcanceAtaque = 11 , danho = 5){
	
	method ataqueAnterior() = att2

	override method condicion(jugador) = self.ataqueAnterior().ataqueEnCombo()

	override method realizarAtaque(jugador){
		super(jugador)
		self.ataqueAnterior().ataqueEnCombo(false)
		player.att_combo(true)
		game.schedule(350, { jugador.att_combo(false)})
		game.schedule(350 / 2, { jugador.mover(miraDerecha)})
		5.times({ i => game.schedule(150 + 200 * (i / 8), { jugador.mover(miraDerecha)})})
		jugador.vulnerable(false)
		game.schedule(550, { jugador.vulnerable(true) } )

	}

}





//Player
const salto = new Sprite(cantidadDeSprites = 1, nombre = "salto")

const muere = new Sprite(cantidadDeSprites = 5, nombre = "muere", time = 125)

const idle = new Sprite(cantidadDeSprites = 1, nombre = "idle")

const idle_espada = new Sprite(cantidadDeSprites = 1, nombre = "idle_espada")

const walk = new Sprite(cantidadDeSprites = 6, nombre = "walk", time = 150)

const caida = new Sprite(cantidadDeSprites = 1, nombre = "caida")

//Enemigos
const slime = new Sprite(cantidadDeSprites = 10, nombre = "slime")

const slimeRojo = new Sprite(cantidadDeSprites = 10, nombre = "slimeRojo")

const ghost = new Sprite(cantidadDeSprites = 8, nombre = "ghost")

const boss = new Sprite(cantidadDeSprites = 9, nombre = "boss")

const bossDanho = new Sprite(cantidadDeSprites = 1, nombre = "bossDanho")

//Extra
const apretaEspacio = new Sprite(cantidadDeSprites = 2, nombre = "apretaEspacio")

class Animator {

	method darImagen(animable) = animable.sprites().image(animable)

	method animate(animable) {
		if (animable.numeroDeSprite() < animable.sprites().cantidadDeSprites()) {
			animable.proximoSprite()
		} else {
			animable.numeroDeSprite(1)
		}
	}

	method cambiarAnimate(animable, nuevoSprite) {
		animable.sprites(nuevoSprite)
	}

}

object playerAnimator inherits Animator {

	override method cambiarAnimate(animable, nuevoSprite) {
		game.removeTickEvent("anima")
		juego.tickEvents().remove("anima")
		animable.numeroDeSprite(1)
		animable.sprites(nuevoSprite)
		self.aplicarAnimate(animable, nuevoSprite)
	}

	method aplicarAnimate(animable, sprite) {
		game.onTick(sprite.time(), "anima", { self.animate(animable)})
		juego.tickEvents().add("anima")
	}

}

object enemyAnimator inherits Animator {

}

object bossAnimator inherits Animator {

	override method cambiarAnimate(animable, nuevoSprite) {
		animable.numeroDeSprite(1)
		super(animable, nuevoSprite)
	}

	override method animate(animable) {
		if (player.position().x() <= 15) {
			animable.miraDerecha(false)
		} else {
			animable.miraDerecha(true)
		}
		super(animable)
	}

}

