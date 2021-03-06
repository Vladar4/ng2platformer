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


const
  TileDim* = (32, 32)


type
  Level* = ref object of TileMap


proc init*(level: Level, tiles: TextureGraphic) =
  init Tilemap level
  level.tags.add "level"
  level.graphic = tiles
  level.initSprite(TileDim)


proc newLevel*(tiles: TextureGraphic): Level =
  new result
  result.init(tiles)


proc load*(level: Level, csv: string) =
  level.map = loadCSV[int](
    csv,
    proc(input: string): int = discard parseInt(input, result))

  level.hidden.add @[8, 9, 10, 11]  # tiles on the third row are invisible markers
  level.passable.add @[0, 2, 3, 4, 8, 9, 10, 11] # tiles without colliders
  level.onlyReachableColliders = true # do not init unreachable colliders
  level.initCollider()
  level.collider.tags.add "nil" # do not check for collisions

