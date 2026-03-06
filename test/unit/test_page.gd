extends GutTest

var width: int = 100
var height: int = 200
var page: Page


func before_each():
	page = Page.new(width, height)


func test_page_creation():
	assert_not_null(page, "Page existence")


func test_page_image():
	var images = page.layers

	assert_not_null(images[0], "Background image existence")
	assert_eq(images[0].get_width(), width, "Background width check")
	assert_eq(images[0].get_height(), height, "Background height check")

	assert_not_null(images[1], "Foreground image existence")
	assert_eq(images[1].get_width(), width, "Foreground width check")
	assert_eq(images[1].get_height(), height, "Foreground height check")

	page.create_layer(width, height)
	images = page.layers
	assert_not_null(images[2], "New image existence")
	assert_eq(images[2].get_width(), width, "New width check")
	assert_eq(images[2].get_height(), height, "New height check")


func test_page_texture():
	var textures = page.get_content()

	assert_not_null(textures[0], "Background texture existence")
	assert_eq(textures[0].get_width(), width, "Background width check")
	assert_eq(textures[0].get_height(), height, "Background height check")

	assert_not_null(textures[1], "Foreground texture existence")
	assert_eq(textures[1].get_width(), width, "Foreground width check")
	assert_eq(textures[1].get_height(), height, "Foreground height check")

	page.create_layer(width, height)
	textures = page.get_content()
	assert_not_null(textures[2], "New texture existence")
	assert_eq(textures[2].get_width(), width, "New width check")
	assert_eq(textures[2].get_height(), height, "New height check")
