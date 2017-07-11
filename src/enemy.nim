import
  nimgame2 / [
    collider,
    entity,
    graphic,
    texturegraphic,
    tilemap,
    types,
  ],
  data,
  level


const
  GravAcc = 1000
  WalkVel = 50


type
  Enemy* = ref object of Entity
    level*: Level
    prevVel: float


proc right*(enemy: Enemy) =
  enemy.vel.x = WalkVel


proc left*(enemy: Enemy) =
  enemy.vel.x -= WalkVel


proc enemyLogic(enemy: Entity, elapsed: float) =
  let enemy = Enemy enemy

  # check for pits
  if enemy.vel.x != 0.0:
    let
      pos = enemy.pos + enemy.graphic.dim * 0.5 *
        (if enemy.vel.x < 0: -1.0 else: 1.0)
      aheadIdx = enemy.level.tileIndex(pos) + (0, 1)
    if enemy.level.tile(aheadIdx) in enemy.level.passable:
      enemy.vel.x = 0.0

  # change direction
  if enemy.vel.x == 0.0:
    if enemy.prevVel <= 0.0:
      enemy.vel.x = WalkVel
      enemy.prevVel = WalkVel
    else:
      enemy.vel.x = -WalkVel
      enemy.prevVel = -WalkVel


proc init*(enemy: Enemy, graphic: TextureGraphic, level: Level) =
  enemy.initEntity()
  enemy.tags.add "enemy"
  enemy.level = level
  enemy.graphic = graphic
  enemy.centrify(ver = VAlign.top)
  enemy.logic = enemyLogic

  # collider
  let c = newPolyCollider(enemy, points = [(-15.0, 15.0), (0, 0), (16, 15)])
  c.tags.add "level"
  enemy.collider = c

  # physics
  enemy.acc.y = GravAcc
  enemy.fastPhysics = true
  enemy.physics = platformerPhysics


proc newEnemy*(graphic: TextureGraphic, level: Level): Enemy =
  new result
  result.init(graphic, level)


method update*(enemy: Enemy, elapsed: float) =
  # updateEntity override
  let index = enemy.level.tileIndex(enemy.pos)
  # physics and logic only if visible
  if index.x in enemy.level.show.x and index.y in enemy.level.show.y:
    enemy.logic(enemy, elapsed)
    enemy.physics(enemy, elapsed)

