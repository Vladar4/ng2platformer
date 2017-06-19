import
  nimgame2 / [
    collider,
    entity,
    texturegraphic,
    tilemap,
    types,
  ],
  level


const
  Framerate = 1/12


type
  Player* = ref object of Entity
    level*: Level


proc init*(player: Player, graphic: TextureGraphic, level: Level) =
  player.initEntity()
  player.level = level
  player.graphic = graphic
  player.initSprite((32, 32))
  discard player.addAnimation("right", [0, 1, 2, 3], Framerate)
  discard player.addAnimation("left", [0, 1, 2, 3], Framerate, Flip.horizontal)
  discard player.addAnimation("death", [4, 5, 6, 7], Framerate)


proc newPlayer*(graphic: TextureGraphic, level: Level): Player =
  new result
  result.init(graphic, level)

