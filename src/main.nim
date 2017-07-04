import
  nimgame2 / [
    assets,
    entity,
    font,
    gui/button,
    gui/widget,
    input,
    nimgame,
    scene,
    settings,
    textgraphic,
    tilemap,
    types,
  ],
  data,
  level,
  player


const
  LevelLayer = 0
  PlayerLayer = 10
  Spikes = 4  # Spikes tile index
  Box = 6     # Box tile index
  CoinA = 2   # Coin tile index (frame A)
  CoinB = 3   # Coin tile index (frame B)


type
  MainScene = ref object of Scene
    level: Level
    player: Player


proc spawnCoin*(scene: MainScene, index: CoordInt) =
  let e = newEntity()
  e.tags.add "coin"
  e.graphic = gfxData["tiles"]
  e.initSprite(TileDim)
  discard e.addAnimation("rotate", [2, 3], 1/8)
  e.play("rotate", -1) # continuous animation
  e.pos = scene.level.tilePos index
  e.collider = newCircleCollider(e, TileDim / 2 - 1, TileDim[0] / 2 - 1)
  e.collider.tags.add "player"
  scene.add e


proc init*(scene: MainScene) =
  init Scene scene

  # Camera
  scene.camera = newEntity()
  scene.cameraBondOffset = game.size / 2  # set camera to the center

  # Level
  scene.level = newLevel gfxData["tiles"]
  scene.level.load "data/csv/map1.csv"
  scene.level.layer = LevelLayer
  scene.add scene.level

  # Spikes
  const
    SpikesOrigin = TileDim / 2 + (0, TileDim[1] div 4)
    SpikesDim = TileDim / (1, 2)
  for tileCoord in scene.level.tileIndex(Spikes):
    let e = newEntity()
    e.tags.add "spikes"
    e.pos = scene.level.tilePos(tileCoord)
    e.collider = newBoxCollider(e, SpikesOrigin, SpikesDim)
    e.collider.tags.add "player" # collide only with player entity
    scene.add e

  # Boxes
  const
    BoxPos1 = (2, TileDim[1] + 2)
    BoxPos2 = (TileDim[0] - 2, TileDim[1] + 2)
  for tileCoord in scene.level.tileIndex(Box):
    let e = newEntity()
    e.tags.add "box"
    e.pos = scene.level.tilePos(tileCoord)
    e.collider = newLineCollider(e, BoxPos1, BoxPos2)
    e.collider.tags.add "player" # collide only with player entity
    scene.add e

  # Coins
  for value in [CoinA, CoinB]:
    for tileCoord in scene.level.tileIndex(value):
      scene.level.tile(tileCoord) = 0
      scene.spawnCoin(tileCoord)


  # Player
  scene.player = newPlayer(gfxData["player"], scene.level)
  scene.player.collisionEnvironment = @[Entity(scene.level)]
  scene.player.layer = PlayerLayer
  scene.player.resetPosition()
  scene.add scene.player

  scene.cameraBond = scene.player # bind camera to the player entity
  scene.player.updateVisibility()


proc free*(scene: MainScene) =
  discard


proc newMainScene*(): MainScene =
  new result, free
  init result


method event*(scene: MainScene, event: Event) =
  scene.eventScene event
  if event.kind == KeyDown:
    case event.key.keysym.sym:
    of K_F10:
      colliderOutline = not colliderOutline
    of K_F11:
      showInfo = not showInfo
    else: discard


method update*(scene: MainScene, elapsed: float) =
  scene.updateScene elapsed
  if ScancodeSpace.pressed:
    scene.player.jump()
  if ScancodeRight.down:
    scene.player.right()
  if ScancodeLeft.down:
    scene.player.left()

  # Spawn coins
  while scene.player.requestCoins.len > 0:
    scene.spawnCoin scene.player.requestCoins.pop()

