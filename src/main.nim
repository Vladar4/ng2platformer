import
  nimgame2 / [
    entity,
    font,
    gui/button,
    gui/widget,
    nimgame,
    scene,
    textgraphic,
    types,
  ]


type
  MainScene = ref object of Scene


proc init*(scene: MainScene) =
  init Scene(scene)


proc free*(scene: MainScene) =
  discard


proc newMainScene*(): MainScene =
  new result, free
  init result

