python gen-tile-map.py tile-map.tmx 0 0xfffffff >../src/tile_map.asm
python gen-charset.py custom-charset.png >../src/charset.asm
python gen-sprites-data.py 0 sprites-48.png >../src/sprites.asm
python gen-render-rows.py >../src/render_rows.asm
rem python gen-screen-lut.py >../src/screen_lut.asm
