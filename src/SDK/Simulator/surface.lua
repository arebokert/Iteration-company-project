local class     = require( "SDK.Lib.classy" )
local surface   = class("surface")

--*********** HELPER FUNCTIONS ***************

---
--
function surface:__init()
  self.image_data = nil
end

function surface:__init(width, height)

  if width == nil and height == nil then

    self.image_data = nil
  else
      ADLogger.trace(width..","..height)
      self.image_data = love.image.newImageData(width, height)
  end
end
---
-- @param path the path to the image
function surface:loadImage(path)
  ADLogger.trace(path)
  local tempFile = io.open(path,"rb")
  if tempFile then
    local imageStream = tempFile:read("*a")
    tempFile:close()
    local fileData, err = love.filesystem.newFileData(imageStream, path)
    self.image_data = love.image.newImageData(fileData)
  else
    ADLogger.error("Error loading image - '"..path.."'")
  end

end

function surface:writeOver(text, fontColor, drawingStartPoint)
  local canvas = love.graphics.newCanvas(self.image_data:getDimensions())
  love.graphics.setCanvas( canvas )

  love.graphics.draw(love.graphics.newImage(self.image_data))

  local r, g, b, a = love.graphics.getColor( )
  love.graphics.setColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
  love.graphics.print(text, drawingStartPoint.x, drawingStartPoint.y)
  love.graphics.setColor(r, g, b, a)

  love.graphics.setCanvas()

  self.image_data = canvas:getImageData()
  canvas = {}
end

---
-- *************** Zenterio API Doc ********************************
-- Fills the surface with a solid color, using hardware acceleration.
-- Surface transparency is replaced by the transparency value of
-- <color>.
-- Default color is {0, 0, 0, 0}, that is black and completely transparent.
-- Default rectangle is the whole surface. Parts outside the rectangle
-- are not affected.
-- *****************************************************************
-- @param color fill colour
-- @param rectangle area to clear
function surface:clear(color, rectangle)



  --Defaults to transparent black
  local c = {
    r = 0,
    g = 0,
    b = 0,
    a = 0
  }

  if color ~= nil then
    c.r = color.r or 0
    c.g = color.g or 0
    c.b = color.b or 0
    c.a = color.a or 255
  end

  --Defaults to enture surface

  local rect = {
    x = 0,
    y = 0,
    width = self.image_data:getWidth(),
    height = self.image_data:getHeight()
  }

  if rectangle ~= nil then
    rect.x = rectangle.x or 0
    rect.y = rectangle.y or 0

    --Make sure that we do not fill outside of the bounds of the rectangle
    if rect.x + (rectangle.width or rectangle.w) <= rect.width then
      rect.width = (rectangle.width or rectangle.w)
    end

    if rect.y + (rectangle.height or rectangle.h) <= rect.height then
      rect.height = (rectangle.height or rectangle.h)
    end
  end

  local w = rect.x + rect.width - 1
  local h = rect.y + rect.height - 1
  for i=rect.x, w do
    for j=rect.y, h do
      self.image_data:setPixel(i,j,c.r, c.g, c.b, c.a)
    end
  end
end


function surface:draw()
  image = love.graphics.newImage(self.image_data)
  function love.draw()
    love.graphics.draw(image)
  end


end


---
-- *************** Zenterio API Doc ********************************
-- Blends the surface with a solid color, weighing alpha values
-- (SRCOVER). Uses hardware acceleration.
-- Default rectangle is the whole surface. Parts outside the rectangle
-- are not affected.
-- *****************************************************************
-- @param color fill colour
-- @param rectangle area to fill
function surface:fill(color, rectangle)
  --Not currently implemented - same as surface:clear
  self:clear(color, rectangle)
end

function surface:get()
  return self.image_data
end

---
---Copy Surface
-- *************** Zenterio API Doc ********************************
-- Copy pixels from one surface to another, using hardware
-- acceleration. Parts or all of <src_surface> can be copied.

-- Scaling is done if dest_rectangle is of different size than
-- src_rectangle. Areas outside of source or destination surfaces are
-- (will be) clipped.

-- If <src_rectangle> is nil, the whole <src_surface> is used.

-- If <dest_rectangle> is nil or omitted, x=0, y=0 are assumed and
-- width and height are taken from <src_rectangle>. If <dest_rectangle>
-- doesn't specify width or height, these values are also taken from
-- <src_rectangle>.

