import
  parseutils,
  nimgame2 / [
    assets,
    entity,
    texturegraphic,
    tilemap,
    types,
    utils,
  ],
  data

type
  Level* = ref object of TileMap


proc init*(level: Level, tiles: TextureGraphic) =
  init Tilemap level
  level.tags.add("level")
  level.graphic = tiles
  level.initSprite((32, 32))


proc newLevel*(tiles: TextureGraphic): Level =
  new result
  result.init(tiles)


proc load*(level: Level, csv: string) =
  level.map = loadCSV[int](
    csv,
    proc(input: string): int = discard parseInt(input, result))

  level.hidden.add @[8, 9, 10, 11]  # tiles on a third row are invisible markers

  level.passable.add @[0, 8, 9, 10, 11] # tiles without colliders
  level.initCollider()

