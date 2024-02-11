VERILATOR=verilator
VFLAGS = -O3 --x-assign fast --x-initial fast --noassert
SDL_CFLAGS = `sdl2-config --cflags`
SDL_LDFLAGS = `sdl2-config --libs`

pong: pong.mk
	make -C	./obj_dir -f Vtop_pong.mk

%.mk: top_%.v
	$(VERILATOR) ${VFLAGS} -I.. \
		-cc $< --exe $(basename $@).cpp -o $(basename $@) \
		-CFLAGS "${SDL_CFLAGS}" -LDFLAGS "${SDL_LDFLAGS}"
