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
  VisibilityDim: Dim = (w: 9, h: 6)


type
  Player* = ref object of Entity
    level*: Level


proc updateVisibility*(player: Player) =
  let
    center = player.level.tileIndex(player.pos)
  player.level.show = (
    x: (center.x - VisibilityDim.w)..(center.x + VisibilityDim.w),
    y: (center.y - VisibilityDim.h)..(center.y + VisibilityDim.h))
  echo center


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

