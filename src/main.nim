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
    types,
  ],
  data,
  level,
  player


const
  LevelLayer = 0
  PlayerLayer = 10


type
  MainScene = ref object of Scene
    level: Level
    player: Player


proc init*(scene: MainScene) =
  init Scene scene

  scene.level = newLevel gfxData["tiles"]
  scene.level.load "data/csv/map1.csv"
  scene.level.layer = LevelLayer
  scene.add scene.level

  scene.player = newPlayer(gfxData["player"], scene.level)
  scene.player.layer = PlayerLayer
  scene.add scene.player


proc free*(scene: MainScene) =
  discard


proc newMainScene*(): MainScene =
  new result, free
  init result

