-- Delete Nearest Marker (34tools)
-- Line: 34tools Edit
-- 34tools — Audio Tools by Alexey Vorobyov (34birds)
-- @version 1.0.0
-- @author Alexey Vorobyov (34birds)
-- @about
--   Part of 34tools (34tools Edit). REAPER Lua script. No js_ReaScriptAPI required.
-- @description 34tools: Delete Nearest Marker — Delete the nearest project marker (not region) to the edit cursor. Line: 34tools Edit. Version: 1.0.0. License: MIT.
-- @license MIT.

--[[--------------------------------------------------------------------
  34tools: Delete Nearest Marker
  ----------------------------------------------------------------------
  Назначение:
    По хоткею удаляет ближайший MARKER к позиции edit cursor.
    Ближайший = по абсолютной дистанции (по модулю):
      distance = abs(marker_pos - cursor_pos)

  Важно:
    - Удаляются ТОЛЬКО маркеры (marker). Регионы (regions) игнорируются.
    - Если в проекте нет маркеров (только регионы или пусто) — ничего не делает.
    - Курсор берётся из edit cursor (GetCursorPosition).

  Установка:
    1) Actions → Show action list…
    2) ReaScript → Load… → выбрать этот файл
    3) Назначить хоткей (Add… в Shortcuts for selected action)

  Логика работы (кратко):
    1) Получаем позицию edit cursor.
    2) Перечисляем все маркеры/регионы в проекте.
    3) Для каждого элемента:
         - если это маркер: считаем abs(pos - cursor_pos)
         - запоминаем маркер с минимальной дистанцией
    4) Удаляем найденный маркер через DeleteProjectMarkerByIndex().
----------------------------------------------------------------------]]


-- ---------------------------------------------------------------------
-- MAIN
-- ---------------------------------------------------------------------
local function main()
  -- 1) Позиция edit cursor в секундах (double)
  local cursor_pos = reaper.GetCursorPosition()

  -- 2) Кол-во маркеров и регионов в текущем проекте
  --    CountProjectMarkers() возвращает:
  --      retval, num_markers, num_regions
  local _, num_markers, num_regions = reaper.CountProjectMarkers(0)
  local total = num_markers + num_regions

  -- Если в проекте вообще ничего нет — выходим молча
  if total == 0 then return end

  -- 3) Ищем ближайший marker (не region)
  local nearest_enum_idx = nil      -- индекс в "перечислении" EnumProjectMarkers3()
  local nearest_dist = math.huge    -- минимальная найденная дистанция

  for i = 0, total - 1 do
    -- EnumProjectMarkers3() возвращает:
    --   retval, isrgn, pos, rgnend, name, markrgnindexnumber, color
    -- Для нашей задачи нам важны:
    --   isrgn (это регион?)
    --   pos   (позиция маркера/начала региона)
    local retval, isrgn, pos = reaper.EnumProjectMarkers3(0, i)

    -- Берём только маркеры
    if retval and not isrgn then
      local d = math.abs(pos - cursor_pos)
      if d < nearest_dist then
        nearest_dist = d
        nearest_enum_idx = i
      end
    end
  end

  -- Если nearest_enum_idx не найден — значит маркеров нет (только регионы)
  if nearest_enum_idx == nil then return end

  -- 4) Удаляем найденный маркер (в Undo-блоке)
  reaper.Undo_BeginBlock()
  reaper.DeleteProjectMarkerByIndex(0, nearest_enum_idx)
  reaper.Undo_EndBlock("34tools: Delete nearest marker to edit cursor", -1)

  -- 5) Обновляем arrange
  reaper.UpdateArrange()
end

main()
