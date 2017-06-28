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
  ColliderRadius = PlayerRadius - 1
  Framerate = 1/12
  VisibilityDim: Dim = (w: 9, h: 6)
  GravAcc = 1000
  Drag = 800
  JumpVel = 450
  WalkVel = 10


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
    player, (PlayerRadius, PlayerRadius), ColliderRadius)

  player.acc.y = GravAcc
  player.drg.x = Drag
  player.physics = platformerPhysics


proc newPlayer*(graphic: TextureGraphic, level: Level): Player =
  new result
  result.init(graphic, level)


proc jump*(player: Player, elapsed: float) =
  if player.vel.y == 0.0:
    player.vel.y -= JumpVel


proc right*(player: Player, elapsed: float) =
  player.vel.x += WalkVel
  if not player.sprite.playing and player.vel.y == 0.0:
    player.play("right", 1)


proc left*(player: Player, elapsed: float) =
  player.vel.x -= WalkVel
  if not player.sprite.playing and player.vel.y == 0.0:
    player.play("left", 1)


method update*(player: Player, elapsed: float) =
  player.updateEntity elapsed

