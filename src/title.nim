import
  nimgame2 / [
    assets,
    entity,
    font,
    gui/button,
    gui/widget,
    mosaic,
    nimgame,
    scene,
    settings,
    textgraphic,
    texturegraphic,
    types,
  ],
  data


type
  TitleScene = ref object of Scene


proc play(widget: GuiWidget) =
  game.scene = mainScene


proc exit(widget: GuiWidget) =
  gameRunning = false


proc init*(scene: TitleScene) =
  init Scene(scene)
  var
    btnPlay, btnExit: GuiButton
    btnPlayLabel, btnExitLabel: TextGraphic
  btnPlayLabel = newTextGraphic defaultFont
  btnPlayLabel.setText "PLAY"
  btnPlay = newGuiButton(buttonSkin, btnPlayLabel)
  btnPlay.centrify()
  btnPlay.pos = (GameWidth / 2, GameHeight / 2)
  btnPlay.action = play
  scene.add btnPlay

  btnExitLabel = newTextGraphic defaultFont
  btnExitLabel.setText "EXIT"
  btnExit = newGuiButton(buttonSkin, btnExitLabel)
  btnExit.centrify()
  btnExit.pos = (GameWidth / 2, GameHeight / 2 + 64)
  btnExit.action = exit
  scene.add btnExit


proc free*(scene: TitleScene) =
  discard


proc newTitleScene*(): TitleScene =
  new result, free
  init result

