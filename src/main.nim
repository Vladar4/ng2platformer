import
  nimgame2 / [
    assets,
    entity,
    font,
    gui/button,
    gui/widget,
    nimgame,
    scene,
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

  MapPlayerSpawn = 8  # player spawn selector tile index


type
  MainScene = ref object of Scene
    level: Level
    player: Player


proc init*(scene: MainScene) =
  init Scene scene

  scene.camera = newEntity()
  scene.cameraBondOffset = game.size / 2  # set camera to the center

  scene.level = newLevel gfxData["tiles"]
  scene.level.load "data/csv/map1.csv"
  scene.level.layer = LevelLayer
  scene.add scene.level

  scene.player = newPlayer(gfxData["player"], scene.level)
  scene.player.layer = PlayerLayer
  scene.player.pos =
    scene.level.tilePos scene.level.firstTileIndex(MapPlayerSpawn) # positioning
  scene.add scene.player

  scene.cameraBond = scene.player # bind camera to the player entity



proc free*(scene: MainScene) =
  discard


proc newMainScene*(): MainScene =
  new result, free
  init result

