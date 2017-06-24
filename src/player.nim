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
  PlayerRadius = 16
  PlayerSize = PlayerRadius * 2
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


proc init*(player: Player, graphic: TextureGraphic, level: Level) =
  player.initEntity()
  player.level = level
  player.graphic = graphic
  player.initSprite((PlayerSize, PlayerSize))
  discard player.addAnimation("right", [0, 1, 2, 3], Framerate)
  discard player.addAnimation("left", [0, 1, 2, 3], Framerate, Flip.horizontal)
  discard player.addAnimation("death", [4, 5, 6, 7], Framerate)

  player.collider = newCircleCollider(
    player, (PlayerRadius, PlayerRadius), PlayerRadius)

  player.physics = new Physics


proc newPlayer*(graphic: TextureGraphic, level: Level): Player =
  new result
  result.init(graphic, level)


proc jump*(player: Player, elapsed: float) =
  discard


method update*(player: Player, elapsed: float) =
  player.updateEntity elapsed


proc updatePhysics(player: Player, elapsed: float) =
  discard
  # physics here


method update*(physics: Physics, player: Player, elapsed: float) =
  player.updatePhysics elapsed