-- If <blend_option> is true, copying is blended using the alpha
-- information in <src_surface>. If false, the alpha channel is
-- replaced by the values in <src_surface>.
-- Default is false.
-- *****************************************************************
-- @param src_surface surface to copy from
-- @param src_rect source rectangle
-- @param dest_rect destination rectangle
-- @param blend_option
function surface:copyfrom(src_surface, src_rect, dest_rect, blend_option)

  --Defaults to entire surface
  local source_rectangle = {}

  --if src_rect is nil, defaul to entire source surface
  if src_rect == nil then
    source_rectangle.x = 0
    source_rectangle.y = 0
    source_rectangle.w = src_surface.image_data:getWidth()
    source_rectangle.h = src_surface.image_data:getHeight()
  else
    source_rectangle.x = src_rect.x or 0
    source_rectangle.y = src_rect.y or 0
    source_rectangle.w = src_rect.w or src_surface.image_data:getWidth()
    source_rectangle.h = src_rect.h or src_surface.image_data:getHeight()
  end

  local destination_rectangle = {}

  --if src_rect is nil, defaul to enture source surface
  if dest_rect == nil then
    destination_rectangle.x = 0
    destination_rectangle.y = 0
    destination_rectangle.w = src_surface.image_data:getWidth()
    destination_rectangle.h = src_surface.image_data:getHeight()
  else
    destination_rectangle.x = dest_rect.x or 0
    destination_rectangle.y = dest_rect.y or 0
    destination_rectangle.w = dest_rect.w or src_surface.image_data:getWidth()
    destination_rectangle.h = dest_rect.h or src_surface.image_data:getHeight()
  end


  local scale_x = destination_rectangle.w / source_rectangle.w
  local scale_y = destination_rectangle.h / source_rectangle.h

  local canvas = love.graphics.newCanvas(self.image_data:getDimensions())
  love.graphics.setCanvas( canvas )

  love.graphics.draw(love.graphics.newImage(self.image_data))
  love.graphics.draw(love.graphics.newImage(src_surface.image_data),destination_rectangle.x,destination_rectangle.y, 0, scale_x, scale_y)

  love.graphics.setCanvas()

  self.image_data = canvas:getImageData()
  canvas = {}

end



---Get Width
-- *************** Zenterio API Doc ********************************
-- Returns the pixel width (X axis) of the surface
-- *****************************************************************
function surface:get_width()
  return self.image_data:getWidth()
end

---Get Height
-- *************** Zenterio API Doc ********************************
--  Returns the pixel height (Y axis) of the surface
-- *****************************************************************
function surface:get_height()
  return self.image_data:getHeight()
end

---Get Pixel
-- *************** Zenterio API Doc ********************************
--  Returns the color value at position <x>, <y>, starting with index (0, 0).
--  Mostly for testing, not optimized for speed
-- *****************************************************************
-- @param x
-- @param y
-- @return r, g, b, a
function surface:get_pixel(x, y)
  r, g, b, a = self.image_data:getPixel( x, y )
  return r, g, b, a
end

---Set Pixel
-- *************** Zenterio API Doc ********************************
--  Sets the pixel at position <x>, <y> to <color>.
--  Mostly for testing, not optimized for speed
-- *****************************************************************
-- @param x
-- @param y
function surface:set_pixel(x, y, color)
  self.image_data:setPixel(x, y, color.r, color.g, color.b, color.a)
end

---
---Preumltiply
-- *************** Zenterio API Doc ********************************
-- Changes the surface pixel components by multiplying the alpha
-- channel into the color channels. This prepares some images for
-- blending with transparency.
-- *****************************************************************
function surface:premultiply()
-- Not currently implemented
end

---
---Destroy
-- *************** Zenterio API Doc ********************************
-- Frees the graphics memory used by this surface. The same is
-- eventually done automatically by Lua garbage collection for
-- unreferenced surfaces but doing it by hand guarantees the memory is
-- returned at once.
-- The surface can not be used again after this operation.
-- *****************************************************************
function surface:destroy()
  self.image_data = nil
end

---
---Set Alpha
-- *************** Zenterio API Doc ********************************
-- Set alpha channel for all pixels on the surface.
-- *****************************************************************
-- @param alpha
function surface:set_alpha(alpha)
  for i=0, self.image_data:getWidth()-1 do
    for j=0, self.image_data:getHeight()-1 do
      r, g, b, a = self.image_data:getPixel( i, j )
      self.image_data:setPixel(i, j, r, g, b, alpha)
    end
  end
end


return surface
