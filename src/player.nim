import
  nimgame2 / [
    collider,
    entity,
    texturegraphic,
    tilemap,
    types,
  ],
  data,
  level


const
  Framerate = 1/12
  VisibilityDim: Dim = (w: 10, h: 6)
  Spawn = 8 # player spawn selector tile index
  PlayerRadius = 16
  PlayerSize = PlayerRadius * 2
  ColliderRadius = PlayerRadius - 1
  GravAcc = 1000
  Drag = 800
  JumpVel = 450
  WalkVel = 10


type
  Player* = ref object of Entity
    level*: Level
    dying: bool
    requestCoins*: seq[CoordInt]



proc updateVisibility*(player: Player) =
  # update the visible portion of the map
  let center = player.level.tileIndex(player.pos)
  player.level.show = (
    x: (center.x - VisibilityDim.w)..(center.x + VisibilityDim.w),
    y: (center.y - VisibilityDim.h)..(center.y + VisibilityDim.h))


proc resetPosition*(player: Player) =
  # reset player position to a given tile
  player.pos = player.level.tilePos player.level.firstTileIndex(Spawn)


proc init*(player: Player, graphic: TextureGraphic, level: Level) =
  player.initEntity()
  player.tags.add "player"
  player.level = level
  player.graphic = graphic
  player.initSprite((PlayerSize, PlayerSize))
  discard player.addAnimation("right", [0, 1, 2, 3], Framerate)
  discard player.addAnimation("left", [0, 1, 2, 3], Framerate, Flip.horizontal)
  discard player.addAnimation("death", [4, 5, 6, 7], Framerate)

  # collider
  let c = newGroupCollider(player)
  player.collider = c
  # 1st collider
  c.list.add newCircleCollider(
    player,
    (PlayerRadius, PlayerRadius),
    ColliderRadius)
  # 2nd collider
  c.list.add newBoxCollider(
    player,
    (PlayerRadius, PlayerRadius + PlayerRadius div 2),
    (PlayerSize - 2, ColliderRadius))

  # physics
  player.acc.y = GravAcc
  player.drg.x = Drag
  player.physics = platformerPhysics

  player.requestCoins = @[]


proc newPlayer*(graphic: TextureGraphic, level: Level): Player =
  new result
  result.init(graphic, level)


proc jump*(player: Player) =
  if player.dying: return
  if player.vel.y == 0.0:
    player.vel.y -= JumpVel


proc right*(player: Player) =
  if player.dying: return
  player.vel.x += WalkVel
  if not player.sprite.playing and player.vel.y == 0.0:
    player.play("right", 1)


proc left*(player: Player) =
  if player.dying: return
  player.vel.x -= WalkVel
  if not player.sprite.playing and player.vel.y == 0.0:
    player.play("left", 1)


proc die*(player: Player) =
  if not player.dying:
    player.dying = true
    player.play("death", 3)
    player.vel.y = -JumpVel


method update*(player: Player, elapsed: float) =
  player.updateEntity elapsed
  player.updateVisibility()

  if player.dying:
    if not player.sprite.playing:
      # reset
      player.play("right", 0)
      player.resetPosition()
      player.updateVisibility()
      player.dying = false
    else:
      return


method onCollide*(player: Player, target: Entity) =
  if "spikes" in target.tags or "enemy" in target.tags:
    player.die()

  if "box" in target.tags:
    let index = player.level.tileIndex(target.pos)
    player.level.tile(index) += 1 # red box -> grey box
    player.requestCoins.add index + (0, -1) # request coin spawn one tile higher
    target.dead = true

  if "coin" in target.tags:
    inc score
    target.dead = true

