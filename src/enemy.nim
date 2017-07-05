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
  WalkVel = 10


type
  Enemy* = ref object of Entity
    level*: Level


proc right*(enemy: Enemy) =
  enemy.vel.x = WalkVel


proc left*(enemy: Enemy) =
  enemy.vel.x -= WalkVel


proc enemyLogic(enemy: Entity, elapsed: float) =
  discard #TODO


proc init*(enemy: Enemy, graphic: TextureGraphic, level: Level) =
  enemy.initEntity()
  enemy.tags.add "enemy"
  enemy.level = level
  enemy.graphic = graphic
  enemy.logic = enemyLogic

  # collider
  let c = newPolyCollider(enemy, points = [(0.0, 15.0), (15, 0), (31, 15)])
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
  enemy.logic(enemy, elapsed)
  let index = enemy.level.tileIndex(enemy.pos)
  # check collisions only if visible
  if index.x in enemy.level.show.x and index.y in enemy.level.show.y:
    enemy.physics(enemy, elapsed)

