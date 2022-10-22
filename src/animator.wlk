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
	const animator
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

//Player
const salto = new Sprite(cantidadDeSprites = 1, nombre = "salto")

const muere = new Sprite(cantidadDeSprites = 5, nombre = "muere", time = 125)

const att1 = new Sprite(cantidadDeSprites = 7, nombre = "att1", time = 75)

const att2 = new Sprite(cantidadDeSprites = 7, nombre = "att2", time = 75)

const att3 = new Sprite(cantidadDeSprites = 7, nombre = "att3", time = 75)

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

