import wollok.game.*
import espada.*
import juego.*
import player.*
import moneda.*
import healPack.*
import enemigos.*

class Ghost inherits Enemigo( danho = 2,
							  mensaje = [ "Es la parca", "Que es esa cosa?"], 
							  sprite_mov =["assets/ghost1.png","assets/ghost2.png","assets/ghost3.png","assets/ghost4.png","assets/ghost5.png",
											"assets/ghost6.png","assets/ghost7.png","assets/ghost8.png"])
{
	
	override method serAtacado(x){	
				game.say(self,"jajaja soy inmune a tus ataques")
		
	}
	

}



