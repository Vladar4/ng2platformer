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
  level


type
  MainScene = ref object of Scene
    level: Level


proc init*(scene: MainScene) =
  init Scene scene
  scene.level = newLevel gfxData["tiles"]
  scene.level.load "data/csv/map1.csv"
  scene.add scene.level


proc free*(scene: MainScene) =
  discard


proc newMainScene*(): MainScene =
  new result, free
  init result

