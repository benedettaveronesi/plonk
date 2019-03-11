# Makefile
# Daniel Mentiplay, 2019.

splash:
	@cd plonk/visualization/splash; \
	python setup.py build_ext --inplace; \
	cd - > /dev/null

clean:
	@rm plonk/visualization/splash/*.o;     \
	rm plonk/visualization/splash/*.mod;    \
	rm plonk/visualization/splash/*.so;     \
	rm -r plonk/visualization/splash/build; \
	rm plonk/visualization/splash/splash_wrapper.c
