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
  TitleScene = ref object of Scene


proc init*(scene: TitleScene) =
  init Scene(scene)


proc free*(scene: TitleScene) =
  discard


proc newTitleScene*(): TitleScene =
  new result, free
  init result

